// Names a frame from its module's symbol table when the debug info has no name for it, as with
// -gline-tables-only, which keeps lines but not every function's name.

#include <cxxabi.h>
#include <platform/paths.hpp>

#include <algorithm>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iterator>
#include <map>
#include <string>
#include <utility>
#include <vector>

#include "crash/crash_capture.hpp"

#ifndef _WIN32
#include <dlfcn.h>
#endif
#ifdef __linux__
#include <elf.h>
#endif

namespace {

// Function start (relative to the module's load base) and name, sorted by start.
using SymbolTable = std::vector<std::pair<std::uint64_t, std::string>>;

template <typename T>
bool ReadAt(std::ifstream &file, std::uint64_t offset, T &out) {
    file.seekg(static_cast<std::streamoff>(offset));
    return static_cast<bool>(file.read(reinterpret_cast<char *>(&out), sizeof(out)));
}

#ifdef _WIN32
// The PE's COFF symbol table, which lld keeps unless the image is stripped.
SymbolTable LoadTable(const std::filesystem::path &path) {
    SymbolTable   table;
    std::ifstream file(path, std::ios::binary);
    std::uint32_t pe_offset = 0;
    if (!file || !ReadAt(file, 0x3c, pe_offset)) {
        return table;
    }
    IMAGE_FILE_HEADER header{};
    if (!ReadAt(file, pe_offset + 4, header) || header.PointerToSymbolTable == 0 || header.NumberOfSymbols == 0) {
        return table;
    }
    std::vector<IMAGE_SECTION_HEADER> sections(header.NumberOfSections);
    file.seekg(static_cast<std::streamoff>(pe_offset + 4 + sizeof(IMAGE_FILE_HEADER) + header.SizeOfOptionalHeader));
    file.read(reinterpret_cast<char *>(sections.data()), static_cast<std::streamsize>(sections.size() * sizeof(IMAGE_SECTION_HEADER)));
    constexpr std::size_t     record_size = 18;
    std::vector<std::uint8_t> records(static_cast<std::size_t>(header.NumberOfSymbols) * record_size);
    file.seekg(header.PointerToSymbolTable);
    file.read(reinterpret_cast<char *>(records.data()), static_cast<std::streamsize>(records.size()));
    std::uint32_t strings_size = 0;
    file.read(reinterpret_cast<char *>(&strings_size), sizeof(strings_size));
    std::vector<char> strings(std::max<std::uint32_t>(strings_size, 4));
    if (strings_size > 4) {
        file.read(strings.data() + 4, strings_size - 4);
    }
    if (!file) {
        return table;
    }
    for (std::size_t i = 0; i < header.NumberOfSymbols; i++) {
        const std::uint8_t *record = records.data() + i * record_size;
        std::uint32_t       value = 0;
        std::int16_t        section = 0;
        std::uint16_t       type = 0;
        std::memcpy(&value, record + 8, 4);
        std::memcpy(&section, record + 12, 2);
        std::memcpy(&type, record + 14, 2);
        const std::uint8_t storage = record[16];
        const std::uint8_t aux = record[17];
        const bool         function = (type >> 4) == IMAGE_SYM_DTYPE_FUNCTION;
        if (function && section > 0 && std::cmp_less_equal(section, sections.size()) &&
            (storage == IMAGE_SYM_CLASS_EXTERNAL || storage == IMAGE_SYM_CLASS_STATIC)) {
            std::string   name;
            std::uint32_t zeroes = 0;
            std::memcpy(&zeroes, record, 4);
            if (zeroes == 0) {
                std::uint32_t offset = 0;
                std::memcpy(&offset, record + 4, 4);
                if (offset < strings.size()) {
                    name = strings.data() + offset;
                }
            } else {
                name.assign(reinterpret_cast<const char *>(record), strnlen(reinterpret_cast<const char *>(record), 8));
            }
            table.emplace_back(sections[section - 1].VirtualAddress + value, std::move(name));
        }
        i += aux;
    }
    return table;
}
#elifdef __linux__
// The ELF .symtab's functions, which a build keeps unless it is stripped.
SymbolTable LoadTable(const std::filesystem::path &path) {
    SymbolTable   table;
    std::ifstream file(path, std::ios::binary);
    Elf64_Ehdr    header{};
    if (!file || !ReadAt(file, 0, header) || std::memcmp(header.e_ident, ELFMAG, SELFMAG) != 0 || header.e_ident[EI_CLASS] != ELFCLASS64) {
        return table;
    }
    std::vector<Elf64_Shdr> sections(header.e_shnum);
    file.seekg(static_cast<std::streamoff>(header.e_shoff));
    file.read(reinterpret_cast<char *>(sections.data()), static_cast<std::streamsize>(sections.size() * sizeof(Elf64_Shdr)));
    if (!file) {
        return table;
    }
    for (const Elf64_Shdr &section : sections) {
        if (section.sh_type != SHT_SYMTAB || section.sh_link >= sections.size()) {
            continue;
        }
        const Elf64_Shdr &string_section = sections[section.sh_link];
        std::vector<char> strings(string_section.sh_size + 1);
        file.seekg(static_cast<std::streamoff>(string_section.sh_offset));
        file.read(strings.data(), static_cast<std::streamsize>(string_section.sh_size));
        std::vector<Elf64_Sym> symbols(section.sh_size / sizeof(Elf64_Sym));
        file.seekg(static_cast<std::streamoff>(section.sh_offset));
        file.read(reinterpret_cast<char *>(symbols.data()), static_cast<std::streamsize>(symbols.size() * sizeof(Elf64_Sym)));
        if (!file) {
            break;
        }
        for (const Elf64_Sym &symbol : symbols) {
            if (ELF64_ST_TYPE(symbol.st_info) == STT_FUNC && symbol.st_value != 0 && symbol.st_name < strings.size()) {
                table.emplace_back(symbol.st_value, strings.data() + symbol.st_name);
            }
        }
    }
    return table;
}
#endif

std::string Demangle(const std::string &name) {
    int   status = 0;
    char *demangled = abi::__cxa_demangle(name.c_str(), nullptr, nullptr, &status);
    if (demangled == nullptr) {
        return name;
    }
    std::string out = demangled;
    std::free(demangled);
    return out;
}

} // namespace

