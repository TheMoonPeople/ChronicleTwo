# Shared container plumbing, sourced from the project root; not run on its own.
# `in_container` is how the entry points notice they are already inside one
# and skip starting another.
#
# Which container runtime runs the build:
# - BUILDER, when set, names it outright (BUILDER=docker ./build.sh); a
#   DOCKER_CONTEXT set alongside it is used as it is.
# - On an Apple-silicon Mac, docker in an x86_64 colima VM. wibo, which runs
#   the Metrowerks compiler, needs a real x86_64 Linux kernel; under Docker
#   Desktop's or podman's Rosetta emulation it dies with "rosetta error:
#   invalid gdt selector". A DOCKER_CONTEXT already set is trusted to name
#   such a VM; otherwise the first running x86_64 colima profile is used.
# - Anywhere else, podman, or docker when podman is not installed.

# Where the tree is mounted, for every script that starts a container. Fixed,
# and the same path the devcontainer uses: they share build/, and
# CMakeCache.txt records the source directory it was configured for.
CONTAINER_WORKDIR=/chronicletwo

# The development image every entry point runs.
IMAGE=chronicletwo_dev

# Both runtimes leave a marker file, and podman also exports $container. The
# devcontainer CLI starts the same image, so it is covered by the same markers.
if [ -f /run/.containerenv ] || [ -f /.dockerenv ] || [ -n "${container:-}" ]; then
    IN_CONTAINER=1
else
    IN_CONTAINER=0
fi

in_container() {
    [ "$IN_CONTAINER" = 1 ]
}

# Why no runtime was chosen, for require_builder to explain.
BUILDER_PROBLEM=

is_apple_silicon() {
    [ "$(uname -s)" = Darwin ] && [ "$(uname -m)" = arm64 ]
}

# The docker context of the first x86_64 colima profile, exported as
# DOCKER_CONTEXT; fails, saying why in BUILDER_PROBLEM, when there is none or
# it is not running.
use_colima() {
    if ! command -v colima >/dev/null 2>&1 || ! command -v docker >/dev/null 2>&1; then
        BUILDER_PROBLEM=no-colima
        return 1
    fi
    # One JSON object per profile, e.g.
    # {"name":"chronicletwo","status":"Running","arch":"x86_64",...}
    profiles=$(colima list --json 2>/dev/null | grep '"arch":"x86_64"') || true
    if [ -z "$profiles" ]; then
        BUILDER_PROBLEM=no-profile
        return 1
    fi
    running=$(printf '%s\n' "$profiles" | grep '"status":"Running"' | head -1)
    if [ -z "$running" ]; then
        COLIMA_PROFILE=$(printf '%s\n' "$profiles" | head -1 \
                         | sed 's/.*"name":"\([^"]*\)".*/\1/')
        BUILDER_PROBLEM=stopped
        return 1
    fi
    COLIMA_PROFILE=$(printf '%s\n' "$running" | sed 's/.*"name":"\([^"]*\)".*/\1/')
    # colima names the context of its default profile plain `colima`.
    if [ "$COLIMA_PROFILE" = default ]; then
        DOCKER_CONTEXT=colima
    else
        DOCKER_CONTEXT=colima-$COLIMA_PROFILE
    fi
    export DOCKER_CONTEXT
}

if [ -z "${BUILDER:-}" ] && ! in_container; then
    if is_apple_silicon; then
        if [ -n "${DOCKER_CONTEXT:-}" ] || use_colima; then
            BUILDER=docker
        fi
    elif command -v podman >/dev/null 2>&1; then
        BUILDER=podman
    elif command -v docker >/dev/null 2>&1; then
        BUILDER=docker
    else
        BUILDER_PROBLEM=none
    fi
fi
BUILDER=${BUILDER:-}

# Only wanted on the host. Sourcing this file inside the container must not
# fail: the scripts that can do their own work there never call it.
require_builder() {
    if [ -n "$BUILDER" ]; then
        return
    fi
    if in_container; then
        echo "$(basename "$0") starts a container, so it cannot run inside one." >&2
        echo "Run it on the host instead." >&2
        exit 1
    fi
    case $BUILDER_PROBLEM in
        stopped)
            echo "The x86_64 colima VM '$COLIMA_PROFILE' is not running. Start it with:" >&2
            echo "  colima start --profile $COLIMA_PROFILE" >&2 ;;
        no-colima|no-profile)
            echo "On an Apple-silicon Mac the build runs in an x86_64 colima VM: the" >&2
            echo "compiler runs under wibo, which Rosetta emulation cannot run." >&2
            if [ "$BUILDER_PROBLEM" = no-colima ]; then
                echo "Install colima and the docker CLI:" >&2
                echo "  brew install colima docker" >&2
            fi
            echo "Create the VM (once; it emulates x86_64, so give it what you can spare):" >&2
            echo "  colima start --profile chronicletwo --arch x86_64 --cpu 4 --memory 8" >&2
            echo "Or name a runtime outright: BUILDER=docker DOCKER_CONTEXT=<context> $(basename "$0")" >&2 ;;
        *)
            echo "Podman or Docker not found! Please install one from:" >&2
            echo "  https://podman.io/docs/installation" >&2
            echo "  https://docs.docker.com/desktop/install" >&2 ;;
    esac
    exit 1
}

