// What a player sees of a crash: the Windows dialog from the crashed process, elsewhere a notice on the next launch.

#include <SDL3/SDL.h>
#include <nlohmann/json.hpp>
#include <platform/paths.hpp>

#include <cstdint>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <string>
#include <system_error>
#include <vector>

#include "crash/crash.hpp"
#include "crash/crash_capture.hpp"

#ifdef _WIN32
#include <shellapi.h>
#endif

namespace {

/**
 * Identifies a button on a previous crash notice.
 */
enum class NoticeButton : int {
    OpenFolder = 1,
    CopyPath = 2,
    Close = 3,
};

std::string FileUrl(std::string path) {
    for (char &c : path) {
        if (c == '\\') {
            c = '/';
        }
    }
    std::string url = path.starts_with('/') ? "file://" : "file:///";
    for (const unsigned char c : path) {
        if (c == ' ' || c == '%' || c == '#' || c == '?' || c >= 0x80) {
            constexpr char hex_digits[] = "0123456789ABCDEF";
            url += '%';
            url += hex_digits[c >> 4];
            url += hex_digits[c & 0xf];
        } else {
            url += static_cast<char>(c);
        }
    }
    return url;
}

#ifdef _WIN32

/**
 * Identifies a control in the Windows crash dialog.
 */
enum class DialogControl : WORD {
    Text = 100,
    OpenFolder = 101,
    CopyPath = 102,
};

/**
 * Stores the text and paths shown in the Windows crash dialog.
 */
struct DialogState {
    std::wstring text;        /**< Crash summary and instructions. */
    std::wstring bundle_dir;  /**< Directory copied to the clipboard. */
    std::wstring report_path; /**< Report selected by the file manager. */
};

std::wstring Wide(std::string_view utf8) {
    return PathsFromUtf8(utf8).wstring();
}

void CopyToClipboard(HWND owner, const std::wstring &text) {
    if (!OpenClipboard(owner)) {
        return;
    }
    EmptyClipboard();
    const std::size_t bytes = (text.size() + 1) * sizeof(wchar_t);
    if (HGLOBAL memory = GlobalAlloc(GMEM_MOVEABLE, bytes); memory != nullptr) {
        if (void *target = GlobalLock(memory); target != nullptr) {
            std::memcpy(target, text.c_str(), bytes);
            GlobalUnlock(memory);
            if (SetClipboardData(CF_UNICODETEXT, memory) == nullptr) {
                GlobalFree(memory);
            }
        } else {
            GlobalFree(memory);
        }
    }
    CloseClipboard();
}

INT_PTR CALLBACK DialogProc(HWND dialog, UINT message, WPARAM wparam, LPARAM lparam) {
    // NOLINTNEXTLINE(performance-no-int-to-ptr): the state pointer WM_INITDIALOG stored
    auto *state = reinterpret_cast<DialogState *>(GetWindowLongPtrW(dialog, DWLP_USER));
    switch (message) {
        case WM_INITDIALOG:
            SetWindowLongPtrW(dialog, DWLP_USER, lparam);
            // NOLINTNEXTLINE(performance-no-int-to-ptr): DialogBoxIndirectParamW's parameter
            state = reinterpret_cast<DialogState *>(lparam);
            SetDlgItemTextW(dialog, static_cast<int>(DialogControl::Text), state->text.c_str());
            SetForegroundWindow(dialog);
            return TRUE;
        case WM_COMMAND:
            switch (LOWORD(wparam)) {
                case static_cast<WORD>(DialogControl::OpenFolder): {
                    // Explorer opens the bundle with report.txt selected.
                    const std::wstring arguments = L"/select,\"" + state->report_path + L"\"";
                    ShellExecuteW(dialog, L"open", L"explorer.exe", arguments.c_str(), nullptr, SW_SHOWNORMAL);
                    return TRUE;
                }
                case static_cast<WORD>(DialogControl::CopyPath):
                    CopyToClipboard(dialog, state->bundle_dir);
                    SetDlgItemTextW(dialog, static_cast<int>(DialogControl::CopyPath), L"Copied");
                    return TRUE;
                case IDCANCEL:
                case IDOK:
                    EndDialog(dialog, 0);
                    return TRUE;
                default:
                    return FALSE;
            }
        case WM_CLOSE:
            EndDialog(dialog, 0);
            return TRUE;
        default:
            return FALSE;
    }
}

/**
 * Builds the controls shown in a Windows crash dialog.
 */
class Template {
public:
    /**
     * Adds a 16-bit value to the dialog template.
     */
    void Word(WORD value) { words.push_back(value); }

    /**
     * Adds a 32-bit value to the dialog template.
     */
    void Dword(DWORD value) {
        Word(LOWORD(value));
        Word(HIWORD(value));
    }

    /**
     * Adds a wide string to the dialog template.
     */
    void String(std::wstring_view text) {
        for (const wchar_t c : text) {
            Word(static_cast<WORD>(c));
        }
        Word(0);
    }

    /**
     * Aligns the next dialog control to a 32-bit boundary.
     */
    void Align() {
        if (words.size() % 2 != 0) {
            Word(0);
        }
    }

