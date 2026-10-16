#include "common.h"

#include "asset_directory.hpp"
#include "dataread.hpp"

PORT_OVERRIDE u_int *GetPackFile(u_int *directory, char *name, int *out_size) {
    return AssetDirectoryRead(directory, name, out_size);
}

PORT_OVERRIDE u_int *GetPackFile(u_int *directory, int index, char **out_name, int *out_size) {
    return AssetDirectoryRead(directory, index, out_name, out_size);
}

PORT_OVERRIDE int GetPackFileExt(u_int *directory, char *kind, u_int **files, int max_files, int *sizes, char **names) {
    return AssetDirectoryReadExtension(directory, kind, files, max_files, sizes, names);
}

PORT_OVERRIDE int GetPackFileNum(u_int *directory) {
    return AssetDirectoryCount(directory);
}
