#!/usr/bin/env python3
import os
import copy
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
CACHE = Path('/tmp/chronicletwo-ee-gcc')
NEWLIB_DIRS = ['libc/include', 'libc/stdio', 'libc/stdlib', 'libc/string',
               'libc/reent', 'libc/locale', 'libc/time', 'libm/common', 'libm/math']
FUNCTION_COMPILERS = {'lib/sce/libmpeg': {'_sysbitNext': 'ee-gcc2.96'}}


def cached_tree(source, name):
    target = CACHE / name
    if target.exists():
        return target
    CACHE.mkdir(parents=True, exist_ok=True)
    temporary = Path(tempfile.mkdtemp(dir=CACHE, prefix=name + '.'))
    shutil.copytree(source, temporary / 'tree')
    try:
        (temporary / 'tree').rename(target)
    except OSError:
        if not target.exists():
            raise
    shutil.rmtree(temporary)
    return target


def rewrite_stubs(text):
    pattern = re.compile(r'asm void (\w+)\(\)\s*\{(.*?)\}', re.S)
    while True:
        match = pattern.search(text)
        if match is None:
            return text
        name, body = match.groups()
        lines = [f'.section .text.{name},\"ax\",@progbits', '.align 3', f'.globl {name}',
                 f'.ent {name}', name + ':', '.set noreorder', '.set nomacro']
        count = len(re.findall(r'\bnop\b', body))
        original_source = os.environ.get('EE_GCC_SOURCE')
        if original_source:
            markers = re.findall(r'INCLUDE_ASM\("([^\"]+)",\s*(\w+)\)', Path(original_source).read_text())
            for folder, symbol in markers:
                if symbol == name.removeprefix('mwccgap_'):
                    assembly = (ROOT / folder / (symbol + '.s')).read_text()
                    count = len(re.findall(r'/\*\s*[0-9A-Fa-f]+\s+[0-9A-Fa-f]{8}\s+[0-9A-Fa-f]{8}\s*\*/', assembly))
                    break
        for unused in range(count):
            lines.append('nop')
        lines.extend([f'.end {name}', '.set macro', '.set reorder'])
        escaped = '\\n\\t'.join(lines).replace('"', '\\"')
        replacement = '__asm__("' + escaped + '");'
        text = text[:match.start()] + replacement + text[match.end():]


def rename_text_sections(path):
    prefix = os.environ.get('MIPS_TOOL_PREFIX', 'mips-ps2-decompals-')
    result = subprocess.run([prefix + 'objdump', '-h', str(path)],
                            check=True, capture_output=True, text=True)
    names = re.findall(r'^\s*\d+\s+(\.(?:text|data|rodata|bss)\.\S+)', result.stdout, re.M)
    if not names:
        return
    args = [prefix + 'objcopy']
    for base in ['text', 'data', 'rodata', 'bss']:
        if re.search(r'^\s*\d+\s+\.' + base + r'\s+0{8}', result.stdout, re.M):
            args.extend(['--rename-section', '.' + base + '=.gcc_empty_' + base])
    for name in names:
        args.extend(['--rename-section', name + '=' + '.' + name.split('.')[1]])
    subprocess.run(args + [str(path)], check=True)


def replace_function(path, replacement_path, name):
    sys.path.insert(0, str(ROOT / 'tools/mwccgap'))
    from mwccgap.elf import Elf

    target = Elf(path.read_bytes())
    replacement = Elf(replacement_path.read_bytes())
    unused, target_symbol = target.symtab.get_symbol_by_name(name)
    unused, replacement_symbol = replacement.symtab.get_symbol_by_name(name)
    if target_symbol is None or replacement_symbol is None:
        raise ValueError('Missing compiler override function ' + name)
    target_index = target_symbol.st_shndx
    replacement_index = replacement_symbol.st_shndx
    if not (0 < target_index < len(target.sections)
            and 0 < replacement_index < len(replacement.sections)):
        raise ValueError('Compiler override function has no section: ' + name)
    target_section = target.sections[target_index]
    replacement_section = replacement.sections[replacement_index]
    if not (target_section.sh_flags & 4 and replacement_section.sh_flags & 4):
        raise ValueError('Compiler override function is not executable: ' + name)
    target_section.data = replacement_section.data
    target_section.sh_size = len(replacement_section.data)
    target_section.sh_addralign = replacement_section.sh_addralign
    target_symbol.st_value = replacement_symbol.st_value
    target_symbol.st_size = replacement_symbol.st_size
    target_symbol.bind = replacement_symbol.bind
    target_symbol.type = replacement_symbol.type
    target_symbol.st_other = replacement_symbol.st_other
    references = {}
    for record in target.get_relocations():
        if record.sh_info == target_index:
            record.relocations = []
        for relocation in record.relocations:
            references[id(relocation)] = target.symtab.symbols[relocation.symbol_index]
    for source_record in replacement.get_relocations():
        if source_record.sh_info != replacement_index:
            continue
        record = copy.deepcopy(source_record)
        record.sh_name = target.add_sh_symbol(source_record.name)
        record.sh_info = target_index
        record.sh_link = target.symtab_index
        for relocation in record.relocations:
            symbol = replacement.symtab.symbols[relocation.symbol_index]
            if symbol.type == 3 and symbol.st_shndx == replacement_index:
                matches = [entry for entry in target.symtab.symbols
                           if entry.type == 3 and entry.st_shndx == target_index]
                existing = matches[0] if matches else None
            else:
                unused, existing = target.symtab.get_symbol_by_name(symbol.name)
            if existing is None:
                entry = copy.copy(symbol)
                if entry.st_shndx == replacement_index:
                    entry.st_shndx = target_index
                elif entry.st_shndx not in (0, 0xFFF1):
                    raise ValueError('Compiler override has an unsupported dependency: '
                                     + name + ' -> ' + symbol.name)
                index = target.add_symbol(entry, force=not entry.name)
                existing = target.symtab.symbols[index]
            references[id(relocation)] = existing
        target.add_section(record)
    indices = {}
    for index, symbol in enumerate(target.symtab.symbols):
        indices[id(symbol)] = index
    for record in target.get_relocations():
        for relocation in record.relocations:
            relocation.symbol_index = indices[id(references[id(relocation)])]
    path.write_bytes(target.pack())