    /**
     * Adds a control to the dialog template.
     */
    void Item(DWORD style, short x, short y, short cx, short cy, WORD id, WORD window_class, std::wstring_view text) {
        Align();
        Dword(style | WS_CHILD | WS_VISIBLE);
        Dword(0);
        Word(static_cast<WORD>(x));
        Word(static_cast<WORD>(y));
        Word(static_cast<WORD>(cx));
        Word(static_cast<WORD>(cy));
        Word(id);
        Word(0xffff);
        Word(window_class);
        String(text);
        Word(0);
    }

    /**
     * Returns the completed dialog template.
     */
    [[nodiscard]] const DLGTEMPLATE *Data() const { return reinterpret_cast<const DLGTEMPLATE *>(words.data()); }

private:
    std::vector<WORD> words; /**< Encoded dialog template words. */
};

constexpr WORD kButtonClass = 0x0080; /**< Windows button control class. */
constexpr WORD kStaticClass = 0x0082; /**< Windows static text control class. */

#endif

} // namespace

#ifdef _WIN32
namespace crash_detail {

void ShowCrashDialog(std::string_view summary, std::string_view bundle_dir, std::string_view report_path) {
    DialogState state{
        .text = L"Dark Chronicle has crashed.\r\n\r\n" + Wide(summary) +
                L"\r\n\r\nA crash report was saved to:\r\n" + Wide(bundle_dir) +
                L"\r\n\r\nPlease include the files in this folder when you report the problem.",
        .bundle_dir = Wide(bundle_dir),
        .report_path = Wide(report_path),
    };
    constexpr short width = 320;
    constexpr short height = 150;
    Template        dialog;
    dialog.Dword(DS_SETFONT | DS_MODALFRAME | DS_CENTER | DS_SETFOREGROUND | WS_POPUP | WS_CAPTION | WS_SYSMENU);
    dialog.Dword(WS_EX_TOPMOST);
    dialog.Word(4);
    dialog.Word(0);
    dialog.Word(0);
    dialog.Word(width);
    dialog.Word(height);
    dialog.Word(0);
    dialog.Word(0);
    dialog.String(L"Dark Chronicle");
    dialog.Word(9);
    dialog.String(L"Segoe UI");
    dialog.Item(SS_LEFT | SS_NOPREFIX, 10, 10, width - 20, height - 44, static_cast<WORD>(DialogControl::Text), kStaticClass, L"");
    constexpr short button_width = 60;
    constexpr short button_y = height - 24;
    dialog.Item(BS_DEFPUSHBUTTON | WS_TABSTOP, width - 3 * (button_width + 6) - 4, button_y, button_width, 14,
                static_cast<WORD>(DialogControl::OpenFolder), kButtonClass, L"Open folder");
    dialog.Item(BS_PUSHBUTTON | WS_TABSTOP, width - 2 * (button_width + 6) - 4, button_y, button_width, 14,
                static_cast<WORD>(DialogControl::CopyPath), kButtonClass, L"Copy path");
    dialog.Item(BS_PUSHBUTTON | WS_TABSTOP, width - (button_width + 6) - 4, button_y, button_width, 14, IDCANCEL,
                kButtonClass, L"Close");
    DialogBoxIndirectParamW(GetModuleHandleW(nullptr), dialog.Data(), nullptr, DialogProc, reinterpret_cast<LPARAM>(&state));
}

} // namespace crash_detail
#endif

void CrashShowLastReportNotice() {
    if (!crash_detail::DialogsAllowed() || !crash_detail::WriterHasBundle()) {
        return;
    }
    const std::filesystem::path path = PathsFromUtf8(crash_detail::WriterBundleDir()).parent_path() / "last_crash.json";
    std::ifstream               input(path, std::ios::binary);
    if (!input) {
        return;
    }
    const nlohmann::json last = nlohmann::json::parse(input, nullptr, false);
    input.close();
    std::error_code error;
    std::filesystem::remove(path, error);
    if (!last.is_object() || last.value("notified", false)) {
        return;
    }
    const std::string bundle = last.value("bundle", std::string());
    const std::string summary = last.value("summary", std::string());
    if (bundle.empty()) {
        return;
    }
    const std::string message = "Dark Chronicle crashed the last time it ran.\n\n" + summary +
                                "\n\nA crash report was saved to:\n" + bundle +
                                "\n\nPlease include the files in this folder when you report the problem.";

    const SDL_MessageBoxButtonData buttons[] = {
        {.flags = SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT, .buttonID = static_cast<int>(NoticeButton::OpenFolder), .text = "Open folder"},
        {.flags = 0,                                       .buttonID = static_cast<int>(NoticeButton::CopyPath),   .text = "Copy path"  },
        {.flags = SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT, .buttonID = static_cast<int>(NoticeButton::Close),      .text = "Close"      },
    };
    const SDL_MessageBoxData data{
        .flags = SDL_MESSAGEBOX_WARNING,
        .window = nullptr,
        .title = "Dark Chronicle",
        .message = message.c_str(),
        .numbuttons = 3,
        .buttons = buttons,
        .colorScheme = nullptr,
    };
    int choice = static_cast<int>(NoticeButton::Close);
    if (!SDL_ShowMessageBox(&data, &choice)) {
        return;
    }
    if (choice == static_cast<int>(NoticeButton::OpenFolder)) {
        SDL_OpenURL(FileUrl(bundle).c_str());
    } else if (choice == static_cast<int>(NoticeButton::CopyPath)) {
        SDL_SetClipboardText(bundle.c_str());
    }
}
