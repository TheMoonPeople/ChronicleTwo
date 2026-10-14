# Flatpak

The Linux release of the PC port (`docs/PC.md`) is a Flatpak,
`org.themoonpeople.ChronicleTwo`. It holds `darkchronicle` and `dc2data` on the
freedesktop 26.08 runtime, whose SDL3 and Vulkan loader it uses. No game data is in it: the first start asks for
your own PAL disc and extracts it.

## Installing the bundle

CI (`.github/workflows/pc.yml`) uploads `chronicletwo.flatpak` with every
build. The runtime comes from Flathub:

```sh
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install --user chronicletwo.flatpak
flatpak run org.themoonpeople.ChronicleTwo
```

It also appears in the desktop's application list as Chronicle Two.

## The first start

With no current game data, the game opens Kazarov's data setup window
(`docs/PC.md`, "Game data and first run"), which takes a Dark Chronicle disc
image or a folder holding `DATA.HD4`, `DATA.DAT`, `SOUND.HD3`, `SOUND.DAT` and
`MOVIE`. Inside the Flatpak its file selector is the desktop's file-chooser
portal, so the game reads the chosen file without any permission to your
files. It extracts and converts the disc into the data directory, then
continues into the game. Closing the window instead exits with status 3 and
prints the `dc2data` command below.

### From a shell

`dc2data` does the same from a script. It needs read access to the folder
holding the image, granted for that one command:

```sh
flatpak run --filesystem="$HOME/Games:ro" --command=dc2data org.themoonpeople.ChronicleTwo \
    extract "$HOME/Games/Dark Chronicle (PAL).iso" ~/.var/app/org.themoonpeople.ChronicleTwo/data/chronicletwo/data
```

## Where things live

Inside the sandbox `XDG_DATA_HOME` is `~/.var/app/org.themoonpeople.ChronicleTwo/data`,
so:

| | |
|---|---|
| game data | `~/.var/app/org.themoonpeople.ChronicleTwo/data/chronicletwo/data` and `port_data` beside it |
| saves, `config.json`, the pipeline cache | `~/.var/app/org.themoonpeople.ChronicleTwo/data/chronicletwo/saves` |

`config.json` is described in `docs/PC.md`. `flatpak uninstall --delete-data
org.themoonpeople.ChronicleTwo` removes both. The usual options still apply:
`flatpak run org.themoonpeople.ChronicleTwo --window 1920x1080`.

## Controls

Keyboard, mouse and gamepads as in `docs/PC.md`.

## Permissions

| finish-arg | why |
|---|---|
| `--socket=wayland` | the window, on Wayland |
| `--socket=fallback-x11` | the window on an X11 session; ignored when Wayland is there |
| `--share=ipc` | X11 shared memory, without which fallback-x11 is slow or broken |
| `--device=dri` | the GPU, for Vulkan and the data setup window's OpenGL |
| `--socket=pulseaudio` | sound, through PipeWire's or PulseAudio's PulseAudio socket |
| `--device=all` | gamepads: `/dev/input`, and `/dev/hidraw*` for those SDL reads through HIDAPI `--device=input` covers only `/dev/input` |

There is no network and no filesystem access. The disc reaches the game
through the file-chooser portal, which every Flatpak may call without a
`--talk-name`.

## Building

```sh
port/flatpak.sh
```

builds `chronicletwo.flatpak` in the repository root from the working tree,
installing the runtime, the SDK and the llvm22 extension from Flathub when
they are missing. `INSTALL=1` also installs the bundle for this user;
`CLEAN=1` discards flatpak-builder's cache first. By hand, the same is:

```sh
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install --user flathub org.freedesktop.Platform//26.08 org.freedesktop.Sdk//26.08 \
    org.freedesktop.Sdk.Extension.llvm22//26.08
flatpak-builder --repo=repo build-dir port/flatpak/org.themoonpeople.ChronicleTwo.yml
flatpak build-bundle repo chronicletwo.flatpak org.themoonpeople.ChronicleTwo
```

(`flatpak-builder --install-deps-from=flathub ...` installs the three for
you.) Run from the repository root; `build-dir/`, `repo/`, `.flatpak-builder/`
and `chronicletwo.flatpak` are ignored by git. `flatpak-builder --user --install
build-dir port/flatpak/org.themoonpeople.ChronicleTwo.yml` installs the build
directly instead of through a bundle.

The manifest (`port/flatpak/org.themoonpeople.ChronicleTwo.yml`) builds the port
and what it needs for the build alone; SDL3 and the Vulkan headers come from the
SDK:

- **nlohmann/json**, the header from its release archive.
- **FFmpeg 7.1.1**, static libavcodec and libavutil with the MPEG-2 video
  decoder alone, configured as `tools/kazarov/tools/ffmpeg/kz-ffmpeg` builds it
  (LGPL only), for the movies.
- **Rust 1.99.0**, the official archive Kazarov's image installs, newer than
  the SDK's `rust-stable` extension.
- **cxxbridge 1.0.205**, cxx's code generator, built from the vendored crates;
  Corrosion uses it because its version is cxx's.
- **The port**, `PLATFORM=PC`, Release, with clang 22 from the
  `org.freedesktop.Sdk.Extension.llvm22` extension (the SDK's own compiler is
  GCC, and the port is built with clang everywhere) and Kazarov's Rust data
  setup built by that Rust through Corrosion 0.6.1, the release `KazarovRust.cmake` pins. Shaders are
  compiled with the SDK's glslang, which targets `vulkan1.4`. The SDK's default
  compiler flags are replaced: they add `_GLIBCXX_ASSERTIONS`,
  `-Werror=format-security` and `-g`, none of which the game is built with
  elsewhere.

The build has no network, so every Rust crate in `tools/kazarov/Cargo.lock` is
downloaded beforehand: `port/flatpak/cargo-sources.json` lists them, and
`port/flatpak/cargo_sources.py` writes it again from the lock, which it must be
whenever the Kazarov pin changes the lock. The single-file decoders
`KazarovPort.cmake` would otherwise fetch are given through
`KZ_PORT_VENDOR_DIRS`.

The app module's source is the working tree (`type: dir`); CI swaps it for a
`git` source at the commit under test. Vulkan validation layers are not
shipped. The bundle carries no Vulkan driver of its own: the runtime's Mesa
(`org.freedesktop.Platform.GL.default`) or the host's NVIDIA driver extension
provides it.
