#requires -Version 7.0
# Builds or runs Windows directly and delegates container configurations to Kazarov.
$ErrorActionPreference = 'Stop'
. "$PSScriptRoot/common.ps1"

if ($args.Count -lt 1) { throw 'usage: kazarov.ps1 build|run [config] [args...]' }
$command = ([string]$args[0]).ToLower()
$config = 'windows-x64-release'
$rest = @($args | Select-Object -Skip 1)
if ($command -notin 'build', 'run') { throw "kazarov: unknown command $command" }
$checkout = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
$configuration = [IO.File]::ReadAllText((Join-Path $checkout 'kazarov.conf'))
$container_configs = ([regex]::Match($configuration, '(?m)^KZ_CONTAINER_CONFIGS=(.*)$').Groups[1].Value -replace '["()]', '').Trim() -split '\s+'
$default_config = ([regex]::Match($configuration, "(?m)^KZ_DEFAULT_$($command.ToUpperInvariant())_WINDOWS=(.*)$").Groups[1].Value -replace '["()]', '').Trim()
if ($default_config) { $config = $default_config }
if ($rest.Count -gt 0) {
    if ($rest[0] -in 'windows', 'windows-x64', 'windows-x64-release', 'windows-x64-asan') {
        $config = $rest[0]
        $rest = @($rest | Select-Object -Skip 1)
    } elseif ($rest[0] -in $container_configs) {
        & "$checkout/tools/kazarov/scripts/kazarov.ps1" $checkout $command @rest
        exit $LASTEXITCODE
    }
}
if ($config -notin 'windows', 'windows-x64', 'windows-x64-release', 'windows-x64-asan') {
    & "$checkout/tools/kazarov/scripts/kazarov.ps1" $checkout $command @rest
    exit $LASTEXITCODE
}

switch ($config.ToLower()) {
    { $_ -in 'windows', 'windows-x64-release' } { $name = 'windows-x64-release'; $buildType = 'Release' }
    'windows-x64' { $name = 'windows-x64'; $buildType = 'Debug' }
    'windows-x64-asan' { $name = 'windows-x64-asan'; $buildType = 'Debug' }
    default { throw "kazarov: unknown Windows configuration $config" }
}

$state = Join-Path $checkout '.kazarov'
$root = Resolve-WindowsRoot (Join-Path $state 'windows')
$build = Resolve-WindowsBuild $root (Join-Path $checkout "port/build/$name")
$timer = [Diagnostics.Stopwatch]::StartNew()
function Write-Stage([string]$Message) {
    Write-Host ("kazarov: [{0:N1}s] {1}" -f $timer.Elapsed.TotalSeconds, $Message)
}
Write-Stage "$command $name"

# One run per configuration at a time. The lock is released when the process exits, or before the game starts.
$locks = Join-Path $state 'locks'
New-Item -ItemType Directory -Force $locks | Out-Null
$lockFile = Join-Path $locks "$name.lock"
$lock = $null
$announced = $false
while ($null -eq $lock) {
    try {
        $lock = [IO.File]::Open($lockFile, 'OpenOrCreate', 'ReadWrite', 'None')
    } catch [IO.IOException], [UnauthorizedAccessException] {
        if (-not $announced) { Write-Host "kazarov: waiting for $lockFile"; $announced = $true }
        Start-Sleep -Milliseconds 500
    }
}
Write-Stage 'configuration lock acquired; checking dependencies'

if ($env:CLEAN -eq '1' -and (Test-Path -LiteralPath $build)) {
    Write-Stage "cleaning $build"
    Remove-Item -LiteralPath $build -Recurse -Force
}

# Both configurations share the dependencies, so their check and acquisition are serialised by a second lock.
$depsLock = Join-Path $locks 'windows-deps.lock'
$deps = $null
$depsAnnounced = $false
while ($null -eq $deps) {
    try {
        $deps = [IO.File]::Open($depsLock, 'OpenOrCreate', 'ReadWrite', 'None')
    } catch [IO.IOException], [UnauthorizedAccessException] {
        if (-not $depsAnnounced) { Write-Host "kazarov: waiting for $depsLock"; $depsAnnounced = $true }
        Start-Sleep -Milliseconds 500
    }
}

