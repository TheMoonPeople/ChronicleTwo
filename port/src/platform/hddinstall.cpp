#include "common.h"

#include "hddinstall.hpp"

int HddConectCheck(int *state) { return 0; }

int CheckAppInstall() { return 0; }

int CheckInstallSpace() { return 0; }

int MountHDDFileSystem() { return 0; }

int UmountHDDFileSystem() { return 0; }

int CreateInstallThread(u_long128 *work, int work_size) { return 0; }

void DeleteInstallThread() {}

int StepInstallThread() { return 0; }

int InstallPause() { return 0; }

void InstallCancel() {}

float GetInstallProgress() { return 0.0f; }

int UninstallApp() { return 0; }