def compile_object(source, output, version, flags, includes, directory, assembly=False):
    compiler = cached_tree(ROOT / 'tools/compilers' / version, version)
    libraries = sorted((compiler / 'lib/gcc-lib/ee').glob('*'))
    args = [str(compiler / 'bin/ee-gcc'), '-B' + str(libraries[0]) + '/',
            '-B' + str(compiler / 'ee/bin') + '/', '-x', 'c',
            '-ffunction-sections', '-fdata-sections', '-fno-common']
    compiler_output = output.with_suffix('.s') if assembly else output
    args.extend(flags + includes + ['-S' if assembly else '-c', '-o',
                                   str(compiler_output), str(source)])
    result = subprocess.run(args, cwd=directory, capture_output=True, text=True)
    sys.stderr.write(result.stdout + result.stderr)
    if assembly and not result.returncode:
        prefix = os.environ.get('MIPS_TOOL_PREFIX', 'mips-ps2-decompals-')
        result = subprocess.run([prefix + 'as', '-EL', '-march=r5900', '-mabi=eabi',
                                 '-G0', '-o', str(output), str(compiler_output)],
                                cwd=directory, capture_output=True, text=True)
        sys.stderr.write(result.stdout + result.stderr)
    return result.returncode


def compile_source(arguments):
    output = None
    source = None
    flags = []
    index = 0
    while index < len(arguments):
        value = arguments[index]
        if value == '-o':
            output = Path(arguments[index + 1]).resolve()
            index += 2
            continue
        if value == '-c':
            index += 1
            continue
        if value.startswith('-'):
            flags.append(value)
        else:
            source = Path(value).resolve()
        index += 1
    if output is None or source is None:
        raise ValueError('Expected -o OBJECT SOURCE')
    version = os.environ.get('EE_GCC', 'ee-gcc2.9-991111-01')
    newlib = cached_tree(ROOT / 'tools/newlib/newlib-1_9_0', 'newlib-1_9_0')
    original_source = Path(os.environ.get('EE_GCC_SOURCE', source)).resolve()
    try:
        unit = original_source.relative_to(ROOT / 'ps2/src').with_suffix('').as_posix()
    except ValueError:
        unit = ''
    overrides = FUNCTION_COMPILERS.get(unit, {})
    with tempfile.TemporaryDirectory() as directory:
        temporary = Path(directory)
        shutil.copytree(ROOT / 'ps2/include/gcc', temporary / 'include')
        copied_source = temporary / source.name
        copied_source.write_text(rewrite_stubs(source.read_text()))
        object_path = temporary / 'output.o'
        includes = ['-I' + str(temporary / 'include')]
        for name in NEWLIB_DIRS:
            includes.append('-I' + str(newlib / name))
        includes.extend(['-I' + str(ROOT / 'ps2/include'), '-I' + str(ROOT / 'ps2/include/sce')])
        result = compile_object(copied_source, object_path, version, flags, includes, temporary)
        if result:
            return result
        for override_version in sorted(set(overrides.values())):
            if override_version == version:
                continue
            replacement_path = temporary / (override_version + '.o')
            result = compile_object(copied_source, replacement_path, override_version,
                                    flags, includes, temporary, assembly=True)
            if result:
                return result
            for name, function_version in overrides.items():
                if function_version == override_version:
                    replace_function(object_path, replacement_path, name)
        rename_text_sections(object_path)
        shutil.copyfile(object_path, output)
    return 0


if __name__ == '__main__':
    sys.exit(compile_source(sys.argv[1:]))