namespace crash_detail {

std::string SymbolTableName(std::uint64_t address) {
#if defined(_WIN32) || defined(__linux__)
    std::filesystem::path module_path;
    std::uint64_t         base = 0;
#ifdef _WIN32
    HMODULE module = nullptr;
    if (!GetModuleHandleExW(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                            // NOLINTNEXTLINE(performance-no-int-to-ptr): a code address from the unwinder
                            reinterpret_cast<LPCWSTR>(address), &module)) {
        return {};
    }
    wchar_t path[MAX_PATH];
    if (GetModuleFileNameW(module, path, MAX_PATH) == 0) {
        return {};
    }
    module_path = path;
    base = reinterpret_cast<std::uintptr_t>(module);
#else
    Dl_info info{};
    // NOLINTNEXTLINE(performance-no-int-to-ptr): a code or stack address from the unwinder
    if (dladdr(reinterpret_cast<void *>(address), &info) == 0 || info.dli_fbase == nullptr) {
        return {};
    }
    if (info.dli_sname != nullptr) {
        return Demangle(info.dli_sname);
    }
    // The executable's own entry names argv[0]; /proc/self/exe is the file itself.
    module_path = info.dli_fname != nullptr && std::strchr(info.dli_fname, '/') != nullptr ? info.dli_fname : PathsExecutable();
    base = reinterpret_cast<std::uintptr_t>(info.dli_fbase);
#endif
    static std::map<std::filesystem::path, SymbolTable> tables;
    auto [entry, inserted] = tables.try_emplace(module_path);
    if (inserted) {
        entry->second = LoadTable(module_path);
        std::ranges::sort(entry->second);
    }
    const SymbolTable  &table = entry->second;
    const std::uint64_t offset = address - base;
    auto                after = std::ranges::upper_bound(table, offset, {}, &SymbolTable::value_type::first);
    if (after == table.begin()) {
        return {};
    }
    return Demangle(std::prev(after)->second);
#else
    // dyld's dladdr searches the Mach-O symbol table, local symbols included.
    Dl_info info{};
    // NOLINTNEXTLINE(performance-no-int-to-ptr): a code or stack address from the unwinder
    if (dladdr(reinterpret_cast<void *>(address), &info) == 0 || info.dli_sname == nullptr) {
        return {};
    }
    return Demangle(info.dli_sname);
#endif
}

/**
 * Resolves each captured address once while retaining every occurrence and inline frame.
 */
cpptrace::stacktrace ResolveFrames(const cpptrace::raw_trace                                              &raw,
                                   const std::function<cpptrace::stacktrace(const cpptrace::raw_trace &)> &resolver) {
    std::map<cpptrace::frame_ptr, std::vector<cpptrace::stacktrace_frame>> groups;
    cpptrace::raw_trace                                                    unique;
    for (const cpptrace::frame_ptr address : raw.frames) {
        if (groups.try_emplace(address).second) {
            unique.frames.push_back(address);
        }
    }
    const cpptrace::stacktrace resolved = resolver(unique);
    auto                       first = resolved.frames.begin();
    for (auto frame = first; frame != resolved.frames.end(); ++frame) {
        if (frame->is_inline) {
            continue;
        }
        const auto                              after = std::next(frame);
        std::vector<cpptrace::stacktrace_frame> group(first, after);
        if (group.back().symbol.empty()) {
            group.back().symbol = crash_detail::SymbolTableName(frame->raw_address);
        }
        groups.at(frame->raw_address) = std::move(group);
        first = after;
    }
    cpptrace::stacktrace trace;
    for (const cpptrace::frame_ptr address : raw.frames) {
        const auto &group = groups.at(address);
        trace.frames.insert(trace.frames.end(), group.begin(), group.end());
    }
    return trace;
}

} // namespace crash_detail
