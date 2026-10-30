#pragma once

// PS2_UNIMPLEMENTED aborts (SIGABRT, 134 from a shell) rather than exiting with a code, so a
// debugger or core dump stops at the stub.
enum ExitStatus : int {
    kExitGameAssert = 4,
    kExitNoData = 3,
    kExitOk = 0,
    kExitUsage = 2,
};