# Docker verifies and exports the native toolchain when a required file is missing.
function Get-DependencyId([string]$checkout, [switch]$Legacy) {
    $dependency_inputs = @("$checkout/tools/ci/Dockerfile", "$checkout/port/CMakeLists.txt",
        "$checkout/port/src/tests/CMakeLists.txt", "$checkout/tools/kazarov/tools/ffmpeg/kz-ffmpeg") +
        @(Get-ChildItem -LiteralPath "$checkout/port/cmake", "$checkout/tools/kazarov/cmake" -Filter '*.cmake' -File |
            Sort-Object FullName | Select-Object -ExpandProperty FullName)
    # Only acquisition declarations affect the bundle; compiler flags, targets and copy rules do not.
    # These patterns mirror the declarations consumed by tools/ci/Dockerfile.
    $declarations = foreach ($input_file in $dependency_inputs | Select-Object -Skip 1) {
        $text = [IO.File]::ReadAllText($input_file)
        foreach ($match in [regex]::Matches($text, 'FetchContent_Declare\((\w+)\s+(.*?)\)', 'Singleline,IgnoreCase')) {
            $url = [regex]::Match($match.Groups[2].Value, '\bURL\s+(https://\S+)')
            $digest = [regex]::Match($match.Groups[2].Value, 'URL_HASH\s+SHA256=([a-fA-F0-9]{64})')
            if ($url.Success -and $digest.Success) {
                '{0} {1} {2}' -f $match.Groups[1].Value.ToLowerInvariant(), $url.Groups[1].Value, $digest.Groups[1].Value.ToLowerInvariant()
            }
        }
        foreach ($match in [regex]::Matches($text, '_kz_port_vendor\(\w+\s+(\S+)\s+(https://\S+)\s+([a-fA-F0-9]{64})')) {
            'vendor {0} {1} {2}' -f $match.Groups[1].Value, $match.Groups[2].Value, $match.Groups[3].Value.ToLowerInvariant()
        }
    }
    $recipe_files = @($dependency_inputs[0], "$checkout/tools/ci/Dockerfile.dockerignore")
    $ffmpeg_recipe = ''
    if ($Legacy) {
        $recipe_files += "$checkout/tools/kazarov/tools/ffmpeg/kz-ffmpeg"
    } else {
        # The Windows Docker stage consumes these constants rather than the host helper functions.
        $ffmpeg = [IO.File]::ReadAllText("$checkout/tools/kazarov/tools/ffmpeg/kz-ffmpeg")
        $constants = [regex]::Matches($ffmpeg, '(?m)^(?:VERSION|SHA256|LICENSE_LINE)\s*=.*$')
        $flags = [regex]::Match($ffmpeg, '(?ms)^CONFIGURE_FLAGS\s*=\s*\[.*?^\]')
        if ($constants.Count -ne 3 -or -not $flags.Success) { throw 'Cannot read the Windows FFmpeg recipe constants' }
        $ffmpeg_recipe = (@($constants | ForEach-Object { $_.Value }) -join "`n") + "`n" + $flags.Value
    }
    $pins = (@($declarations | Sort-Object -Unique) -join "`n") + "`n" +
        ((Get-FileHash -LiteralPath $recipe_files -Algorithm SHA256).Hash -join ':') + $ffmpeg_recipe
    $hasher = [Security.Cryptography.SHA256]::Create()
    try {
        return [BitConverter]::ToString($hasher.ComputeHash([Text.Encoding]::UTF8.GetBytes($pins))).Replace('-', '')
    } finally { $hasher.Dispose() }
}
$dependency_id = Get-DependencyId $checkout
$dependency_stamp = Join-Path $root 'deps/.chronicletwo-deps'
$dependencies_current = (Test-Path -LiteralPath $dependency_stamp) -and
    (Get-Content -LiteralPath $dependency_stamp -Raw).Trim() -eq $dependency_id
