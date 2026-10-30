#include <string>

#include "dataread.hpp"

dc2::io::FileRead dc2::io::FindBackgroundReadInCurrentDir(std::string_view name) {
    std::string path = GetCurrentDir();
    path += name;
    return FindBackgroundRead(path);
}
