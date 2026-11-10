#!/usr/bin/env python3
"""Disassemble the VU1 programs in the retail ELF, one listing per program.

    vu1dis.py [--elf FILE] [--symbols FILE] [--out DIR] [--program NAME]
"""

import argparse
import re
import struct
import sys
from dataclasses import dataclass, field
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
DEFAULT_ELF = ROOT / "rom/pal/extracted/iso/SCES_511.90"
DEFAULT_SYMBOLS = ROOT / "ps2/config/pal/main.symbols.txt"
DEFAULT_OUT = ROOT / "port/build/vu1"
KAZAROV_PYTHON = ROOT / "tools/kazarov/scripts"

# Address order: a program runs until the next one's start unless it has an explicit end.
PROGRAMS = [
    ("Vu_prog_3dsp", "prog_3dsp.txt"),
    ("Vu_prog_sdw", "prog_sdw.txt"),
    ("Vu_progmain", "progmain.txt"),
    ("Vu_prog0", "prog0.txt"),
    ("Vu_prog_wtr", "prog_wtr.txt"),
    ("My_dma_start0", "dma_start0.txt"),
]
PROGRAM_ENDS = {"Vu_prog_wtr": 0x32A320, "My_dma_start0": 0x363580}

DMA_NAMES = ("refe", "cnt", "next", "ref", "refs", "call", "ret", "end")
DMA_DATA_FREE = ("ref", "refs", "refe")

VIF_NAMES = {
    0x00: "NOP", 0x01: "STCYCL", 0x02: "OFFSET", 0x03: "BASE", 0x04: "ITOP", 0x05: "STMOD",
    0x06: "MSKPATH3", 0x07: "MARK", 0x10: "FLUSHE", 0x11: "FLUSH", 0x13: "FLUSHA",
    0x14: "MSCAL", 0x15: "MSCALF", 0x17: "MSCNT", 0x20: "STMASK", 0x30: "STROW", 0x31: "STCOL",
    0x4A: "MPG", 0x50: "DIRECT", 0x51: "DIRECTHL",
}
UNPACK_BITS = (32, 16, 8, 5)

GS_REG_NAMES = {
    0x00: "PRIM", 0x01: "RGBAQ", 0x02: "ST", 0x03: "UV", 0x04: "XYZF2", 0x05: "XYZ2",
    0x06: "TEX0_1", 0x07: "TEX0_2", 0x08: "CLAMP_1", 0x0A: "FOG", 0x0C: "XYZF3", 0x0D: "XYZ3",
    0x14: "TEX1_1", 0x16: "TEX2_1", 0x18: "XYOFFSET_1", 0x1A: "PRMODECONT", 0x1B: "PRMODE",
    0x1C: "TEXCLUT", 0x22: "SCANMSK", 0x34: "MIPTBP1_1", 0x3B: "TEXA", 0x3D: "FOGCOL",
    0x3F: "TEXFLUSH", 0x40: "SCISSOR_1", 0x42: "ALPHA_1", 0x44: "DIMX", 0x45: "DTHE",
    0x46: "COLCLAMP", 0x47: "TEST_1", 0x49: "PABE", 0x4A: "FBA_1", 0x4C: "FRAME_1",
    0x4E: "ZBUF_1", 0x50: "BITBLTBUF", 0x51: "TRXPOS", 0x52: "TRXREG", 0x53: "TRXDIR",
}
GIF_REG_NAMES = {
    0x0: "PRIM", 0x1: "RGBAQ", 0x2: "ST", 0x3: "UV", 0x4: "XYZF2", 0x5: "XYZ2", 0x6: "TEX0_1",
    0x7: "TEX0_2", 0x8: "CLAMP", 0x9: "FOG", 0xC: "XYZF3", 0xD: "XYZ3", 0xE: "A+D", 0xF: "NOP",
}
GIF_FLG_NAMES = ("packed", "reglist", "image", "disabled")

