# The toolchain image, in three stages:
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
        libc6-i386 \
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
COPY --from=ghcr.io/decompals/wibo:latest /usr/local/bin/wibo /usr/bin/

# splat is the disassembler; its MIPS support (spimdisasm, rabbitizer) is an
# extra and has to be asked for by name. libclang turns the headers into the
# context m2c reads.
RUN python3 -m venv $VIRTUAL_ENV
RUN python -m pip install --no-cache-dir "splat64[mips]==0.50.0" libclang

#
# Development stage
#
FROM base AS dev

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