# A sha256 hex digest over the files that feed the dev image: the Dockerfile
# and each patch in scripts/build/patches/, in name order. Each file's path is
# hashed along with its contents, so a rename changes the digest. Prints only
# the digest.
image_inputs_hash() {
    if command -v sha256sum >/dev/null 2>&1; then
        sha256=sha256sum
    else
        sha256="shasum -a 256"
    fi
    {
        printf '%s\n' Dockerfile
        ls scripts/build/patches | LC_ALL=C sort | sed 's|^|scripts/build/patches/|'
    } | while IFS= read -r file; do
        printf '%s\n' "$file"
        cat "$file"
    done | $sha256 | cut -d' ' -f1
}

# Build the dev image when it is missing, or when the Dockerfile or
# scripts/build/patches/ have changed since it was built; the hash of those
# inputs is recorded in its chronicletwo.inputs label. Set REBUILD_IMAGE=1 to
# force a build, e.g. after a change the hash cannot see, such as a new
# upstream base image.
ensure_image() {
    if in_container; then
        return
    fi
    require_builder

    hash=$(image_inputs_hash)
    if [ "${REBUILD_IMAGE:-0}" != 1 ] \
       && label=$("$BUILDER" image inspect --format '{{ index .Config.Labels "chronicletwo.inputs" }}' "$IMAGE" 2>/dev/null); then
        if [ "$label" = "$hash" ]; then
            return
        fi
        echo "The Dockerfile or scripts/build/patches/ changed since the dev image ($IMAGE) was built; rebuilding it."
    else
        echo "Building the dev image ($IMAGE); this takes a while, once."
    fi
    "$BUILDER" build --label "chronicletwo.inputs=$hash" -t "$IMAGE" --target dev .
}

# How much of the machine the build gets. podman and colima run the build in
# a virtual machine with a CPU count of its own, which caps every parallel
# step in the build without saying so; reported once per run. Nothing here
# fails: a runtime with no VM to inspect simply has nothing to report.
report_parallelism() {
    if in_container; then
        return 0
    fi

    vm_cpus=
    case $BUILDER in
        podman)
            vm_cpus=$(podman machine inspect --format '{{.Resources.CPUs}}' 2>/dev/null \
                      | head -1) || true ;;
        docker)
            vm_cpus=$(docker info --format '{{.NCPU}}' 2>/dev/null) || true ;;
    esac
    case $vm_cpus in
        ''|*[!0-9]*) return 0 ;;
    esac

    host_cpus=$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 0)
    case $host_cpus in
        ''|*[!0-9]*) return 0 ;;
    esac

    [ "$host_cpus" -gt "$vm_cpus" ] || return 0

    echo "The build VM has $vm_cpus of this host's $host_cpus CPUs; the build is only as"
    echo "parallel as that."
    if [ -n "${COLIMA_PROFILE:-}" ]; then
        echo "  colima stop --profile $COLIMA_PROFILE"
        echo "  colima start --profile $COLIMA_PROFILE --cpu $host_cpus"
    elif [ "$BUILDER" = podman ]; then
        echo "  podman machine stop"
        echo "  podman machine set --cpus $host_cpus"
        echo "  podman machine start"
    fi
}

# The disc image, and the executable extracted from it.
RETAIL_ISO="rom/pal/Dark Chronicle (PAL).iso"
RETAIL_ELF=rom/pal/extracted/iso/SCES_511.90

# The disc image itself, for what masters or boots a disc (run.sh).
require_iso() {
    if [ ! -f "$RETAIL_ISO" ]; then
        echo "$RETAIL_ISO is missing." >&2
        echo "Place the PAL disc image there and try again." >&2
        exit 1
    fi
}

# Something to split ps2/asm/ from: the disc, or the executable already
# extracted from it.
require_rom() {
    if [ ! -f "$RETAIL_ISO" ] && [ ! -f "$RETAIL_ELF" ]; then
        echo "$RETAIL_ISO is missing." >&2
        echo "Place the PAL disc image there and try again." >&2
        exit 1
    fi
}