UPPER_BC_BASE = {0x00: "add", 0x04: "sub", 0x08: "madd", 0x0C: "msub", 0x10: "max", 0x14: "mini", 0x18: "mul"}
UPPER_NAMED = {
    0x1C: ("mulq", "Q"), 0x1D: ("maxi", "I"), 0x1E: ("muli", "I"), 0x1F: ("minii", "I"),
    0x20: ("addq", "Q"), 0x21: ("maddq", "Q"), 0x22: ("addi", "I"), 0x23: ("maddi", "I"),
    0x24: ("subq", "Q"), 0x25: ("msubq", "Q"), 0x26: ("subi", "I"), 0x27: ("msubi", "I"),
    0x28: ("add", None), 0x29: ("madd", None), 0x2A: ("mul", None), 0x2B: ("max", None),
    0x2C: ("sub", None), 0x2D: ("msub", None), 0x2E: ("opmsub", None), 0x2F: ("mini", None),
}
UPPER_ACC = {
    0x1C: ("mulaq", "Q"), 0x1E: ("mulai", "I"), 0x20: ("addaq", "Q"), 0x21: ("maddaq", "Q"),
    0x22: ("addai", "I"), 0x23: ("maddai", "I"), 0x24: ("subaq", "Q"), 0x25: ("msubaq", "Q"),
    0x26: ("subai", "I"), 0x27: ("msubai", "I"), 0x28: ("adda", None), 0x29: ("madda", None),
    0x2A: ("mula", None), 0x2C: ("suba", None), 0x2D: ("msuba", None), 0x2E: ("opmula", None),
}
UPPER_CONVERT = ("itof0", "itof4", "itof12", "itof15", "ftoi0", "ftoi4", "ftoi12", "ftoi15")
UPPER_ACC_BC = ("adda", "suba", "madda", "msuba")

LOWER_E_OPS = {
    0x70: "esadd", 0x71: "ersadd", 0x72: "eleng", 0x73: "erleng", 0x74: "eatanxy", 0x75: "eatanxz",
    0x76: "esum", 0x78: "esqrt", 0x79: "ersqrt", 0x7A: "ercpr", 0x7C: "esin", 0x7D: "eatan", 0x7E: "eexp",
}
BRANCH_TOPS = {0x20, 0x21, 0x28, 0x29, 0x2C, 0x2D, 0x2E, 0x2F}

PT_LOAD = 1
SHF_ALLOC = 0x2
SHT_NOBITS = 8


def _sext(value, bits):
    return value - (1 << bits) if value & (1 << (bits - 1)) else value


def _flags(word):
    return "".join(f"[{c}]" for c, bit in (("I", 31), ("E", 30), ("M", 29), ("D", 28), ("T", 27)) if (word >> bit) & 1)


def _dest(word):
    field_bits = (word >> 21) & 0xF
    if not field_bits:
        return ""
    return "." + "".join(c for i, c in enumerate("xyzw") if field_bits & (8 >> i))


def _letter(n):
    return "xyzw"[n & 3]


def _target_text(target, labels):
    name = labels[target] if target in labels else f"L_{target:04x}"
    return f"{name} (0x{target:04x})"


def decode_dmatag(lo):
    idn = (lo >> 28) & 7
    return {
        "id": idn,
        "name": DMA_NAMES[idn],
        "qwc": lo & 0xFFFF,
        "pce": (lo >> 26) & 3,
        "irq": (lo >> 31) & 1,
        "addr": (lo >> 32) & 0x7FFFFFFF,
    }


