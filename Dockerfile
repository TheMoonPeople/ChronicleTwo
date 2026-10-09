# The toolchain image, with a separate compiler-wrapper build stage:
#   docker build -t chronicletwo_dev --target dev .      # toolchain + diffing tools
#   docker build -t chronicletwo_build --target build .  # one-shot build of the tree
# build.sh, run.sh and dev.sh use the first, with the tree mounted; the second
# bakes a copy of the sources in, for a build that needs nothing mounted but
# rom/. Everything here is plain OCI, so podman works too.
#
# The image is x86_64 because wibo, which runs the Windows-hosted Metrowerks
# compiler and linker, needs a real x86_64 Linux kernel. On an Apple-silicon
# Mac that means an x86_64 colima VM, not Docker Desktop's Rosetta emulation;
# see scripts/host/container.sh.
#
# Debian for glibc (the toolchain binaries are glibc-linked), trixie because
# binutils-mips-ps2-decompals needs glibc 2.38 and bookworm ships 2.36.
# Build the pinned compiler wrapper separately from its runtime dependencies.
FROM --platform=linux/amd64 debian:trixie-slim AS satansfiddle-build
ARG SATANSFIDDLE_REV=365415fa2fd7bf69e899044b704b571a64ed4e6c
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates git cargo build-essential liblldb-19-dev \
    && rm -rf /var/lib/apt/lists/*
ENV LLDB_INCLUDE=/usr/lib/llvm-19/include
ENV LLDB_LIB_DIR=/usr/lib/llvm-19/lib
WORKDIR /satansfiddle
RUN git init \
    && git remote add origin https://github.com/Adubbz/SatansFiddle.git \
    && git fetch --depth 1 origin ${SATANSFIDDLE_REV} \
    && git checkout --detach FETCH_HEAD
COPY scripts/build/patches/satansfiddle-nested-arguments.patch /tmp/satansfiddle-nested-arguments.patch
RUN git apply --check /tmp/satansfiddle-nested-arguments.patch \
    && git apply /tmp/satansfiddle-nested-arguments.patch
COPY scripts/build/patches/satansfiddle-control-context.patch /tmp/satansfiddle-control-context.patch
RUN git apply --check /tmp/satansfiddle-control-context.patch \
    && git apply /tmp/satansfiddle-control-context.patch
COPY scripts/build/patches/satansfiddle-placement-new.patch /tmp/satansfiddle-placement-new.patch
RUN git apply --check /tmp/satansfiddle-placement-new.patch \
    && git apply /tmp/satansfiddle-placement-new.patch
# Rust 1.85 can place native libraries before the LLDB C++ archive. Stage-local
# flags supply trailing libraries to the CLI, Cargo test runners and dependency
# build scripts. The explicit search path lets their trailing -llldb resolve
# the same LLVM-19 installation even without this package's build.rs flags.
# This recipe can change wrapper artifacts; equivalence is checked on game objects.
ENV RUSTFLAGS="-L native=/usr/lib/llvm-19/lib -C link-arg=-llldb -C link-arg=-lstdc++"
RUN cargo build --release --locked --jobs 3 \
    && cp target/release/satansfiddle /satansfiddle-production \
    && cargo test --release --locked --jobs 3 --features hook-test-faults \
    && mkdir /satansfiddle-tests \
    && cp target/release/satansfiddle /satansfiddle-tests/satansfiddle-fault-test \
    && find target/release/deps -maxdepth 1 -name 'compiler_cli-*' -type f -executable \
        -exec cp {} /satansfiddle-tests/ \;

FROM --platform=linux/amd64 debian:trixie-slim AS base

# Tool versions
ARG BINUTILS_VERSION=v0.10
ARG CLANGD_VERSION=22.1.6
ARG OBJDIFF_VERSION=v3.7.3

# The virtual environment comes first on PATH, so `python3` in every script is
# the one with splat installed.
ENV DEBIAN_FRONTEND=noninteractive
ENV BINUTILS=/usr/local/binutils-mips-ps2-decompals
ENV VIRTUAL_ENV=/opt/venv
ENV PATH=${VIRTUAL_ENV}/bin:$PATH:${BINUTILS}

# Base requirements. cmake and ninja drive the build; util-linux provides the
# flock every build of the tree takes (scripts/build/cmake.sh); coreutils
# provides the sha256sum that checks the disc and what was extracted from it.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        coreutils \
        git \
        gnupg \
        gpg-agent \
        sudo \
        unzip \
        util-linux \
        wget \
        python3 \
        python3-venv \
        cmake \
        ninja-build \
        gdb \
        lldb-19 \
    && rm -rf /var/lib/apt/lists/*

# The binutils built for PS2 decompilation projects: the assembler the split
# assembly goes through and every objcopy/objdump/readelf the build and the
# scripts use.
RUN wget -O /tmp/binutils.tar.gz \
        https://github.com/decompals/binutils-mips-ps2-decompals/releases/download/${BINUTILS_VERSION}/binutils-mips-ps2-decompals-linux-x86-64.tar.gz \
    && mkdir -p ${BINUTILS} \
    && tar xzf /tmp/binutils.tar.gz -C ${BINUTILS} \
    && rm /tmp/binutils.tar.gz

# wibo runs the Windows-hosted Metrowerks compiler and linker.
# This image contains the unstripped loader symbols required by LLDB hooks.
COPY --from=ghcr.io/decompals/wibo@sha256:3a89948cf841cd6ae2555eb9d8b8ba60c35700852afc5fd9bd62660ef3d201f5 /usr/local/bin/wibo /usr/bin/
COPY --from=satansfiddle-build /satansfiddle-production /usr/local/bin/satansfiddle
ENV LLDB_DEBUGSERVER_PATH=/usr/lib/llvm-19/bin/lldb-server

# splat is the disassembler; its MIPS support (spimdisasm, rabbitizer) is an
# extra and has to be asked for by name. libclang turns the headers into the
# context m2c reads.
RUN python3 -m venv $VIRTUAL_ENV
RUN python -m pip install --no-cache-dir "splat64[mips]==0.50.0" libclang

#
# Development stage
#
FROM base AS dev

COPY --from=satansfiddle-build /satansfiddle-tests/ /usr/local/libexec/satansfiddle-tests/

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        less \
        build-essential \
        doxygen \
        unzip \
    && rm -rf /var/lib/apt/lists/*

# clangd is fetched rather than installed from apt: Debian trixie stops at 19.
RUN wget -O /tmp/clangd.zip \
        https://github.com/clangd/clangd/releases/download/${CLANGD_VERSION}/clangd-linux-${CLANGD_VERSION}.zip \
    && unzip -q /tmp/clangd.zip -d /opt \
    && ln -s /opt/clangd_${CLANGD_VERSION}/bin/clangd /usr/local/bin/clangd \
    && ln -s /opt/clangd_${CLANGD_VERSION}/bin/clangd /usr/bin/clangd \
    && rm /tmp/clangd.zip

# objdiff compares each unit against retail and produces the progress report.
# The GUI is not installed, since this image has no display.
RUN wget -O /usr/local/bin/objdiff-cli \
        https://github.com/encounter/objdiff/releases/download/${OBJDIFF_VERSION}/objdiff-cli-linux-x86_64 \
    && chmod +x /usr/local/bin/objdiff-cli

# Required by decomp-permuter
RUN python -m pip install --no-cache-dir toml levenshtein

#
# Build stage
#
FROM base AS build

WORKDIR /chronicletwo

# .dockerignore keeps this to the sources: the disc image, the split and the
# build tree are mounted rather than copied.
COPY . .

# Build and verify the executable, through the same cmake.sh the entry points
# use. rom/ has to be mounted in; mounting ps2/asm/ and build/ too keeps the
# split and the objects between runs.
CMD ["scripts/build/cmake.sh", "build"]
