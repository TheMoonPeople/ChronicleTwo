#include "crash/crash.hpp"

#include <cxxabi.h>
#include <kazarov/log.hpp>
#include <platform/paths.hpp>

#include <algorithm>
#include <atomic>
#include <csignal>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <exception>
#include <typeinfo>

#include "crash/crash_capture.hpp"
#include "crash/crash_detail.hpp"
#include "log/log.hpp"

#ifndef _WIN32
#include <poll.h>
#include <pthread.h>
#include <sys/mman.h>
#include <unistd.h>
// macOS's <ucontext.h> is an error without _XOPEN_SOURCE; ucontext_t itself is in <sys/ucontext.h>.
#ifdef __APPLE__
#include <sys/ucontext.h>
#else
#include <ucontext.h>
#endif
#include <unwind.h>

#include <cerrno>
#ifdef __linux__
#include <sys/syscall.h>
#endif
#endif

namespace crash_detail {

void Capture::SetMessage(std::string_view text) {
    message_length = std::min(text.size(), sizeof(message) - 1);
    std::memcpy(message, text.data(), message_length);
    message[message_length] = '\0';
}

std::uint64_t CurrentThreadId() {
#ifdef _WIN32
    return GetCurrentThreadId();
#elifdef __APPLE__
    std::uint64_t id = 0;
    pthread_threadid_np(nullptr, &id);
    return id;
#else
    return static_cast<std::uint64_t>(syscall(SYS_gettid));
#endif
}

} // namespace crash_detail