def decode_vifcode(word):
    cmd = (word >> 24) & 0x7F
    num = (word >> 16) & 0xFF
    imm = word & 0xFFFF
    info = {
        "cmd": cmd, "num": num, "imm": imm, "irq": word >> 31,
        "name": VIF_NAMES.get(cmd, "???"), "payload_words": 0,
    }
    name = info["name"]
    if cmd >= 0x60:
        vn, vl = (cmd >> 2) & 3, cmd & 3
        count = num or 256
        bits = (vn + 1) * (32 >> vl)
        info.update(
            name="UNPACK", fmt=f"V{vn + 1}-{UNPACK_BITS[vl]}", count=count, addr=imm & 0x3FF,
            usn=(imm >> 14) & 1, flg=(imm >> 15) & 1, mask=(cmd >> 4) & 1,
            payload_words=-(-count * bits // 32),
        )
    elif name == "MPG":
        info["pairs"] = num or 256
        info["payload_words"] = 2 * info["pairs"]
    elif name in ("DIRECT", "DIRECTHL"):
        info["qwords"] = imm or 65536
    elif name == "STCYCL":
        info.update(cl=imm & 0xFF, wl=(imm >> 8) & 0xFF)
    elif name == "STMASK":
        info["payload_words"] = 1
    elif name in ("STROW", "STCOL"):
        info["payload_words"] = 4
    return info


def _upper_special(idx, word):
    fd, fs, ft = (word >> 6) & 0x1F, (word >> 11) & 0x1F, (word >> 16) & 0x1F
    flags, dest, letter = _flags(word), _dest(word), _letter(idx)
    if idx < 0x10:
        return f"{UPPER_ACC_BC[idx >> 2]}{letter}{flags}{dest} ACC, vf{fs:02d}, vf{ft:02d}{letter}"
    if idx < 0x18:
        return f"{UPPER_CONVERT[idx - 0x10]}{flags}{dest} vf{ft:02d}, vf{fs:02d}"
    if idx < 0x1C:
        return f"mula{letter}{flags}{dest} ACC, vf{fs:02d}, vf{ft:02d}{letter}"
    if idx == 0x1D:
        return f"abs{flags}{dest} vf{ft:02d}, vf{fs:02d}"
    if idx == 0x1F:
        return f"clipw{flags}.xyz vf{fs:02d}, vf{ft:02d}w"
    if idx == 0x2F:
        return f"nop{flags}"
    if idx in UPPER_ACC:
        mnem, src = UPPER_ACC[idx]
        third = src or f"vf{ft:02d}"
        return f"{mnem}{flags}{dest} ACC, vf{fs:02d}, {third}"
    return f"??? 0x{word:08x}"


def decode_upper(word):
    op = word & 0x3F
    fd, fs, ft = (word >> 6) & 0x1F, (word >> 11) & 0x1F, (word >> 16) & 0x1F
    if op >= 0x3C:
        return _upper_special(((word >> 6) & 0x1F) << 2 | (op & 3), word)
    if op < 0x1C:
        letter = _letter(op)
        return (f"{UPPER_BC_BASE[op & 0x1C]}{letter}{_flags(word)}{_dest(word)} "
                f"vf{fd:02d}, vf{fs:02d}, vf{ft:02d}{letter}")
    mnem, src = UPPER_NAMED[op]
    return f"{mnem}{_flags(word)}{_dest(word)} vf{fd:02d}, vf{fs:02d}, {src or f'vf{ft:02d}'}"


def _branch_target(word, vuaddr):
    return vuaddr + 1 + _sext(word & 0x7FF, 11)


def _lower_special(idx, word):
    ft, fs = (word >> 16) & 0x1F, (word >> 11) & 0x1F
    dsuf = _dest(word)
    fsf, ftf = _letter(word >> 21), _letter(word >> 23)
    if idx == 0x30:
        return "nop" if (word >> 11) & 0x3FFF == 0 else f"move{dsuf} vf{ft:02d}, vf{fs:02d}"
    simple = {
        0x31: f"mr32{dsuf} vf{ft:02d}, vf{fs:02d}",
        0x34: f"lqi{dsuf} vf{ft:02d}, (vi{fs:02d}++)",
        0x35: f"sqi{dsuf} vf{fs:02d}, (vi{ft:02d}++)",
        0x36: f"lqd{dsuf} vf{ft:02d}, (--vi{fs:02d})",
        0x37: f"sqd{dsuf} vf{fs:02d}, (--vi{ft:02d})",
        0x38: f"div Q, vf{fs:02d}{fsf}, vf{ft:02d}{ftf}",
        0x39: f"sqrt Q, vf{ft:02d}{ftf}",
        0x3A: f"rsqrt Q, vf{fs:02d}{fsf}, vf{ft:02d}{ftf}",
        0x3B: "waitq",
        0x3C: f"mtir vi{ft:02d}, vf{fs:02d}{fsf}",
        0x3D: f"mfir{dsuf} vf{ft:02d}, vi{fs:02d}",
        0x3E: f"ilwr{dsuf} vi{ft:02d}, (vi{fs:02d})",
        0x3F: f"iswr{dsuf} vi{ft:02d}, (vi{fs:02d})",
        0x40: f"rnext{dsuf} vf{ft:02d}, R",
        0x41: f"rget{dsuf} vf{ft:02d}, R",
        0x42: f"rinit R, vf{fs:02d}{fsf}",
        0x43: f"rxor R, vf{fs:02d}{fsf}",
        0x64: f"mfp{dsuf} vf{ft:02d}, P",
        0x68: f"xtop vi{ft:02d}",
        0x69: f"xitop vi{ft:02d}",
        0x6C: f"xgkick vi{fs:02d}",
        0x7B: "waitp",
    }
    if idx in simple:
        return simple[idx]
    if idx in LOWER_E_OPS:
        src = f"vf{fs:02d}{fsf}" if idx >= 0x78 else f"vf{fs:02d}"
        return f"{LOWER_E_OPS[idx]} P, {src}"
    return f"??? 0x{word:08x}"


def _lower_op(word, vuaddr, labels):
    op = word & 0x3F
    fd, fs, ft = (word >> 6) & 0x1F, (word >> 11) & 0x1F, (word >> 16) & 0x1F
    if op == 0x30:
        return f"iadd vi{fd:02d}, vi{fs:02d}, vi{ft:02d}"
    if op == 0x31:
        return f"isub vi{fd:02d}, vi{fs:02d}, vi{ft:02d}"
    if op == 0x32:
        return f"iaddi vi{ft:02d}, vi{fs:02d}, {_sext(fd, 5)}"
    if op == 0x34:
        return f"iand vi{fd:02d}, vi{fs:02d}, vi{ft:02d}"
    if op == 0x35:
        return f"ior vi{fd:02d}, vi{fs:02d}, vi{ft:02d}"
    if op >= 0x3C:
        return _lower_special((fd << 2) | (op & 3), word)
    return f"??? 0x{word:08x}"


def decode_lower(word, vuaddr, labels):
    top = word >> 25
    if top == 0x40:
        return _lower_op(word, vuaddr, labels)
    ft, fs = (word >> 16) & 0x1F, (word >> 11) & 0x1F
    dsuf = _dest(word)
    s11 = _sext(word & 0x7FF, 11)
    imm24 = word & 0xFFFFFF
    imm12 = (((word >> 21) & 1) << 11) | (word & 0x7FF)
    imm15 = (((word >> 21) & 0xF) << 11) | (word & 0x7FF)
    target = _target_text(_branch_target(word, vuaddr), labels) if top in BRANCH_TOPS else ""
    simple = {
        0x00: f"lq{dsuf} vf{ft:02d}, {s11}(vi{fs:02d})",
        0x01: f"sq{dsuf} vf{fs:02d}, {s11}(vi{ft:02d})",
        0x04: f"ilw{dsuf} vi{ft:02d}, {s11}(vi{fs:02d})",
        0x05: f"isw{dsuf} vi{ft:02d}, {s11}(vi{fs:02d})",
        0x08: f"iaddiu vi{ft:02d}, vi{fs:02d}, {imm15}",
        0x09: f"isubiu vi{ft:02d}, vi{fs:02d}, {imm15}",
        0x10: f"fceq vi01, 0x{imm24:x}",
        0x11: f"fcset 0x{imm24:x}",
        0x12: f"fcand vi01, 0x{imm24:x}",
        0x13: f"fcor vi01, 0x{imm24:x}",
        0x14: f"fseq vi{ft:02d}, 0x{imm12:x}",
        0x15: f"fsset 0x{imm12:x}",
        0x16: f"fsand vi{ft:02d}, 0x{imm12:x}",
        0x17: f"fsor vi{ft:02d}, 0x{imm12:x}",
        0x18: f"fmeq vi{ft:02d}, vi{fs:02d}",
        0x1A: f"fmand vi{ft:02d}, vi{fs:02d}",
        0x1B: f"fmor vi{ft:02d}, vi{fs:02d}",
        0x1C: f"fcget vi{ft:02d}",
        0x20: f"b {target}",
        0x21: f"bal vi{ft:02d}, {target}",
        0x24: f"jr vi{fs:02d}",
        0x25: f"jalr vi{ft:02d}, vi{fs:02d}",
        0x28: f"ibeq vi{ft:02d}, vi{fs:02d}, {target}",
        0x29: f"ibne vi{ft:02d}, vi{fs:02d}, {target}",
        0x2C: f"ibltz vi{fs:02d}, {target}",
        0x2D: f"ibgtz vi{fs:02d}, {target}",
        0x2E: f"iblez vi{fs:02d}, {target}",
        0x2F: f"ibgez vi{fs:02d}, {target}",
    }
    return simple.get(top, f"??? 0x{word:08x}")


def decode_pair(upper, lower, vuaddr, labels):
    up = decode_upper(upper)
    if upper >> 31:
        value = struct.unpack("<f", struct.pack("<I", lower))[0]
        return up, f"loi {value!r} (0x{lower:08x})"
    return up, decode_lower(lower, vuaddr, labels)


def _vif_text(info, vu_names):
    name, imm = info["name"], info["imm"]
    if name == "NOP":
        body = "nop"
    elif name == "STCYCL":
        body = f"stcycl cl={info['cl']} wl={info['wl']}"
    elif name in ("OFFSET", "BASE", "ITOP"):
        body = f"{name.lower()} 0x{imm & 0x3FF:03x}"
    elif name == "STMOD":
        body = f"stmod {imm & 3}"
    elif name == "MSKPATH3":
        body = f"mskpath3 {'on' if imm >> 15 else 'off'}"
    elif name == "MARK":
        body = f"mark 0x{imm:04x}"
    elif name in ("FLUSHE", "FLUSH", "FLUSHA", "MSCNT"):
        body = name.lower()
    elif name in ("MSCAL", "MSCALF"):
        body = f"{name.lower()} {_target_text(imm, vu_names)}"
    elif name == "STMASK":
        body = "stmask (next word is the mask)"
    elif name in ("STROW", "STCOL"):
        body = f"{name.lower()} (next 4 words)"
    elif name == "MPG":
        body = f"mpg pairs={info['pairs']} load=0x{imm:04x}"
    elif name in ("DIRECT", "DIRECTHL"):
        body = f"{name.lower()} qwords={info['qwords']}"
    elif name == "UNPACK":
        flags = "".join(f" {f}" for f, on in (("usn", info["usn"]), ("flg", info["flg"]), ("m", info["mask"])) if on)
        body = f"unpack {info['fmt']} num={info['count']} addr=0x{info['addr']:03x}{flags}"
    else:
        body = f"??? 0x{info['cmd']:02x}"
    return body + (" [irq]" if info["irq"] else "")


def _data_text(kind, info, word):
    text = f"{kind.lower()} data 0x{word:08x}"
    if kind == "UNPACK" and info["fmt"].endswith("-32"):
        text += f" ({struct.unpack('<f', struct.pack('<I', word))[0]!r})"
    return text


def _gif_packed_text(reg, lo, hi):
    if reg == 0xE:
        addr = hi & 0xFF
        return f"GIF A+D {GS_REG_NAMES.get(addr, f'reg_{addr:02x}')} (0x{addr:02x}) = 0x{lo:016x}"
    return f"GIF {GIF_REG_NAMES.get(reg, '?')} = 0x{lo:016x} hi=0x{hi:016x}"


def _gif_items(qwords):
    items = []
    i = 0
    while i < len(qwords):
        ee, lo, hi = qwords[i]
        nloop = lo & 0x7FFF
        flg = (lo >> 58) & 3
        nreg = ((lo >> 60) & 0xF) or 16
        regs = [(hi >> (4 * k)) & 0xF for k in range(nreg)]
        names = ".".join(GIF_REG_NAMES.get(r, f"r{r:x}") for r in regs)
        items.append(("text", ee, (
            f"GIF tag nloop={nloop} eop={(lo >> 15) & 1} pre={(lo >> 46) & 1} "
            f"prim=0x{(lo >> 47) & 0x7FF:03x} flg={GIF_FLG_NAMES[flg]} nreg={nreg} regs={names}")))
        i += 1
        if flg == 0:
            count = nloop * nreg
        elif flg == 1:
            count = nloop * ((nreg + 1) // 2)
        else:
            count = nloop
        if i + count > len(qwords):
            raise ValueError(f"GIF packet at 0x{ee:08x} runs past the DIRECT data")
        for q in range(count):
            ee, lo, hi = qwords[i]
            i += 1
            if flg == 0:
                text = _gif_packed_text(regs[q % nreg], lo, hi)
            elif flg == 1:
                k = 2 * (q % ((nreg + 1) // 2))
                parts = [f"{GIF_REG_NAMES.get(regs[k], '?')}=0x{lo:016x}"]
                if k + 1 < nreg:
                    parts.append(f"{GIF_REG_NAMES.get(regs[k + 1], '?')}=0x{hi:016x}")
                text = "GIF reglist " + " ".join(parts)
            else:
                text = f"GIF data 0x{hi:016x}{lo:016x}"
            items.append(("text", ee, text))
    return items


@dataclass
class Segment:
    ee: int
    load: int
    pairs: int


class _Image:
    def __init__(self, raw, segments):
        self.raw = raw
        self.segments = segments

    def _offset(self, ea, size):
        for vaddr, offset, length in self.segments:
            if vaddr <= ea and ea + size <= vaddr + length:
                return offset + ea - vaddr
        raise ValueError(f"EE address 0x{ea:08x} is not in a loaded segment")

    def u32(self, ea):
        return struct.unpack_from("<I", self.raw, self._offset(ea, 4))[0]

    def u64(self, ea):
        return struct.unpack_from("<Q", self.raw, self._offset(ea, 8))[0]


def _segments_from_sections(raw):
    sys.path.insert(0, str(KAZAROV_PYTHON))
    write_bytecode = sys.dont_write_bytecode
    sys.dont_write_bytecode = True
    try:
        from kazarov_elf import Elf
    finally:
        sys.dont_write_bytecode = write_bytecode
        sys.path.remove(str(KAZAROV_PYTHON))
    elf = Elf(raw)
    return [
        (s.sh_addr, s.sh_offset, s.sh_size) for s in elf.sections
        if s.sh_flags & SHF_ALLOC and s.sh_type != SHT_NOBITS and s.sh_addr and s.sh_size
    ]


def _segments_from_phdrs(raw):
    e_phoff, = struct.unpack_from("<I", raw, 0x1C)
    e_phentsize, e_phnum = struct.unpack_from("<HH", raw, 0x2A)
    segments = []
    for n in range(e_phnum):
        p_type, p_offset, p_vaddr, _, p_filesz = struct.unpack_from("<5I", raw, e_phoff + n * e_phentsize)
        if p_type == PT_LOAD and p_filesz:
            segments.append((p_vaddr, p_offset, p_filesz))
    return segments


def load_image(elf_path):
    raw = Path(elf_path).read_bytes()
    try:
        segments = _segments_from_sections(raw)
        how = "section headers (tools/kazarov/scripts kazarov_elf)"
    except (ImportError, ValueError, IndexError, struct.error):
        segments = []
    if not segments:
        segments = _segments_from_phdrs(raw)
        how = "ELF32 program headers (PT_LOAD)"
    return _Image(raw, segments), how


_SYMBOL_RE = re.compile(r"^(\S+) = 0x([0-9a-fA-F]+);")


def load_symbols(path):
    symbols = []
    for line in Path(path).read_text(encoding="utf-8", errors="replace").splitlines():
        m = _SYMBOL_RE.match(line)
        if m:
            symbols.append((m.group(1), int(m.group(2), 16)))
    return symbols


def _room(name, ee, size, end):
    if ee + size > end:
        raise ValueError(f"{name}: VIF payload at 0x{ee:08x} overruns the DMA data ending 0x{end:08x}")


def _walk_vif(image, name, lo, hi, segments):
    ee = lo
    while ee < hi:
        word = image.u32(ee)
        info = decode_vifcode(word)
        yield ("vif", ee, word, info)
        ee += 4
        kind = info["name"]
        if kind == "MPG":
            _room(name, ee, 8 * info["pairs"], hi)
            seg = Segment(ee, info["imm"], info["pairs"])
            segments.append(seg)
            for k in range(seg.pairs):
                pe = ee + 8 * k
                yield ("pair", pe, seg.load + k, image.u32(pe + 4), image.u32(pe), len(segments) - 1)
            ee += 8 * seg.pairs
        elif kind in ("DIRECT", "DIRECTHL"):
            # The VIF pads with NOPs so the GIF packet starts on a qword.
            while ee % 16:
                word = image.u32(ee)
                yield ("vif", ee, word, decode_vifcode(word))
                ee += 4
            qwords = info["qwords"]
            _room(name, ee, 16 * qwords, hi)
            data = [(ee + 16 * k, image.u64(ee + 16 * k), image.u64(ee + 16 * k + 8)) for k in range(qwords)]
            yield from _gif_items(data)
            ee += 16 * qwords
        elif kind in ("UNPACK", "STMASK", "STROW", "STCOL"):
            _room(name, ee, 4 * info["payload_words"], hi)
            for _ in range(info["payload_words"]):
                yield ("text", ee, _data_text(kind, info, image.u32(ee)))
                ee += 4


def _walk_dma(image, name, start, end, segments, state):
    stack = []
    pos = start
    steps = 0
    state["walked_to"] = start
    while pos < end:
        steps += 1
        if steps > 100000:
            raise ValueError(f"{name}: DMA chain does not terminate")
        tag = decode_dmatag(image.u64(pos))
        kind = tag["name"]
        data_hi = pos + 16 if kind in DMA_DATA_FREE else pos + 16 + 16 * tag["qwc"]
        text = f"DMA {kind} qwc=0x{tag['qwc']:04x} addr=0x{tag['addr']:08x} pce={tag['pce']} irq={tag['irq']}"
        if kind in DMA_DATA_FREE:
            text += " (referenced data, not followed)"
        yield ("text", pos, text)
        yield from _walk_vif(image, name, pos + 8, data_hi, segments)
        state["walked_to"] = data_hi
        if kind in ("cnt", "ref", "refs"):
            pos = data_hi
        elif kind == "next":
            pos = tag["addr"]
        elif kind == "call":
            stack.append(data_hi)
            pos = tag["addr"]
        elif kind == "ret" and stack:
            pos = stack.pop()
        else:
            return


@dataclass
class Listing:
    name: str
    filename: str
    start: int
    end: int
    walked_to: int
    lines: list = field(default_factory=list)
    segments: list = field(default_factory=list)
    unknown: int = 0
    branch_outside: list = field(default_factory=list)
    e_pairs: list = field(default_factory=list)


def _render(name, items, by_ee, segments):
    vu_names = {}
    for item in items:
        if item[0] == "pair" and item[1] in by_ee:
            vu_names.setdefault(item[2], by_ee[item[1]][0])
    # A program spans several MPG blocks and branches cross between them, so "loaded" means any of them.
    loaded = {vu for seg in segments for vu in range(seg.load, seg.load + seg.pairs)}
    lines, branch_outside, e_pairs, unknown = [], [], [], 0
    for item in items:
        ee = item[1]
        lines.extend(f"{n}:" for n in by_ee.get(ee, ()))
        if item[0] == "pair":
            _, _, vu, hi, lo, _ = item
            up, lw = decode_pair(hi, lo, vu, vu_names)
            line = f"{vu:04x}  {hi:08x} {lo:08x}   {up} | {lw}"
            if (hi >> 30) & 1:
                e_pairs.append(vu)
            if not (hi >> 31) and (lo >> 25) in BRANCH_TOPS:
                target = _branch_target(lo, vu)
                if target not in loaded:
                    branch_outside.append((vu, target))
        elif item[0] == "vif":
            line = f"; {ee:08x}  {item[2]:08x} {_vif_text(item[3], vu_names)}"
        else:
            line = f"; {ee:08x}  {item[2]}"
        unknown += line.count("???")
        lines.append(line)
    return lines, unknown, branch_outside, e_pairs


def disassemble(image, name, filename, start, end, by_ee):
    segments = []
    state = {}
    items = list(_walk_dma(image, name, start, end, segments, state))
    walked = state["walked_to"]
    for ee in range(walked, end, 4):
        items.append(("text", ee, f"unwalked word 0x{image.u32(ee):08x}"))
    lines, unknown, branch_outside, e_pairs = _render(name, items, by_ee, segments)
    header = [f"; {name}  EE 0x{start:08x}..0x{end:08x}", ""]
    summary = [
        "",
        f"; summary {name}",
        f"; walked EE 0x{start:08x}..0x{walked:08x}",
    ]
    for n, seg in enumerate(segments):
        summary.append(
            f"; MPG {n}: EE 0x{seg.ee:08x} load 0x{seg.load:04x} pairs {seg.pairs} "
            f"(vu 0x{seg.load:04x}..0x{seg.load + seg.pairs - 1:04x})")
    summary.append(f"; ??? count: {unknown}")
    outside = ", ".join(f"0x{vu:04x}->0x{t:04x}" for vu, t in branch_outside) or "none"
    summary.append(f"; branch targets outside every MPG of the program: {outside}")
    summary.append("; E-bit pairs: " + (", ".join(f"0x{v:04x}" for v in e_pairs) or "none"))
    return Listing(
        name=name, filename=filename, start=start, end=end, walked_to=walked,
        lines=header + lines + summary, segments=segments, unknown=unknown,
        branch_outside=branch_outside, e_pairs=e_pairs,
    )


def build_listings(image, symbols, only=None):
    by_ee = {}
    first = {}
    for sym, addr in symbols:
        by_ee.setdefault(addr, []).append(sym)
        first.setdefault(sym, addr)
    starts = {name: first[name] for name, _ in PROGRAMS}
    order = sorted(PROGRAMS, key=lambda p: starts[p[0]])
    listings = []
    for i, (name, filename) in enumerate(order):
        if only and name not in only and Path(filename).stem not in only:
            continue
        end = PROGRAM_ENDS[name] if name in PROGRAM_ENDS else starts[order[i + 1][0]]
        listings.append(disassemble(image, name, filename, starts[name], end, by_ee))
    return listings


def main(argv=None):
    parser = argparse.ArgumentParser(description="Disassemble the VU1 programs in the retail ELF.")
    parser.add_argument("--elf", type=Path, default=DEFAULT_ELF)
    parser.add_argument("--symbols", type=Path, default=DEFAULT_SYMBOLS)
    parser.add_argument("--out", type=Path, default=DEFAULT_OUT)
    parser.add_argument("--program", help="one program: its symbol name or output stem")
    args = parser.parse_args(argv)

    known = {name for name, _ in PROGRAMS} | {Path(f).stem for _, f in PROGRAMS}
    if args.program and args.program not in known:
        parser.error(f"unknown program {args.program!r}; expected one of {', '.join(sorted(known))}")

    image, how = load_image(args.elf)
    print(f"ELF read via {how}")
    only = {args.program} if args.program else None
    args.out.mkdir(parents=True, exist_ok=True)
    for listing in build_listings(image, load_symbols(args.symbols), only):
        path = args.out / listing.filename
        path.write_text("\n".join(listing.lines) + "\n", encoding="utf-8")
        print(f"{path}: {len(listing.lines)} lines, ??? {listing.unknown}, "
              f"branches outside MPG {len(listing.branch_outside)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
