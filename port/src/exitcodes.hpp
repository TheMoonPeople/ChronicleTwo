#pragma once

// PS2_UNIMPLEMENTED aborts (SIGABRT, 134 from a shell) rather than exiting with a code, so a
// debugger or core dump stops at the stub.
enum ExitStatus : int {
    kExitGameAssert = 4,
    kExitNoData = 3,
    kExitOk = 0,
    kExitScriptTiming = 5, // a known script does not match the conversion the NTSC timing needs
    kExitUsage = 2,
};
