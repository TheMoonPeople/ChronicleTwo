"""Migrate asset literals in the native source mirror without changing PS2 code.

These are compile-time source edits, never runtime alias lookup. Resource-bearing
configuration fields are migrated separately by the Rust extractor. Comments,
character constants and raw strings are left untouched. Bare profile arguments
of character loading calls become semantic profile names rather than filenames.
"""

import re


SUFFIXES = {
    "chr": "gltf",
    "mds": "gltf",
    "mdt": "gltf",
    "mot": "gltf",
    "wgt": "gltf",
    "bbp": "gltf",
    "ico": "gltf",
    "cfg": "cfg.json",
    "map": "map.json",
    "img": "json",
    "tm2": "json",
    "snd": "sound.json",
    "pss": "mp4",
}
PROFILE_CALLS = {"LoadPack": 1, "LoadPackNoLine": 1, "LoadChrFile": 1, "LoadSkin": 1, "CreateChara": 1, "LoadChara": 2}
PROFILE_INITIALIZERS = {"npccfg.cpp": {"infocfg"}, "menuchr.cpp": {"menu_infocfgname"}}
PROFILE_FORMAT_TARGETS = {"monster.cpp": {"config_path"}}
PROFILE_SUFFIX_TARGETS = {"menuchr.cpp": {"file_name"}}
INITIALIZER = re.compile(r"\b([A-Za-z_]\w*)\s*(?:\[[^\]]*\])?\s*=\s*$")
TOKENS = re.compile(
    r'//[^\n]*|/\*[\s\S]*?\*/|R"(?P<delimiter>[^ ()\\\t\r\n]{0,16})\([\s\S]*?\)(?P=delimiter)"'
    r'|"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'|[A-Za-z_]\w*|[(),]|[^\w\s]'
)
EXTENSION = re.compile(r"\.(chr|mds|mdt|mot|wgt|bbp|ico|cfg|map|img|tm2|snd|pss)(?=(?:;1)?$)", re.IGNORECASE)
DIRECTORY_CALLS = {"GetPackFile": "AssetDirectoryRead", "GetPackFileExt": "AssetDirectoryReadExtension", "GetPackFileNum": "AssetDirectoryCount"}
DIRECTORY_KINDS = {"img": "texture", "cfg": "commands", "mds": "gltf", "chr": "gltf"}
SCENE_AUDIO_PATHS = {"snd2/rev.bin": "snd2/rev.json", "snd2/map_index.txt": "snd2/map_index.json"}
DISTINCT_MODEL_PATHS = {
    "etc/gsys.pak/a_mu.mds": "etc/gsys.pak/a_mu.model.gltf",
    "etc/gsys.pak/sukkopu.mds": "etc/gsys.pak/sukkopu.model.gltf",
}
DIRECTORY_MEMBER_PATHS = {
    "editmode.cpp": {
        "etc/g_edit.img", "etc/cone.mds", "etc/hake.chr", "etc/a_mu.chr", "etc/sukkopu.chr",
    },
}


def rewrite(text: str, unit: str | None = None) -> str:
    """Rewrite direct asset paths and character profile literals in C++ tokens."""
    frames = []
    previous = ""
    replacements = []
    tokens = list(TOKENS.finditer(text))
    for position, token in enumerate(tokens):
        value = token.group()
        if value.startswith(("//", "/*", 'R"', "'")):
            continue
        if value == "(":
            frames.append([previous, 0])
        elif value == ")":
            if frames:
                frames.pop()
        elif value == ",":
            if frames:
                frames[-1][1] += 1
        elif value.startswith('"'):
            literal = value[1:-1]
            if frames and frames[-1] == ["GetPackFile", 1] and literal.lower() in DIRECTORY_MEMBER_PATHS.get(unit, ()):
                literal = literal.removeprefix("etc/")
            profile = frames and frames[-1][0] in PROFILE_CALLS and frames[-1][1] == PROFILE_CALLS[frames[-1][0]]
            if unit in PROFILE_INITIALIZERS:
                initializer = INITIALIZER.search(text[max(0, token.start() - 128):token.start()])
                profile = profile or (initializer and initializer[1] in PROFILE_INITIALIZERS[unit])
            target = tokens[position - 2].group() if position >= 2 else ""
            if frames and frames[-1] == ["sprintf", 1]:
                profile = profile or target in PROFILE_FORMAT_TARGETS.get(unit, ())
            if frames and frames[-1] == ["strcat", 1]:
                profile = profile or target in PROFILE_SUFFIX_TARGETS.get(unit, ())
            directory_kind = frames and frames[-1][0] == "GetPackFileExt" and frames[-1][1] == 1
            if directory_kind:
                migrated = DIRECTORY_KINDS.get(literal.lower(), literal)
            elif literal.lower() in SCENE_AUDIO_PATHS:
                migrated = SCENE_AUDIO_PATHS[literal.lower()]
            elif literal.lower() in DISTINCT_MODEL_PATHS:
                migrated = DISTINCT_MODEL_PATHS[literal.lower()]
            elif profile and literal.lower().endswith(".cfg") and "/" not in literal and "\\" not in literal:
                migrated = literal[:-4]
            else:
                migrated = re.sub(r"\.chr_$", "_.gltf", literal, flags=re.IGNORECASE)
                migrated = EXTENSION.sub(lambda match: "." + SUFFIXES[match[1].lower()], migrated)
                if "/" not in migrated and "\\" not in migrated:
                    if len(migrated) > len(".wav") and migrated.lower().endswith(".wav"):
                        migrated = "sound/" + migrated
                    elif migrated.lower() not in (".mp4", ".mp4;1") and migrated.lower().endswith((".mp4", ".mp4;1")):
                        migrated = "movie/" + migrated
            if migrated != literal:
                replacements.append((token.start(), token.end(), '"' + migrated + '"'))
        elif value == "memcpy" and position + 1 < len(tokens) and tokens[position + 1].group() == "(":
            replacements.append((token.start(), token.end(), "PortTextureSourceCopy"))
        elif value in DIRECTORY_CALLS and position + 1 < len(tokens) and tokens[position + 1].group() == "(":
            replacements.append((token.start(), token.end(), DIRECTORY_CALLS[value]))
        elif unit == "fishing.cpp" and value == "bgm_path" and frames and frames[-1] == ["GetPackFile", 1]:
            replacements.append((token.start(), token.end(), "AssetMemberName(bgm_path)"))
        previous = value
    for start, end, replacement in reversed(replacements):
        text = text[:start] + replacement + text[end:]
    return text