namespace {

using crash_detail::Capture;
using crash_detail::CurrentThreadId;

/**
 * Tracks whether a crash report is being captured or has finished.
 */
enum class Phase : std::uint8_t {
    Idle,
    Capturing,
    Reported,
};

/**
 * Selects the action for a thread entering a crash handler.
 */
enum class Entry : std::uint8_t {
    Report,      // first crasher: capture and report
    PassThrough, // a report is complete: end the process the default way
    Nested,      // the crashing thread faulted again before handing off
    WriterFault, // the report writer itself faulted
    Park,        // another thread is reporting
};

constexpr std::uint32_t kWatchdogMs = 10'000; /**< Maximum report wait in milliseconds. */
#ifdef _WIN32
    constexpr UINT kAbortStatus = 0xC0000409; /**< Windows process status used for aborts. */
#endif

std::atomic<Phase>         g_phase{Phase::Idle};  /**< Current crash handling phase. */
std::atomic<std::uint64_t> g_crash_thread{0};     /**< Identifier of the first crashing thread. */
std::atomic<std::uint64_t> g_writer_thread{0};    /**< Identifier of the report writer thread. */
std::uint64_t              g_main_thread = 0;     /**< Identifier of the main thread. */
bool                       g_initialised = false; /**< Indicates installed crash handlers. */
bool                       g_dialog = false;      /**< Enables interactive crash dialogs. */
Capture                    g_capture;             /**< State handed to the report writer. */

Entry Enter() {
    const std::uint64_t self = CurrentThreadId();
    Phase               expected = Phase::Idle;
    if (g_phase.compare_exchange_strong(expected, Phase::Capturing, std::memory_order_acq_rel)) {
        g_crash_thread.store(self, std::memory_order_release);
        return Entry::Report;
    }
    if (self == g_writer_thread.load(std::memory_order_acquire)) {
        return Entry::WriterFault;
    }
    if (expected == Phase::Reported) {
        return Entry::PassThrough;
    }
    if (self == g_crash_thread.load(std::memory_order_acquire)) {
        return Entry::Nested;
    }
    return Entry::Park;
}

void WriteStderr(std::string_view text) {
#ifdef _WIN32
    DWORD written = 0;
    WriteFile(GetStdHandle(STD_ERROR_HANDLE), text.data(), static_cast<DWORD>(text.size()), &written, nullptr);
#else
    while (!text.empty()) {
        const ssize_t written = write(STDERR_FILENO, text.data(), text.size());
        if (written <= 0) {
            break;
        }
        text.remove_prefix(static_cast<std::size_t>(written));
    }
#endif
}

[[noreturn]] void Park() {
    for (;;) {
#ifdef _WIN32
        Sleep(INFINITE);
#else
        pause();
#endif
    }
}

void FillThread(Capture &capture) {
    capture.thread_id = CurrentThreadId();
    capture.main_thread = capture.thread_id == g_main_thread;
    capture.log_backend_thread = LogIsBackendThread();
}

// --- The writer thread ---------------------------------------------------------------------------

#ifdef _WIN32
HANDLE g_request = nullptr;  /**< Wakes the report writer. */
HANDLE g_written = nullptr;  /**< Signals completion of the report. */
HANDLE g_finished = nullptr; /**< Signals completion of the writer's work. */

void Signal(HANDLE event) {
    SetEvent(event);
}

bool Wait(HANDLE event, std::uint32_t ms) {
    return WaitForSingleObject(event, ms) == WAIT_OBJECT_0;
}
#else
int g_request[2] = {-1, -1};  /**< Pipe that wakes the report writer. */
int g_written[2] = {-1, -1};  /**< Pipe that signals report completion. */
int g_finished[2] = {-1, -1}; /**< Pipe that signals writer completion. */

void Signal(const int (&pipe_fds)[2]) {
    const char byte = 1;
    while (write(pipe_fds[1], &byte, 1) < 0 && errno == EINTR) {
    }
}

bool Wait(const int (&pipe_fds)[2], int ms) {
    pollfd fd{.fd = pipe_fds[0], .events = POLLIN, .revents = 0};
    for (;;) {
        const int ready = poll(&fd, 1, ms);
        if (ready > 0) {
            return true;
        }
        if (ready == 0 || errno != EINTR) {
            return false;
        }
    }
}
#endif

[[noreturn]] void WriterMain() {
    g_writer_thread.store(CurrentThreadId(), std::memory_order_release);
#ifdef _WIN32
    Wait(g_request, INFINITE);
#else
    Wait(g_request, -1);
#endif
    crash_detail::WriteBundle(g_capture, g_dialog);
    Signal(g_written);
    Signal(g_finished);
    Park();
}

bool StartWriter() {
#ifdef _WIN32
    g_request = CreateEventW(nullptr, TRUE, FALSE, nullptr);
    g_written = CreateEventW(nullptr, TRUE, FALSE, nullptr);
    g_finished = CreateEventW(nullptr, TRUE, FALSE, nullptr);
    if (g_request == nullptr || g_written == nullptr || g_finished == nullptr) {
        return false;
    }
    HANDLE thread = CreateThread(
        nullptr, 4 << 20,
        [](void *) -> DWORD {
            WriterMain();
        },
        nullptr, STACK_SIZE_PARAM_IS_A_RESERVATION, nullptr);
    if (thread == nullptr) {
        return false;
    }
    SetThreadDescription(thread, L"ct-crash");
    CloseHandle(thread);
    return true;
#else
    if (pipe(g_request) != 0 || pipe(g_written) != 0 || pipe(g_finished) != 0) {
        return false;
    }
    pthread_attr_t attr;
    pthread_attr_init(&attr);
    pthread_attr_setstacksize(&attr, 4 << 20);
    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
    pthread_t  thread;
    const bool started = pthread_create(
                             &thread, &attr,
                             [](void *) -> void * {
#ifdef __APPLE__
                                 pthread_setname_np("ct-crash");
#endif
                                 WriterMain();
                             },
                             nullptr) == 0;
    pthread_attr_destroy(&attr);
#ifdef __linux__
    if (started) {
        pthread_setname_np(thread, "ct-crash");
    }
#endif
    return started;
#endif
}

// Hands the capture to the writer and waits for it, bounded by the watchdog.
void Report() {
    Signal(g_request);
    if (!Wait(g_written, kWatchdogMs)) {
        crash_detail::AppendRaw("\n!! the report writer did not finish within 10 s; this report is incomplete\n");
        g_phase.store(Phase::Reported, std::memory_order_release);
        return;
    }
    g_phase.store(Phase::Reported, std::memory_order_release);
#ifdef _WIN32
    Wait(g_finished, INFINITE);
#else
    Wait(g_finished, -1);
#endif
}

// What a fault while reporting can still do: say so and let the crashing thread end the process.
[[noreturn]] void WriterFault() {
    crash_detail::AppendRaw("\n!! the report writer faulted; this report is incomplete\n");
    Signal(g_written);
    Signal(g_finished);
    Park();
}

#ifndef _WIN32
/**
 * Tracks output while unwinding the crashing thread's stack.
 */
struct UnwindState {
    std::uint64_t *frames; /**< Destination for program counters. */
    std::size_t    count;  /**< Number of program counters captured. */
    std::size_t    skip;   /**< Handler frames excluded from the trace. */
};

_Unwind_Reason_Code CollectFrame(_Unwind_Context *context, void *data) {
    auto      &state = *static_cast<UnwindState *>(data);
    int        before_instruction = 0;
    const auto ip = static_cast<std::uint64_t>(_Unwind_GetIPInfo(context, &before_instruction));
    if (ip == 0 || state.count >= crash_detail::kMaxFrames) {
        return _URC_END_OF_STACK;
    }
    if (state.skip > 0) {
        state.skip--;
        return _URC_NO_REASON;
    }
    // A signal frame's IP is the faulting instruction itself; any other is a return address.
    state.frames[state.count++] = before_instruction != 0 ? ip : ip - 1;
    return _URC_NO_REASON;
}

// The unwinder's own walk, through signal frames, into a fixed buffer. cpptrace's signal-safe tracer needs
// libunwind, which the port does not link.
[[gnu::noinline]] std::size_t Backtrace(std::uint64_t (&frames)[crash_detail::kMaxFrames], std::size_t skip) {
    UnwindState state{.frames = frames, .count = 0, .skip = skip + 1};
    _Unwind_Backtrace(CollectFrame, &state);
    return state.count;
}
#endif

// --- Controlled failures --------------------------------------------------------------------------

// Captures the calling thread's stack; skip drops the frames of the crash pipeline above the failure.
[[gnu::noinline]] void CaptureCurrent(Capture &capture, int skip) {
#ifdef _WIN32
    RtlCaptureContext(&capture.context);
    capture.has_context = true;
    capture.context_exact = false;
    capture.context_skip = skip + 1;
#else
    capture.frame_count = Backtrace(capture.frames, skip + 1);
#endif
}

// Records a failure the program detected itself and writes its bundle; returns once the report is complete
// (or another report already ended the process from this thread's point of view).
[[gnu::noinline]] void ReportControlled(CrashKind kind, std::string_view message, int skip) {
    switch (Enter()) {
        case Entry::Report:
            break;
        case Entry::WriterFault:
            WriterFault();
        case Entry::Park:
            Park();
        case Entry::PassThrough:
        case Entry::Nested:
            return;
    }
    g_capture.kind = kind;
    g_capture.SetMessage(message);
    FillThread(g_capture);
    CaptureCurrent(g_capture, skip + 1);
    Report();
}

// Ends the process as abort() did before the handlers: SIGABRT on POSIX; on Windows the status of the CRT's
// fast fail, 0xC0000409, without its Windows Error Reporting step. A debugger stops here first.
[[noreturn]] void EndAbort() {
#ifdef _WIN32
    if (IsDebuggerPresent()) {
        __debugbreak();
    }
    TerminateProcess(GetCurrentProcess(), kAbortStatus);
    Park();
#else
    std::signal(SIGABRT, SIG_DFL);
    std::abort();
#endif
}

void FatalHook(std::string_view subsystem, std::string_view message, bool unimplemented) {
    char               buffer[sizeof(g_capture.message)];
    crash_detail::Text text(buffer, sizeof(buffer));
    text.Put(subsystem).Put(": ").Put(message);
    // Returning lets Kazarov end the process its own way: abort for PS2_UNIMPLEMENTED and kz::Abort, exit 1 for gfx.
    ReportControlled(unimplemented ? CrashKind::Unimplemented : CrashKind::Fatal, text.View(), 1);
}

void TerminateHandler() {
    char               buffer[sizeof(g_capture.message)];
    crash_detail::Text text(buffer, sizeof(buffer));
    if (std::exception_ptr current = std::current_exception()) {
        const std::type_info *type = abi::__cxa_current_exception_type();
        int                   status = 0;
        char                 *demangled = type != nullptr ? abi::__cxa_demangle(type->name(), nullptr, nullptr, &status) : nullptr;
        const char           *name = "?";
        if (demangled != nullptr) {
            name = demangled;
        } else if (type != nullptr) {
            name = type->name();
        }
        text.Put("uncaught exception ").Put(name);
        std::free(demangled);
        try {
            std::rethrow_exception(current);
        } catch (const std::exception &error) {
            text.Put(": ").Put(error.what());
        } catch (...) {
            text.Put(" (not a std::exception)");
        }
    } else {
        text.Put("std::terminate called without an active exception");
    }
    ReportControlled(CrashKind::Terminate, text.View(), 1);
    EndAbort();
}

// --- Platform handlers ----------------------------------------------------------------------------

#ifdef _WIN32

LPTOP_LEVEL_EXCEPTION_FILTER g_previous_filter = nullptr; /**< Earlier Windows exception filter. */

void FillRegisters(Capture &capture, const CONTEXT &context) {
    std::size_t n = 0;
    auto        add = [&](const char *name, std::uint64_t value) {
        capture.register_names[n] = name;
        capture.register_values[n] = value;
        n++;
    };
#if defined(_M_ARM64) || defined(__aarch64__)
    static constexpr const char *kNames[29] = {"x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7", "x8", "x9",
                                               "x10", "x11", "x12", "x13", "x14", "x15", "x16", "x17", "x18", "x19",
                                               "x20", "x21", "x22", "x23", "x24", "x25", "x26", "x27", "x28"};
    for (int i = 0; i < 29; i++) {
        add(kNames[i], context.X[i]);
    }
    add("fp", context.Fp);
    add("lr", context.Lr);
    add("sp", context.Sp);
    add("pc", context.Pc);
    add("cpsr", context.Cpsr);
#else
    add("rax", context.Rax);
    add("rbx", context.Rbx);
    add("rcx", context.Rcx);
    add("rdx", context.Rdx);
    add("rsi", context.Rsi);
    add("rdi", context.Rdi);
    add("rbp", context.Rbp);
    add("rsp", context.Rsp);
    add("r8", context.R8);
    add("r9", context.R9);
    add("r10", context.R10);
    add("r11", context.R11);
    add("r12", context.R12);
    add("r13", context.R13);
    add("r14", context.R14);
    add("r15", context.R15);
    add("rip", context.Rip);
    add("eflags", context.EFlags);
#endif
    capture.register_count = n;
}

// C++ exceptions travel as SEH exceptions; an uncaught one reaches std::terminate, which reports it.
bool IsCxxException(DWORD code) {
    return code == 0x20474343 || code == 0xE06D7363;
}

LONG WINAPI UnhandledException(EXCEPTION_POINTERS *pointers) {
    const EXCEPTION_RECORD &record = *pointers->ExceptionRecord;
    if (IsCxxException(record.ExceptionCode)) {
        return g_previous_filter != nullptr ? g_previous_filter(pointers) : EXCEPTION_CONTINUE_SEARCH;
    }
    switch (Enter()) {
        case Entry::Report:
            break;
        case Entry::WriterFault:
            WriterFault();
        case Entry::Park:
            Park();
        case Entry::Nested:
            WriteStderr("crash: fault while capturing a crash\n");
            return EXCEPTION_EXECUTE_HANDLER;
        case Entry::PassThrough:
            return EXCEPTION_EXECUTE_HANDLER;
    }
    Capture &capture = g_capture;
    capture.kind = CrashKind::Signal;
    capture.is_fault = true;
    capture.exception_code = record.ExceptionCode;
    if ((record.ExceptionCode == EXCEPTION_ACCESS_VIOLATION || record.ExceptionCode == EXCEPTION_IN_PAGE_ERROR) &&
        record.NumberParameters >= 2) {
        capture.access = static_cast<int>(record.ExceptionInformation[0]);
        capture.has_fault_address = true;
        capture.fault_address = record.ExceptionInformation[1];
    } else {
        capture.has_fault_address = true;
        capture.fault_address = reinterpret_cast<std::uintptr_t>(record.ExceptionAddress);
    }
    FillThread(capture);
    capture.context = *pointers->ContextRecord;
    capture.has_context = true;
    capture.context_exact = true;
    capture.context_skip = 0;
    FillRegisters(capture, capture.context);
    Report();
    if (g_previous_filter != nullptr && g_previous_filter(pointers) == EXCEPTION_CONTINUE_EXECUTION) {
        return EXCEPTION_CONTINUE_EXECUTION;
    }
    // The report stands in for Windows Error Reporting; the process ends with the exception code.
    return EXCEPTION_EXECUTE_HANDLER;
}

void AbortSignal([[maybe_unused]] int signal_number) {
    ReportControlled(CrashKind::Abort, "abort() called", 1);
    EndAbort();
}

void InvalidParameter([[maybe_unused]] const wchar_t *expression, [[maybe_unused]] const wchar_t *function,
                      [[maybe_unused]] const wchar_t *file, [[maybe_unused]] unsigned int line,
                      [[maybe_unused]] std::uintptr_t reserved) {
    ReportControlled(CrashKind::Abort, "invalid parameter passed to a C runtime function", 1);
    EndAbort();
}

void PureCall() {
    ReportControlled(CrashKind::Abort, "pure virtual function call", 1);
    EndAbort();
}

void InstallPlatform() {
    // No Windows Error Reporting dialog or critical-error box: the crash dialog (or nothing, headless) replaces it,
    // and abort() must raise SIGABRT rather than fast-fail past it.
    SetErrorMode(GetErrorMode() | SEM_FAILCRITICALERRORS | SEM_NOGPFAULTERRORBOX | SEM_NOOPENFILEERRORBOX);
    _set_abort_behavior(0, _WRITE_ABORT_MSG | _CALL_REPORTFAULT);
    ULONG guarantee = 64 * 1024;
    SetThreadStackGuarantee(&guarantee);
    g_previous_filter = SetUnhandledExceptionFilter(UnhandledException);
    std::signal(SIGABRT, AbortSignal);
    _set_invalid_parameter_handler(InvalidParameter);
    _set_purecall_handler(PureCall);
}

#else

constexpr std::size_t kAltStackSize = 256 * 1024;                                            /**< Alternate signal stack size. */
constexpr int         kFatalSignals[] = {SIGSEGV, SIGBUS, SIGILL, SIGFPE, SIGABRT, SIGTRAP}; /**< Reported signals. */

void FillRegisters(Capture &capture, const ucontext_t &context) {
    std::size_t n = 0;
    auto        add = [&](const char *name, std::uint64_t value) {
        capture.register_names[n] = name;
        capture.register_values[n] = value;
        n++;
    };
#if defined(__APPLE__) && defined(__aarch64__)
    static constexpr const char *kNames[29] = {"x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7", "x8", "x9",
                                               "x10", "x11", "x12", "x13", "x14", "x15", "x16", "x17", "x18", "x19",
                                               "x20", "x21", "x22", "x23", "x24", "x25", "x26", "x27", "x28"};
    const auto                  &state = context.uc_mcontext->__ss;
    for (int i = 0; i < 29; i++) {
        add(kNames[i], state.__x[i]);
    }
    add("fp", state.__fp);
    add("lr", state.__lr);
    add("sp", state.__sp);
    add("pc", state.__pc);
    add("cpsr", state.__cpsr);
#elifdef __APPLE__
    const auto &state = context.uc_mcontext->__ss;
    add("rax", state.__rax);
    add("rbx", state.__rbx);
    add("rcx", state.__rcx);
    add("rdx", state.__rdx);
    add("rsi", state.__rsi);
    add("rdi", state.__rdi);
    add("rbp", state.__rbp);
    add("rsp", state.__rsp);
    add("r8", state.__r8);
    add("r9", state.__r9);
    add("r10", state.__r10);
    add("r11", state.__r11);
    add("r12", state.__r12);
    add("r13", state.__r13);
    add("r14", state.__r14);
    add("r15", state.__r15);
    add("rip", state.__rip);
    add("rflags", state.__rflags);
#elifdef __aarch64__
    static constexpr const char *kNames[31] = {"x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7", "x8", "x9", "x10",
                                               "x11", "x12", "x13", "x14", "x15", "x16", "x17", "x18", "x19", "x20",
                                               "x21", "x22", "x23", "x24", "x25", "x26", "x27", "x28", "fp", "lr"};
    for (int i = 0; i < 31; i++) {
        add(kNames[i], context.uc_mcontext.regs[i]);
    }
    add("sp", context.uc_mcontext.sp);
    add("pc", context.uc_mcontext.pc);
    add("pstate", context.uc_mcontext.pstate);
#else
    const auto &gregs = context.uc_mcontext.gregs;
    add("rax", gregs[REG_RAX]);
    add("rbx", gregs[REG_RBX]);
    add("rcx", gregs[REG_RCX]);
    add("rdx", gregs[REG_RDX]);
    add("rsi", gregs[REG_RSI]);
    add("rdi", gregs[REG_RDI]);
    add("rbp", gregs[REG_RBP]);
    add("rsp", gregs[REG_RSP]);
    add("r8", gregs[REG_R8]);
    add("r9", gregs[REG_R9]);
    add("r10", gregs[REG_R10]);
    add("r11", gregs[REG_R11]);
    add("r12", gregs[REG_R12]);
    add("r13", gregs[REG_R13]);
    add("r14", gregs[REG_R14]);
    add("r15", gregs[REG_R15]);
    add("rip", gregs[REG_RIP]);
    add("eflags", gregs[REG_EFL]);
#endif
    capture.register_count = n;
}

/**
 * Reads a captured register by name, or 0 when the platform does not capture it.
 */
std::uint64_t RegisterValue(const Capture &capture, const char *name) {
    for (std::size_t i = 0; i < capture.register_count; i++) {
        if (std::strcmp(capture.register_names[i], name) == 0) {
            return capture.register_values[i];
        }
    }
    return 0;
}

std::uint64_t ProgramCounter(const Capture &capture) {
    const std::uint64_t rip = RegisterValue(capture, "rip");
    return rip != 0 ? rip : RegisterValue(capture, "pc");
}

/**
 * Drops the frames before index and makes the faulting instruction the trace's first frame.
 */
void StartAtFault(Capture &capture, std::size_t index, std::uint64_t pc) {
    std::memmove(capture.frames, capture.frames + index, (capture.frame_count - index) * sizeof(capture.frames[0]));
    capture.frame_count -= index;
    capture.frames[0] = pc;
}

// The unwind starts inside this handler; the frames above the faulting instruction are dropped. macOS's unwinder
// leaves the signal trampoline through the link register, so the faulting instruction is never among the frames;
// it then goes in front of the link register's frame, the caller of a faulting leaf function.
void TrimToFault(Capture &capture) {
    const std::uint64_t pc = ProgramCounter(capture);
    for (std::size_t i = 0; i < capture.frame_count; i++) {
        if (capture.frames[i] == pc || capture.frames[i] + 1 == pc) {
            StartAtFault(capture, i, pc);
            return;
        }
    }
    const std::uint64_t lr = RegisterValue(capture, "lr");
    for (std::size_t i = 1; lr != 0 && i < capture.frame_count; i++) {
        if (capture.frames[i] + 1 == lr) {
            StartAtFault(capture, i - 1, pc);
            return;
        }
    }
}

[[noreturn]] void ReRaise(int signal_number) {
    struct sigaction action{};
    action.sa_handler = SIG_DFL;
    sigemptyset(&action.sa_mask);
    sigaction(signal_number, &action, nullptr);
    sigset_t unblock;
    sigemptyset(&unblock);
    sigaddset(&unblock, signal_number);
    pthread_sigmask(SIG_UNBLOCK, &unblock, nullptr);
    raise(signal_number);
    _exit(128 + signal_number);
}

void FatalSignal(int signal_number, siginfo_t *info, void *raw_context) {
    switch (Enter()) {
        case Entry::Report:
            break;
        case Entry::WriterFault:
            WriterFault();
        case Entry::Park:
            Park();
        case Entry::Nested:
            WriteStderr("crash: fault while capturing a crash\n");
            ReRaise(signal_number);
        case Entry::PassThrough:
            ReRaise(signal_number);
    }
    Capture   &capture = g_capture;
    const bool aborted = signal_number == SIGABRT;
    capture.kind = aborted ? CrashKind::Abort : CrashKind::Signal;
    if (aborted) {
        capture.SetMessage("abort() called");
    }
    capture.is_fault = !aborted;
    capture.signal = signal_number;
    capture.signal_code = info->si_code;
    capture.has_fault_address = signal_number != SIGABRT && signal_number != SIGTRAP;
    capture.fault_address = reinterpret_cast<std::uintptr_t>(info->si_addr);
    FillThread(capture);
    if (raw_context != nullptr) {
        FillRegisters(capture, *static_cast<const ucontext_t *>(raw_context));
    }
    capture.frame_count = Backtrace(capture.frames, 0);
    // A raised signal's context is the raising call, so abort()'s trace also starts there.
    TrimToFault(capture);
    Report();
    ReRaise(signal_number);
}

// Each thread that could overflow its stack needs its own alternate stack; the main thread gets one here.
void InstallAltStack() {
    void *memory = mmap(nullptr, kAltStackSize, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (memory == MAP_FAILED) {
        return;
    }
    stack_t stack{};
    stack.ss_sp = memory;
    stack.ss_size = kAltStackSize;
    sigaltstack(&stack, nullptr);
}

void InstallPlatform() {
    InstallAltStack();
    // The first unwind binds the unwinder and registers its tables; a crash must not be the first.
    std::uint64_t warm_up[crash_detail::kMaxFrames];
    static_cast<void>(Backtrace(warm_up, 0));
    for (const int signal_number : kFatalSignals) {
        struct sigaction action{};
        action.sa_sigaction = FatalSignal;
        action.sa_flags = SA_SIGINFO | SA_ONSTACK | SA_NODEFER;
        sigemptyset(&action.sa_mask);
        sigaction(signal_number, &action, nullptr);
    }
}

#endif

} // namespace

bool crash_detail::DialogsAllowed() {
    return g_dialog;
}

void CrashInit(const CrashInitOptions &options) {
    if (g_initialised) {
        return;
    }
    g_main_thread = CurrentThreadId();
    g_dialog = !options.headless;
    crash_detail::WriterWarmUp();
    if (!StartWriter()) {
        WriteStderr("crash: cannot start the crash report writer\n");
        return;
    }
    InstallPlatform();
    std::set_terminate(TerminateHandler);
    kz::SetFatalHook(FatalHook);
    g_initialised = true;
}

void CrashSetBundleRoot(const std::filesystem::path &save_root) {
    crash_detail::WriterSetBundleRoot(PathsDisplay(save_root), PathsDisplay(PathsDataRoot()));
}

void CrashReportAndExit(CrashKind kind, std::string_view message, int exit_status) {
    WriteStderr(message);
    WriteStderr("\n");
    if (g_initialised) {
        ReportControlled(kind, message, 1);
    }
    std::fflush(nullptr);
    if (kind == CrashKind::Abort || kind == CrashKind::Unimplemented || kind == CrashKind::Terminate) {
        EndAbort();
    }
    std::_Exit(exit_status);
}