if (-not $dependencies_current -and (Test-Path -LiteralPath $dependency_stamp) -and
    (Get-Content -LiteralPath $dependency_stamp -Raw).Trim() -eq (Get-DependencyId $checkout -Legacy)) {
    # A verified installation with identical legacy inputs needs only the narrower fingerprint.
    Set-Content -LiteralPath $dependency_stamp -Value $dependency_id
    $dependencies_current = $true
}
$markers = @(
    'deps/llvm/llvm-mingw-20260922-ucrt-x86_64/bin/clang++.exe',
    'deps/ninja/ninja.exe',
    'deps/glslang/bin/glslang.exe',
    'deps/sdl/SDL3-3.4.18/x86_64-w64-mingw32/lib/cmake/SDL3',
    'deps/ffmpeg/bin/avcodec-63.dll',
    'deps/vulkan/Vulkan-Headers-vulkan-sdk-1.4.363.0/include',
    'deps/vulkan-runtime/VulkanRT-X64-1.4.363.0-Components/x64/vulkan-1.dll',
    'deps/rust/1.99.0-gnullvm/bin/cxxbridge.exe',
    'deps/sources/corrosion/CMakeLists.txt',
    'deps/cmake/cmake-4.4.5-windows-x86_64/bin/cmake.exe',
    'deps/python/python.exe',
    'deps/ccache/ccache-4.14.2-windows-x86_64/ccache.exe'
)
$missing_dependencies = @($markers | Where-Object { -not (Test-Path -LiteralPath (Join-Path $root $_)) }).Count -gt 0
if ($env:REBUILD_DEPS -eq '1' -or -not $dependencies_current -or $missing_dependencies) {
    $bundle_stamp = Join-Path $root 'deps/.chronicletwo-bundle-sha256'
    $archive = Join-Path $root 'deps.tar.gz'
    $export_stamp = Join-Path $root 'deps.inputs'
    if ($env:REBUILD_DEPS -eq '1' -or -not (Test-Path -LiteralPath $export_stamp) -or
        (Get-Content -LiteralPath $export_stamp -Raw).Trim() -ne $dependency_id -or
        -not (Test-Path -LiteralPath $archive) -or -not (Test-Path -LiteralPath (Join-Path $root 'deps.sha256'))) {
        Write-Stage 'exporting the Docker dependency bundle'
        & docker buildx build --target windows-bundle --output "type=local,dest=$root" -f "$checkout/tools/ci/Dockerfile" $checkout
        if ($LASTEXITCODE) { $deps.Dispose(); exit $LASTEXITCODE }
    }
    Write-Stage 'verifying the dependency archive'
    $bundle_hash = (Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash
    if ($bundle_hash -ne (Get-Content (Join-Path $root 'deps.sha256')).Trim()) {
        throw 'Dependency bundle checksum mismatch'
    }
    Set-Content -LiteralPath $export_stamp -Value $dependency_id
    if ($missing_dependencies -or -not (Test-Path -LiteralPath $bundle_stamp) -or
        (Get-Content -LiteralPath $bundle_stamp -Raw).Trim() -ne $bundle_hash) {
        Write-Stage 'unpacking the dependency archive'
        Remove-Item -LiteralPath $dependency_stamp, $bundle_stamp -Force -ErrorAction SilentlyContinue
        # Git Bash may put its MSYS tar ahead of Windows tools, with incompatible native path handling.
        $tar = Join-Path $env:SystemRoot 'System32/tar.exe'
        if (-not (Test-Path -LiteralPath $tar)) { $tar = Find-WindowsTool tar '' }
        & $tar -xzf $archive -C $root
        if ($LASTEXITCODE) { $deps.Dispose(); exit $LASTEXITCODE }
        Set-Content -LiteralPath $bundle_stamp -Value $bundle_hash
    }
    Set-Content -LiteralPath $dependency_stamp -Value $dependency_id
}
$deps.Dispose()
Write-Stage 'dependencies ready; checking CMake configuration'

# A stale cache is deleted before configuring: CMake would otherwise reuse paths that no longer exist.
function Read-CacheValue([string]$File, [string]$Key) {
    if (-not (Test-Path -LiteralPath $File)) { return $null }
    $match = Select-String -LiteralPath $File -Pattern "^$([regex]::Escape($Key)):[A-Z]+=(.*)$" | Select-Object -First 1
    if ($match) { return $match.Matches[0].Groups[1].Value.Trim() }
    return $null
}
$source = $checkout.Replace('\', '/')
$buildPath = $build.Replace('\', '/')
$ffmpegDir = "$($root.Replace('\', '/'))/deps/ffmpeg"
$cache = Join-Path $build 'CMakeCache.txt'
$cachedSource = Read-CacheValue $cache 'CMAKE_HOME_DIRECTORY'
$cachedBuild = Read-CacheValue $cache 'CMAKE_CACHEFILE_DIR'
$cachedFfmpeg = Read-CacheValue $cache 'KZ_FFMPEG_DIR'
$cached_cargo_home = Read-CacheValue $cache 'CT_WINDOWS_CARGO_HOME'
$stale = ($null -ne $cachedSource -and $cachedSource -ne $source) -or ($null -ne $cachedBuild -and $cachedBuild -ne $buildPath)
if ($stale) {
    foreach ($file in 'CMakeCache.txt', 'CMakeFiles', 'build.ninja', '.ninja_log', '.ninja_deps') {
        Remove-Item -LiteralPath (Join-Path $build $file) -Recurse -Force -ErrorAction SilentlyContinue
    }
}
# Ninja reuses its cache, so launcher-managed dependency paths must be refreshed explicitly.
$reconfigure = $cachedFfmpeg -ne $ffmpegDir -or $cached_cargo_home -ne "$($root.Replace('\', '/'))/deps/rust/cargo-home"
if ($stale -or $reconfigure -or -not (Test-Path -LiteralPath (Join-Path $build 'build.ninja'))) {
    Write-Stage 'configuring CMake'
    & "$PSScriptRoot/configure.ps1" -Root $root -BuildDirectory $build -BuildType $buildType -AddressSanitizer:($name -eq 'windows-x64-asan')
    if ($LASTEXITCODE) { exit $LASTEXITCODE }
} else {
    Write-Stage 'using cached CMake configuration'
}

# build.ps1 runs ninja, which builds only what changed.
$jobs = @{}
if ($env:JOBS) { $jobs = @{ Jobs = [int]$env:JOBS } }
& "$PSScriptRoot/build.ps1" -Root $root -BuildDirectory $build @jobs
if ($LASTEXITCODE) { exit $LASTEXITCODE }

if ($command -eq 'build') {
    $lock.Dispose()
    Write-Stage "built $build"
    exit 0
}

# A fast source-metadata/version check skips extraction for current data. The explicit
# dc2data check command still performs a full output hash audit.
# The retail image by name, else any disc image in rom/pal, else the PS2 build's extracted disc.
$source = Join-Path $checkout 'rom/pal/Dark Chronicle (PAL).iso'
if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
    $source = Get-ChildItem -LiteralPath (Join-Path $checkout 'rom/pal') -Filter '*.iso' -File -ErrorAction Ignore |
        Sort-Object Name | Select-Object -First 1 -ExpandProperty FullName
}
if (-not $source) {
    $source = Join-Path $checkout 'rom/pal/extracted/iso'
    if (-not (Test-Path -LiteralPath $source -PathType Container)) { $source = $null }
}

# dc2data takes <game-root>\data and publishes <game-root>\data.zip beside data.json.
$data = Join-Path $checkout 'port/run/data'
$dataArchive = Join-Path $checkout 'port/run/data.zip'
Write-Stage 'checking game data'
# Every port configuration extracts into the same port\run\data.zip, so they take one lock for it. The game holds it shared while it runs.
$dataLockFile = Join-Path $locks 'port-data.lock'
if (-not $source) {
    # Without a disc an existing data.zip is used; otherwise the game starts without its data.
    if (-not (Test-Path -LiteralPath $dataArchive -PathType Leaf)) {
        [Console]::Error.WriteLine('kazarov: no PAL disc found; the game starts without data and its file loads fail')
    }
} else {
    $dataLock = Open-WindowsDataLock $dataLockFile -Shared
    $dc2data = Join-Path $build 'dc2data.exe'
    try {
        & $dc2data current $source $data
        $data_current = $LASTEXITCODE -eq 0
    } finally { $dataLock.Dispose() }
    if (-not $data_current) {
        $dataLock = Open-WindowsDataLock $dataLockFile
        try {
            # Another configuration may finish extraction while this one waits for the writer lock.
            & $dc2data current $source $data
            if ($LASTEXITCODE) {
                Write-Stage 'extracting game data'
                & $dc2data extract $source $data
                if ($LASTEXITCODE) { exit $LASTEXITCODE }
            }
        } finally { $dataLock.Dispose() }
    }
}

$lock.Dispose()

# The game reads data.zip while it runs, so it holds the data lock shared; another configuration's extraction waits for it.
$dataShared = Open-WindowsDataLock $dataLockFile -Shared

if (-not $source -and (Test-Path -LiteralPath $dataArchive -PathType Leaf)) {
    # Without a disc, audit once per archive/marker/tool revision rather than hashing game data every launch.
    $dc2data = Join-Path $build 'dc2data.exe'
    $audit_stamp = Join-Path $state "$name-data-audit.txt"
    $audit_id = Get-WindowsDataAuditId $dataArchive (Join-Path $checkout 'port/run/data.json') $dc2data
    if (-not (Test-Path -LiteralPath $audit_stamp) -or (Get-Content -LiteralPath $audit_stamp -Raw).TrimEnd() -ne $audit_id) {
        & $dc2data check $data
        if ($LASTEXITCODE) { $dataShared.Dispose(); exit $LASTEXITCODE }
        $audit_temporary = "$audit_stamp.$([Guid]::NewGuid()).tmp"
        [IO.File]::WriteAllText($audit_temporary, $audit_id)
        Move-Item -LiteralPath $audit_temporary -Destination $audit_stamp -Force
    }
}

Push-Location $checkout
# Script runs log at debug to the console (docs/LOGGING.md); a DC2_LOG of the user's own still wins.
if (-not $env:DC2_LOG) { $env:DC2_LOG = 'debug' }
Write-Stage 'starting darkchronicle'
& (Join-Path $build 'darkchronicle.exe') --run-dir (Join-Path $checkout 'port/run') @rest
$code = $LASTEXITCODE
Pop-Location
$dataShared.Dispose()
exit $code
