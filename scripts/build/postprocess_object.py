#!/usr/bin/env python3
"""Normalize native object identities and verified layout for the retail link.

    postprocess_object.py OBJECT [--order-only]

MWCC emits one section per function or datum. Retail addresses select each
section's name, flags, alignment and order. Placeholder aliases identify the
assembly-supplied pieces; binding a native copy to one preserves instruction
fields and requires consistent references, equal declared object extents and
resolved initialized bytes plus real relocation shapes, or NOBITS storage.

Native identity passes use their required extent, section-kind, byte,
relocation and consumer evidence. Source-family gates apply to selected named
passes; anonymous BSS and pointer-table naming use references and content.
Local duplicate suffixes are resolved within the owning unit. Exact native
objects may retain verified zero initialized padding and BSS alignment gaps or
explicitly listed unresolved retail reservations. Independently cut alignment fragments require both neighboring
objects' original extents and compiler alignments, with complete zero contents.

External weak functions use retail ownership; unverified bodies are reported.
Vtable discards require complete original declared extents, bytes and relocations.
Duplicate global symbols are folded into live definitions; unused literals and
dead compiler records are removed without changing code. Canonical object and
final PAL verification remain the acceptance checks for every normalized object.
"""

import argparse
import bisect
import re
import struct
import sys
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools" / "mwccgap"))
sys.path.insert(0, str(Path(__file__).resolve().parent))

from mwccgap.elf import Elf, Symbol, Section, RelocationRecord, SHT_NOBITS, BssSection  # noqa: E402

import layout  # noqa: E402
import disassemble

SHT_PROGBITS = 1
SHF_WRITE = 0x1
SHF_ALLOC = 0x2
SHF_EXECINSTR = 0x4
SHF_MIPS_GPREL = 0x10000000

STT_SECTION = 3
STT_OBJECT = 1
STT_FUNC = 2
STB_MWCC_COALESCED = 13
STB_LOCAL = 0
STB_WEAK = 2

R_MIPS_32 = 2
R_MIPS_26 = 4
R_MIPS_HI16 = 5
R_MIPS_LO16 = 6
R_MIPS_GPREL16 = 7

DEAD = ".dead"

# The least alignment retail gives a compiler-generated literal of `.rodata`.
RODATA_ALIGNMENT = 8

# Shared cap for the address-derived bounds on retail data padding.
MAX_DATA_ALIGNMENT = 128

FLAGS = {
    ".text": SHF_ALLOC | SHF_EXECINSTR,
    ".init": SHF_ALLOC | SHF_EXECINSTR,
    ".data": SHF_WRITE | SHF_ALLOC,
    ".rodata": SHF_ALLOC,
    ".ctor": SHF_WRITE | SHF_ALLOC,
    ".vtables": SHF_WRITE | SHF_ALLOC,
    ".sdata": SHF_WRITE | SHF_ALLOC | SHF_MIPS_GPREL,
    ".sbss": SHF_WRITE | SHF_ALLOC | SHF_MIPS_GPREL,
    ".bss": SHF_WRITE | SHF_ALLOC,
}
CODE = (".text", ".init")


# Unresolved retail storage: exact placements only, never inferred alignments.
# Values fix (kind, start, size, next name/start/size, measured next alignments).
# None permits only a retained following marker, absent or placeholder-backed.
# See BSS_RESERVATIONS.md for the measured classification and remaining gaps.
BSS_RETAIL_RESERVATIONS = {
    ('convviewlp', 'ConvertResultDispTime'):
        ('.sbss', 0x0037ea8c, 0x4, 'SaveFileInfoTablePtr', 0x0037eac0, 0x4, (4,)),
    ('convviewlp', 'init_817'):
        ('.sbss', 0x0037eac8, 0x1, 'init_820', 0x0037eacc, 0x1, (1,)),
    ('convviewlp', 'init_820'):
        ('.sbss', 0x0037eacc, 0x1, 'init_823', 0x0037ead0, 0x1, (1,)),
    ('convviewlp', 'init_823'):
        ('.sbss', 0x0037ead0, 0x1, 'init_826', 0x0037ead4, 0x1, (1,)),
    ('dng_main', 'init_1107'):
        ('.sbss', 0x0037d470, 0x1, 'init_1824', 0x0037d474, 0x1, (1,)),
    ('dngmenu', 'dngfloor_infoview'):
        ('.sbss', 0x0037d52c, 0x1, 'dngfloor_backdraw', 0x0037d530, 0x1, (1,)),
    ('dngmenu', 'DngInfoFishOkFlag'):
        ('.sbss', 0x0037d53c, 0x1, 'DngInfoSphidaOkFlag', 0x0037d540, 0x1, (1,)),
    ('dngmenu', 'DngInfoSphidaOkFlag'):
        ('.sbss', 0x0037d540, 0x1, 'DngAskMessageDrawFlag', 0x0037d544, 0x1, (1,)),
    ('dngmenu', 'init_1744'):
        ('.sbss', 0x0037d564, 0x1, 'GeoramaMateriaInfoDrawFlag', 0x0037d568, 0x1, (1,)),
    ('dngmenu', 'GeoramaMateriaInfoDrawFlag'):
        ('.sbss', 0x0037d568, 0x1, 'GeoramaMateriaInfoDrawPage', 0x0037d56c, 0x1, (1,)),
    ('dngmenu', 'GeoramaMateriaInfoDrawPage'):
        ('.sbss', 0x0037d56c, 0x1, 'GeoramaMateriaNum', 0x0037d570, 0x2, (2,)),
    ('dngmenu', 'DngTreeMode'):
        ('.sbss', 0x0037d57c, 0x2, 'TreeMapSaveFlag', 0x0037d580, 0x1, (1,)),
    ('dngmenu', 'TreeMapSaveFlag'):
        ('.sbss', 0x0037d580, 0x1, 'TreeMapSaveNum', 0x0037d584, 0x2, (2,)),
    ('dngmenu', 'TreeMapSaveNum'):
        ('.sbss', 0x0037d584, 0x2, 'TreeMapSaveDispCount', 0x0037d588, 0x2, (2,)),
    ('dngmenu', 'TreeMapSaveDispY'):
        ('.sbss', 0x0037d590, 0x2, 'TreeMapCallDungeonSubMap', 0x0037d594, 0x1, (1,)),
    ('dngmenu', 'TreeMapCallDungeonSubMap'):
        ('.sbss', 0x0037d594, 0x1, 'TreeMapCalledWorldMap', 0x0037d598, 0x1, (1,)),
    ('editmenu', 'HouseInfoSelectLine'):
        ('.sbss', 0x0037d5e4, 0x2, 'HouseInfoSelectSelect', 0x0037d5e8, 0x2, (2,)),
    ('editmenu', 'HouseInfoSelectSelect'):
        ('.sbss', 0x0037d5e8, 0x2, 'HouseInfoSelectMoveInit', 0x0037d5ec, 0x1, (1,)),
    ('editmenu', 'DownLoadInfoEndFlag'):
        ('.sbss', 0x0037d60c, 0x1, 'DownLoadInfoDrawFlag', 0x0037d610, 0x1, (1,)),
    ('editmenu', 'DownLoadDispNum'):
        ('.sbss', 0x0037d620, 0x2, 'DownLoadProgress', 0x0037d624, 0x2, (2,)),
    ('editmenu', 'DownLoadProgress'):
        ('.sbss', 0x0037d624, 0x2, 'DownLoadMesMakeProgress', 0x0037d628, 0x1, (1,)),
    ('editmenu', 'DownLoadMesUpY'):
        ('.sbss', 0x0037d638, 0x2, 'old_menuparts_pos_flag', 0x0037d63c, 0x1, (1,)),
    ('editmenu', 'old_menuparts_pos_flag'):
        ('.sbss', 0x0037d63c, 0x1, 'NowPolyGonFormMoveFlag', 0x0037d640, 0x1, (1,)),
    ('editmenu', 'MenuGeoramaCursorForceSetFlag'):
        ('.sbss', 0x0037d64c, 0x1, 'MenuGeoStoneDonwLoadFlag', 0x0037d650, 0x1, (1,)),
    ('editmenu', 'MenuGeoStoneDonwLoadFlag'):
        ('.sbss', 0x0037d650, 0x1, 'MenuGeoStoneDownLoad_PartsNum', 0x0037d654, 0x2, (2,)),
    ('editmenu', 'MenuGeoStoneDownLoad_PartsNum'):
        ('.sbss', 0x0037d654, 0x2, 'MenuGeoStoneDownLoad_Request', 0x0037d658, 0x2, (2,)),
    ('editmenu', 'GeoramaParts_DrawWaitCnt'):
        ('.sbss', 0x0037d6a4, 0x2, 'GeoramaMesPosForceSetFlag', 0x0037d6a8, 0x1, (1,)),
    ('editmenu', 'GeoramaMesMakeManner'):
        ('.sbss', 0x0037d6b0, 0x5, 'GeoramaReqMakeLine', 0x0037d6b8, 0x2, (2,)),
    ('editmenu', 'GeoramaReqMakeLine'):
        ('.sbss', 0x0037d6b8, 0x2, 'GeoramaReqMakeManner', 0x0037d6bc, 0x2, (2,)),
    ('editmenu', 'GeoramaReqMakeManner'):
        ('.sbss', 0x0037d6bc, 0x2, 'GeoramaMesForceMakeFlag', 0x0037d6c0, 0x1, (1,)),
    ('editmenu', 'GeoramaMesForceMakeFlag'):
        ('.sbss', 0x0037d6c0, 0x1, 'GeoramaMesForceMakeFlag_PaintVer', 0x0037d6c4, 0x1, (1,)),
    ('editmenu', 'cnt_2177'):
        ('.sbss', 0x0037d6f0, 0x1, 'init_2178', 0x0037d6f4, 0x1, (1,)),
    ('editmenu', 'init_3581'):
        ('.sbss', 0x0037d71c, 0x1, 'DestroyMaxNum_3584', 0x0037d720, 0x2, (2,)),
    ('editmenu', 'DestroyMaxNum_3584'):
        ('.sbss', 0x0037d720, 0x2, 'init_3585', 0x0037d724, 0x1, (1,)),
    ('funcpoint', 'init_1175'):
        ('.sbss', 0x0037dfc8, 0x1, 'init_1204', 0x0037dfcc, 0x1, (1,)),
    ('funcpoint', 'init_1204'):
        ('.sbss', 0x0037dfcc, 0x1, 'init_1208', 0x0037dfd0, 0x1, (1,)),
    ('gamepad', 'rpad_256'):
        ('.sbss', 0x0037cf30, 0x2, 'init_257', 0x0037cf34, 0x1, (1,)),
    ('inventmn', 'pic_name_info_num'):
        ('.sbss', 0x0037d778, 0x2, 'pic_name_info_num_count', 0x0037d77c, 0x2, (2,)),
    ('inventmn', 'InventInNetaEffectFlag'):
        ('.sbss', 0x0037d7e8, 0x1, 'InventInNetaEffectNum', 0x0037d7ec, 0x1, (1,)),
    ('inventmn', 'InventInNetaEffectNum'):
        ('.sbss', 0x0037d7ec, 0x1, 'InventInNetaEffectNum4', 0x0037d7f0, 0x2, (2,)),
    ('inventmn', 'ActiveSlot_3949'):
        ('.sbss', 0x0037d7f8, 0x1, 'init_3950', 0x0037d7fc, 0x1, (1,)),
    ('mainloop', 'init_1225'):
        ('.sbss', 0x0037d18c, 0x1, 'init_1228', 0x0037d190, 0x1, (1,)),
    ('mainloop', 'init_1228'):
        ('.sbss', 0x0037d190, 0x1, 'init_1231', 0x0037d194, 0x1, (1,)),
    ('mainloop', 'init_1231'):
        ('.sbss', 0x0037d194, 0x1, 'init_1234', 0x0037d198, 0x1, (1,)),
    ('map', 'init_1249'):
        ('.sbss', 0x0037cf88, 0x1, 'init_1301', 0x0037cf8c, 0x1, (1,)),
    ('menuaqua', 'menu_debug_select'):
        ('.sbss', 0x0037d860, 0x2, 'aquarium_xz_table', 0x0037d870, 0x4, (4,)),
    ('menuaqua', 'aquarium_xz_table'):
        ('.sbss', 0x0037d870, 0x4, 'aquarium_y_table', 0x0037d880, 0x4, (4,)),
    ('menuaqua', 'init_3639'):
        ('.sbss', 0x0037d8ac, 0x1, 'sel_sift_fish_select_3641', 0x0037d8b0, 0x2, (2,)),
    ('menuaqua', 'GyoraceFishSelectMode'):
        ('.sbss', 0x0037d8bc, 0x1, 'GyoraceFishSelectNo', 0x0037d8c0, 0x2, (2,)),
    ('menuaqua', 'GyoraceFishSelectNo'):
        ('.sbss', 0x0037d8c0, 0x2, 'GyoraceFishSelTexBk', 0x0037d8c4, 0x2, (2,)),
    ('menuaqua', 'GyoraceFishSelTexBk'):
        ('.sbss', 0x0037d8c4, 0x2, 'GyoraceFishFrameImgTexNo', 0x0037d8c8, 0x2, (2,)),
    ('menuaqua', 'GyoraceFishFrameImgTexNo'):
        ('.sbss', 0x0037d8c8, 0x2, 'GyoraceFishSelNum', 0x0037d8cc, 0x1, (1,)),
    ('menuaqua', 'GyoraceFishSel'):
        ('.sbss', 0x0037d8d0, 0x6, 'GyoRaceFishReadPhase', 0x0037d8d8, 0x1, (1,)),
    ('menuaqua', 'GyoRaceFishReadPhase'):
        ('.sbss', 0x0037d8d8, 0x1, 'GyoRaceAquariumNo', 0x0037d8dc, 0x1, (1,)),
    ('menuaqua', 'GyoRaceAquariumNo'):
        ('.sbss', 0x0037d8dc, 0x1, 'GyoRaceClass', 0x0037d8e0, 0x1, (1,)),
    ('menuaqua', 'GyoRaceClass'):
        ('.sbss', 0x0037d8e0, 0x1, 'GyoRaceProgressNum', 0x0037d8e4, 0x1, (1,)),
    ('menuaqua', 'GyoRaceProgressNum'):
        ('.sbss', 0x0037d8e4, 0x1, 'GyoRaceRankingData', 0x0037d8e8, 0x1, (1,)),
    ('menuaqua', 'spi_nowanalyze_gyorace_limmit'):
        ('.sbss', 0x0037d8f8, 0x2, 'spi_gyorace_counter', 0x0037d8fc, 0x2, (2,)),
    ('menuaqua', 'FishTournamentGoodsNum'):
        ('.sbss', 0x0037d908, 0x2, 'FishTournamentGoodsType', 0x0037d90c, 0x1, (1,)),
    ('menuaqua', 'GyoraceMesDrawFlag'):
        ('.sbss', 0x0037d92c, 0x1, 'GyoraceFishInfoDrawFlag', 0x0037d930, 0x1, (1,)),
    ('menuaqua', 'GyoraceNowMode'):
        ('.sbss', 0x0037d958, 0x2, 'GyoraceNowPhase', 0x0037d95c, 0x2, (2,)),
    ('menuaqua', 'GyoraceNowPhase'):
        ('.sbss', 0x0037d95c, 0x2, 'GyoraceQuestionMsgDrawFlag', 0x0037d960, 0x1, (1,)),
    ('menuaqua', 'GyoraceQuestionMsgDrawFlag'):
        ('.sbss', 0x0037d960, 0x1, 'GyoraceHaveFishCursorDrawFlag', 0x0037d964, 0x1, (1,)),
    ('menuaqua', 'init_5178'):
        ('.sbss', 0x0037d9ac, 0x1, 'save_now_space_racer_no_5180', 0x0037d9b0, 0x1, (1,)),
    ('menuaqua', 'save_now_space_racer_no_5180'):
        ('.sbss', 0x0037d9b0, 0x1, 'init_5181', 0x0037d9b4, 0x1, (1,)),
    ('menuchr', 'menu_debug_npcselect'):
        ('.sbss', 0x0037e234, 0x1, 'menu_debug_npc_decide', 0x0037e238, 0x1, (1,)),
    ('menuchr', 'menu_debug_npc_decide'):
        ('.sbss', 0x0037e238, 0x1, 'MenuDebugChangeSelectMode', 0x0037e23c, 0x2, (2,)),
    ('menuchr', 'MenuDebugChangeSelectMode'):
        ('.sbss', 0x0037e23c, 0x2, 'MenuDebugCharaChangeSelect', 0x0037e240, 0x2, (2,)),
    ('menuchr', 'MenuDebugCharaChangeSelect'):
        ('.sbss', 0x0037e240, 0x2, 'SelectedCmdNo_1415', 0x0037e244, 0x1, (1,)),
    ('menuchr', 'SelectedCmdNo_1415'):
        ('.sbss', 0x0037e244, 0x1, 'init_1416', 0x0037e248, 0x1, (1,)),
    ('menuchr', 'NowMainCharaChngStatusBit'):
        ('.sbss', 0x0037e2c0, 0x2, 'MenuNPCLoadFlag', 0x0037e2c4, 0x1, (1,)),
    ('menucommon', 'MenuTexPosNo'):
        ('.sbss', 0x0037de3c, 0x2, 'MenuTexPosNo_local', 0x0037de40, 0x2, (2,)),
    ('menucommon', 'MenuTexPosNo_local'):
        ('.sbss', 0x0037de40, 0x2, 'menu_analyze_texblock', 0x0037de44, 0x2, (2,)),
    ('menucommon', 'Menu_Target_No'):
        ('.sbss', 0x0037de4c, 0x2, 'Menu_Target_No_local', 0x0037de50, 0x2, (2,)),
    ('menucommon', 'menu_analyze_formno'):
        ('.sbss', 0x0037de60, 0x2, 'menu_analyze_formno_offset', 0x0037de64, 0x2, (2,)),
    ('menudraw', 'MenuMainFrame_ActionEndFlag'):
        ('.sbss', 0x0037da50, 0x1, 'MenuMainFrame_Display_Mode', 0x0037da54, 0x2, (2,)),
    ('menudraw', 'MainFrameStepFlag_2092'):
        ('.sbss', 0x0037da80, 0x1, 'init_2093', 0x0037da84, 0x1, (1,)),
    ('menudraw', 'fish_boiled_count'):
        ('.sbss', 0x0037db34, 0x2, 'fish_boiled_runflag', 0x0037db38, 0x2, (2,)),
    ('menumain', 'MenuNowMapNo'):
        ('.sbss', 0x0037db60, 0x2, 'MenuNowMapType', 0x0037db64, 0x2, (2,)),
    ('menumain', 'HatumeiMenuOkFlag'):
        ('.sbss', 0x0037dbc8, 0x1, 'WorldMapOkFlag', 0x0037dbcc, 0x1, (1,)),
    ('menumain', 'WorldMapOkFlag'):
        ('.sbss', 0x0037dbcc, 0x1, 'ManualMenuOkFlag', 0x0037dbd0, 0x1, (1,)),
    ('menumain', 'ManualMenuOkFlag'):
        ('.sbss', 0x0037dbd0, 0x1, 'DngMoveMenuOkFlag', 0x0037dbd4, 0x1, (1,)),
    ('menumain', 'DngMoveMenuOkFlag'):
        ('.sbss', 0x0037dbd4, 0x1, 'MenuDoubleDrawCheck', 0x0037dbd8, 0x1, (1,)),
    ('menumain', 'MenuDoubleDrawCheck'):
        ('.sbss', 0x0037dbd8, 0x1, 'refresh_cnt_1523', 0x0037dbdc, 0x1, (1,)),
    ('menumain', 'refresh_cnt_1523'):
        ('.sbss', 0x0037dbdc, 0x1, 'init_1524', 0x0037dbe0, 0x1, (1,)),
    ('menumain', 'MenuTopicType'):
        ('.sbss', 0x0037dbf8, 0x2, 'MenuTopicLength', 0x0037dbfc, 0x2, (2,)),
    ('menumap', 'MapEnableNum'):
        ('.sbss', 0x0037e188, 0x2, 'WorldMapMenuType', 0x0037e18c, 0x1, (1,)),
    ('menumap', 'WorldMapMenuType'):
        ('.sbss', 0x0037e18c, 0x1, 'WorldMap_NextLoopNo', 0x0037e190, 0x2, (2,)),
    ('menumap', 'WorldMap_NextLoopNo'):
        ('.sbss', 0x0037e190, 0x2, 'WorldMap_MapNo', 0x0037e194, 0x2, (2,)),
    ('menumap', 'WorldMap_MapNo'):
        ('.sbss', 0x0037e194, 0x2, 'WorldMap_DngFloor', 0x0037e198, 0x2, (2,)),
    ('menumap', 'SphidaMenuPhase'):
        ('.sbss', 0x0037e1f8, 0x2, 'SfidaMakeLine', 0x0037e1fc, 0x2, (2,)),
    ('menumap', 'SfidaMakeLine'):
        ('.sbss', 0x0037e1fc, 0x2, 'SfidaMoveInitFlag', 0x0037e200, 0x1, (1,)),
    ('menuop', 'MenuReturnMsgDrawFlag'):
        ('.sbss', 0x0037e308, 0x1, 'MovieBattleBGMPhase', 0x0037e30c, 0x1, (1,)),
    ('menuop', 'Movie_DungeonFlag'):
        ('.sbss', 0x0037e318, 0x2, 'Movie_BossFlag', 0x0037e31c, 0x2, (2,)),
    ('menuop', 'Movie_BossFlag'):
        ('.sbss', 0x0037e31c, 0x2, 'MovieBgmBattleCheckStopFlag', 0x0037e320, 0x2, (2,)),
    ('menuop', 'MovieViewFlag'):
        ('.sbss', 0x0037e328, 0x1, 'ManualMovieFadeCount_1253', 0x0037e32c, 0x2, (2,)),
    ('menuop', 'ManualMovieFadeCount_1253'):
        ('.sbss', 0x0037e32c, 0x2, 'init_1254', 0x0037e330, 0x1, (1,)),
    ('menuop', 'init_2005'):
        ('.sbss', 0x0037e380, 0x1, 'input_wait_counter_2067', 0x0037e384, 0x1, (1,)),
    ('menuop', 'input_wait_counter_2067'):
        ('.sbss', 0x0037e384, 0x1, 'init_2068', 0x0037e388, 0x1, (1,)),
    ('menuop', 'init_2550'):
        ('.sbss', 0x0037e3c0, 0x1, 'MenuMapInfoSave_DngNo', 0x0037e3c4, 0x2, (2,)),
    ('menuop', 'MenuMapInfoSave_DngNo'):
        ('.sbss', 0x0037e3c4, 0x2, 'SubGameSaveOrLoad', 0x0037e3c8, 0x1, (1,)),
    ('menuop', 'SubGameSaveOrLoad'):
        ('.sbss', 0x0037e3c8, 0x1, 'SubGameSaveOrLoadPhase', 0x0037e3cc, 0x2, (2,)),
    ('menuop', 'SubGameSaveOrLoadPhase'):
        ('.sbss', 0x0037e3cc, 0x2, 'SubGameSaveLoadStatus', 0x0037e3d0, 0x2, (2,)),
    ('menuop', 'SubGameSaveLoadStatus'):
        ('.sbss', 0x0037e3d0, 0x2, 'SubGameMCPort', 0x0037e3d4, 0x1, (1,)),
    ('menushop', 'shop_mode_prev_1326'):
        ('.sbss', 0x0037def4, 0x2, 'init_1327', 0x0037def8, 0x1, (1,)),
    ('menushop', 'QuestViewCommentFlag'):
        ('.sbss', 0x0037df60, 0x1, 'QuestReactionCommentGyouNum', 0x0037df64, 0x2, (2,)),
    ('menusys', 'MenuItem_ItemBoardTopLine'):
        ('.sbss', 0x0037dc20, 0x2, 'MenuItem_ItemBoardTopSelect', 0x0037dc24, 0x2, (2,)),
    ('menusys', 'MenuItemCmdArgPos'):
        ('.sbss', 0x0037dc84, 0x2, 'MenuItemCommand_RoboPackBreakFlag', 0x0037dc88, 0x2, (2,)),
    ('menusys', 'MenuItemCommand_RoboPackBreakFlag'):
        ('.sbss', 0x0037dc88, 0x2, 'cmd_counter_1048', 0x0037dc8c, 0x1, (1,)),
    ('menusys', 'cmd_counter_1048'):
        ('.sbss', 0x0037dc8c, 0x1, 'init_1049', 0x0037dc90, 0x1, (1,)),
    ('menusys', 'SpectolBreakNum_Limit'):
        ('.sbss', 0x0037dca4, 0x2, 'SpectolBreakNum', 0x0037dca8, 0x2, (2,)),
    ('menusys', 'SpectolBreakNum'):
        ('.sbss', 0x0037dca8, 0x2, 'SpectolBreakSpPoint', 0x0037dcac, 0x2, (2,)),
    ('menusys', 'MenuSpectolTransPos'):
        ('.sbss', 0x0037dcc0, 0x2, 'itemmenu_chr_rotflag', 0x0037dcc4, 0x1, (1,)),
    ('menusys', 'itemmenu_chr_rotflag'):
        ('.sbss', 0x0037dcc4, 0x1, 'sndflag_1665', 0x0037dcc8, 0x1, (1,)),
    ('menusys', 'sndflag_1665'):
        ('.sbss', 0x0037dcc8, 0x1, 'init_1666', 0x0037dccc, 0x1, (1,)),
    ('menusys', 'count_time_3839'):
        ('.sbss', 0x0037dd08, 0x1, 'init_3840', 0x0037dd0c, 0x1, (1,)),
    ('menusys', 'init_4683'):
        ('.sbss', 0x0037dd3c, 0x1, 'BuildEndFlag_4703', 0x0037dd40, 0x1, (1,)),
    ('menusys', 'BuildEndFlag_4703'):
        ('.sbss', 0x0037dd40, 0x1, 'init_4704', 0x0037dd44, 0x1, (1,)),
    ('menusys', 'checkmoveFlag_5411'):
        ('.sbss', 0x0037dd58, 0x1, 'init_5412', 0x0037dd5c, 0x1, (1,)),
    ('menusys', 'MenuDebugCamera'):
        ('.sbss', 0x0037dd88, 0x4, 'at_6133', 0x0037dd90, 0x8, (None,)),
    ('menusys', 'init_6162'):
        ('.sbss', 0x0037dd9c, 0x1, 'at_6176', 0x0037dda0, 0x8, (None,)),
    ('menusys', 'fusion_blinkcnt_7120'):
        ('.sbss', 0x0037ddd8, 0x1, 'init_7121', 0x0037dddc, 0x1, (1,)),
    ('menusys', 'init_7121'):
        ('.sbss', 0x0037dddc, 0x1, 'diffent_weapon_dispflag_7125', 0x0037dde0, 0x1, (1,)),
    ('menusys', 'diffent_weapon_dispflag_7125'):
        ('.sbss', 0x0037dde0, 0x1, 'init_7126', 0x0037dde4, 0x1, (1,)),
    ('menusys', 'init_7510'):
        ('.sbss', 0x0037ddf0, 0x1, 'count_7867', 0x0037ddf4, 0x1, (1,)),
    ('menusys', 'count_7867'):
        ('.sbss', 0x0037ddf4, 0x1, 'init_7868', 0x0037ddf8, 0x1, (1,)),
    ('menusys', 'init_7868'):
        ('.sbss', 0x0037ddf8, 0x1, 'MonicaRotationFlag', 0x0037ddfc, 0x1, (1,)),
    ('menusys', 'init_8719'):
        ('.sbss', 0x0037de0c, 0x1, 'MenuItemSelectMode', 0x0037de10, 0x1, (1,)),
    ('movie', 'isWithAudio'):
        ('.sbss', 0x0037df90, 0x1, 'isStarted', 0x0037df94, 0x1, (1,)),
    ('movie', 'isStarted'):
        ('.sbss', 0x0037df94, 0x1, 'isStrFileInit', 0x0037df98, 0x1, (1,)),
    ('movie', 'isStrFileInit'):
        ('.sbss', 0x0037df98, 0x1, 'Loop', 0x0037df9c, 0x1, (1,)),
    ('movie', 'isCountVblank'):
        ('.sbss', 0x0037dfa8, 0x1, 'isFrameEnd', 0x0037dfac, 0x1, (1,)),
    ('movieviewlp', 'MovieLine'):
        ('.sbss', 0x0037e420, 0x2, 'MovieSelect', 0x0037e424, 0x2, (2,)),
    ('movieviewlp', 'init_792'):
        ('.sbss', 0x0037e43c, 0x1, 'init_795', 0x0037e440, 0x1, (1,)),
    ('movieviewlp', 'init_795'):
        ('.sbss', 0x0037e440, 0x1, 'init_798', 0x0037e444, 0x1, (1,)),
    ('movieviewlp', 'init_798'):
        ('.sbss', 0x0037e444, 0x1, 'init_801', 0x0037e448, 0x1, (1,)),
    ('sound', 'msinBfCtx'):
        ('.bss', 0x003f3f80, 0x48, 'msinBf', 0x003f4000, 0x1200, (16,)),
    ('title', 'MasterDebugModeOn'):
        ('.sbss', 0x0037dffc, 0x1, 'TitleBootEventNo', 0x0037e000, 0x1, (None,)),
    ('title', 'TitleMCActivePort'):
        ('.sbss', 0x0037e024, 0x2, 'TitleMCCheckNow', 0x0037e028, 0x1, (None,)),
    ('title', 'TitlePhase'):
        ('.sbss', 0x0037e038, 0x2, 'TitlePushStart_AlphaPlus', 0x0037e03c, 0x2, (2,)),
    ('title', 'TitleCopyRightDispPhase'):
        ('.sbss', 0x0037e044, 0x1, 'TitleCopyRightDispCounter', 0x0037e048, 0x2, (2,)),
    ('title', 'TitleCopyRightDispCounter'):
        ('.sbss', 0x0037e048, 0x2, 'TitleSkipLogoFlag', 0x0037e04c, 0x1, (1,)),
    ('title', 'debug_start_drawflag'):
        ('.sbss', 0x0037e098, 0x1, 'HDDPhase', 0x0037e09c, 0x2, (2,)),
    ('title', 'HDDPhase'):
        ('.sbss', 0x0037e09c, 0x2, 'HDDConfirmType', 0x0037e0a0, 0x2, (2,)),
    ('title', 'HDDConfirmType'):
        ('.sbss', 0x0037e0a0, 0x2, 'HDDnowDisplayImageNo', 0x0037e0a4, 0x2, (2,)),
    ('title', 'HDDnowDisplayImageNo'):
        ('.sbss', 0x0037e0a4, 0x2, 'HDDDlBarDrawFlag', 0x0037e0a8, 0x1, (1,)),
    ('title', 'HDDModeSelect'):
        ('.sbss', 0x0037e0c8, 0x2, 'TitleOmakeFlag', 0x0037e0cc, 0x2, (2,)),
    ('title', 'TitleOmakeFlag'):
        ('.sbss', 0x0037e0cc, 0x2, 'TitleMCCheckBootMode', 0x0037e0d0, 0x1, (1,)),
    ('title', 'TitleMCCheckBootMode'):
        ('.sbss', 0x0037e0d0, 0x1, 'TitleMCCheckPort', 0x0037e0d4, 0x2, (2,)),
    ('title', 'TitleMCCheckPort'):
        ('.sbss', 0x0037e0d4, 0x2, 'TitleMCCheckPhase', 0x0037e0d8, 0x2, (2,)),
}

INVENTED = re.compile(r"D_([0-9A-F]{8})")


def name_sections(elf):
    """Name every section; mwccgap's reader leaves its `.text` sections unnamed."""
    for section in elf.sections:
        section.name = elf.shstrtab.get_symbol_by_index(section.sh_name)


def retail_addresses():
    return {name: address for address, name, _s, _f in layout.read_symbols(ROOT / layout.SYMBOLS)}


def address_of(name, addresses):
    address = addresses.get(name)
    if address is None:
        m = INVENTED.fullmatch(name)
        if m:
            address = int(m.group(1), 16)
    return address


def drop_placeholder_aliases(elf):
    """Give every placeholder's symbol the name of the datum it stands for.

    Returns the indices of the sections the placeholders occupy.
    """
    suffix = layout.PLACEHOLDER_SUFFIX
    sections = set()
    for symbol in elf.symtab.symbols:
        if re.fullmatch(r'jtbl_[0-9A-Fa-f]{8}', symbol.name):
            symbol.name = 'D_' + symbol.name[5:].upper()
            symbol.st_name = elf.strtab.add_symbol(symbol.name)
        if symbol.name.endswith(suffix):
            symbol.name = symbol.name[:-len(suffix)]
            symbol.st_name = elf.strtab.add_symbol(symbol.name)
            if 0 < symbol.st_shndx < len(elf.sections):
                sections.add(symbol.st_shndx)
    return sections


def project_name(name):
    """A compiler's symbol name as main.symbols.txt spells it."""
    name = re.sub(r"[,<>.$]", "_", name)
    return "at_" + name[1:] if name.startswith("@") else name


def project_native_names(elf):
    """Keep raw compiler counters separate from explicit source identities."""
    occupied = set(retail_addresses())
    occupied.update(project_name(symbol.name) for symbol in elf.symtab.symbols)
    anonymous = []
    number = 1 << 64
    for symbol in elf.symtab.symbols:
        if symbol.type == STT_SECTION or symbol.name.startswith('.'):
            continue
        generated = (symbol.bind == STB_LOCAL and symbol.type == STT_OBJECT
                     and re.fullmatch(r'@\d+', symbol.name) is not None
                     and 0 < symbol.st_shndx < len(elf.sections))
        symbol.name = project_name(symbol.name)
        symbol.st_name = elf.strtab.add_symbol(symbol.name)
        if generated:
            while f'at_{number}' in occupied:
                number += 1
            symbol.name = f'at_{number}'
            occupied.add(symbol.name)
            number += 1
            anonymous.append(symbol)
    return anonymous


def rename_dng_main_local_static(elf, unit):
    """Use retail names for InitDungeonMain's C++ local static and its guard."""
    if unit != 'dng_main':
        return
    symbols = elf.symtab.symbols
    storage = [symbol for symbol in symbols
               if re.fullmatch(r'debug_event_stack_\d+', symbol.name)
               and symbol.st_size == 0x30 and symbol.name != 'debug_event_stack_1106']
    if not storage and any(symbol.name == 'debug_event_stack_1106' for symbol in symbols):
        return
    if len(storage) != 1:
        raise ValueError(f'dng_main: expected one debug event stack, found {len(storage)}')
    owners = [symbol.st_shndx for symbol in symbols
              if symbol.name == 'InitDungeonMain__F13INIT_LOOP_ARG']
    referenced = {relocation.symbol_index for record in elf.relocations
                  if record.sh_info in owners for relocation in record.relocations}
    if not any(symbols[index] is storage[0] for index in referenced):
        raise ValueError('dng_main: initializer does not reference its debug event stack')
    guard = [symbol for index, symbol in enumerate(symbols)
             if index in referenced and re.fullmatch(r'init_\d+', symbol.name)
             and symbol.st_size == 1 and symbol.bind == STB_LOCAL
             and 0 < symbol.st_shndx < len(elf.sections)
             and elf.sections[symbol.st_shndx].sh_type == SHT_NOBITS]
    if len(guard) != 1:
        raise ValueError('dng_main: debug event stack initialization guard missing')
    for symbol, name in ((storage[0], 'debug_event_stack_1106'),
                         (guard[0], 'init_1107')):
        if any(other is not symbol and other.name == name for other in symbols):
            raise ValueError(f'dng_main: duplicate {name}')
        symbol.name = name
        symbol.st_name = elf.strtab.add_symbol(name)


def sext16(value):
    value &= 0xFFFF
    return value - 0x10000 if value & 0x8000 else value


def section_size(section):
    return section.sh_size if section.sh_type == SHT_NOBITS else len(section.data)


def rename_shared_names(elf, rows, address_of_section, retail, gp):
    """Spell an undefined symbol the way main.symbols.txt does.

    Two retail symbols of one name are told apart there by a `__<n>` suffix,
    which compiled code cannot know: it refers to the plain name. Which of
    them a reference means is read off the address retail's instruction has
    at the same place.
    """
    plain = {name: address for address, name, _s, _f in rows}
    candidates = {}
    for address, name, _size, _func in rows:
        m = re.fullmatch(r"(.+)__\d+", name)
        if m:
            candidates.setdefault(m.group(1), []).append((address, name))
    for name, options in candidates.items():
        if name in plain:
            options.append((plain[name], name))
    symbols = elf.symtab.symbols
    for record in elf.relocations:
        base = address_of_section.get(record.sh_info)
        section = elf.sections[record.sh_info]
        if base is None or not section.sh_flags & SHF_EXECINSTR:
            continue
        relocations = record.relocations
        for k, relocation in enumerate(relocations):
            symbol = symbols[relocation.symbol_index]
            options = candidates.get(project_name(symbol.name))
            if symbol.st_shndx != 0 or not options:
                continue
            offset = relocation.r_offset
            word = retail.word(base + offset)
            if relocation.reloc_type == 4:
                target = ((base + offset) & 0xF0000000) | ((word & 0x03FFFFFF) << 2)
            elif relocation.reloc_type == R_MIPS_GPREL16:
                target = gp + sext16(word)
            elif relocation.reloc_type in (R_MIPS_HI16, R_MIPS_LO16):
                kind = R_MIPS_LO16 if relocation.reloc_type == R_MIPS_HI16 else R_MIPS_HI16
                order = list(range(k + 1, len(relocations))) + list(range(k - 1, -1, -1))
                other = next((relocations[j] for j in order
                              if relocations[j].reloc_type == kind
                              and relocations[j].symbol_index == relocation.symbol_index), None)
                if other is None:
                    continue
                hi, lo = ((offset, other.r_offset) if relocation.reloc_type == R_MIPS_HI16
                          else (other.r_offset, offset))
                target = ((retail.word(base + hi) & 0xFFFF) << 16) + sext16(retail.word(base + lo))
            else:
                continue
            chosen = [name for address, name in options if address == target]
            if len(chosen) == 1:
                symbol.name = chosen[0]
                symbol.st_name = elf.strtab.add_symbol(symbol.name)


def static_bss_pairs(source, native, held):
    """Select unique source statics and explicit BSS markers with equal extents.

    The inputs contain (symbol index, symbol name, size), not compiler objects.
    Compiler-generated local-static suffixes identify no stable source property.
    A repeated source name or object/marker base is deliberately left unbound.
    """
    source = re.sub(r'//[^\n]*|/\*.*?\*/|"(?:\\.|[^"\\])*"', '', source,
                    flags=re.DOTALL)
    declarations = Counter(re.findall(
        r'\bstatic\s+(?:const\s+)?[A-Za-z_]\w*(?:\s+|\s*[*&]\s*)'
        r'([A-Za-z_]\w*)\s*(?=[;=\[])', source))
    markers = set(re.findall(r'\bINCLUDE_BSS\(\s*([A-Za-z_]\w*)\s*,', source))

    def base(name):
        # project_name converts MWCC's dollar separator to an underscore.
        match = re.fullmatch(r'(.+?)[_$]\d+(?:__\d+)?', name)
        return match.group(1) if match else None

    natives = {}
    placeholders = {}
    for index, name, size in native:
        key = base(name)
        if key is not None:
            natives.setdefault(key, []).append((index, size))
    for index, name, size in held:
        key = base(name)
        if key is not None and name in markers:
            placeholders.setdefault(key, []).append((index, size))
    pairs = []
    for key, options in natives.items():
        targets = placeholders.get(key, [])
        if declarations[key] != 1 or len(options) != 1 or len(targets) != 1:
            continue
        native_index, native_size = options[0]
        held_index, held_size = targets[0]
        if native_size and native_size == held_size:
            pairs.append((native_index, held_index))
    return pairs


def bind_named_static_bss(elf, unit, placeholder_sections):
    """Bind unambiguous native local BSS to its explicit retail storage.

    This binding uses the unit, source declaration, base name and exact extent,
    so instruction scheduling cannot move a reference onto the wrong datum.
    It preserves all relocation addends and never binds initialized storage.
    """
    source_path = ROOT / 'ps2' / 'src' / (unit + '.cpp')
    if not source_path.is_file():
        return []
    lay = layout.Layout(ROOT / layout.YAML)
    ranges = [(lo, hi) for section, lo, hi in lay.sections(unit)
              if section in ('.bss', '.sbss')]
    rows = {name: (address, size) for address, name, size, function
            in layout.read_symbols(ROOT / layout.SYMBOLS)
            if not function and any(lo <= address < hi and address + size <= hi
                                    for lo, hi in ranges)}
    symbols = elf.symtab.symbols
    sections = elf.sections
    native, held = [], []
    for index, symbol in enumerate(symbols):
        section_index = symbol.st_shndx
        if (symbol.type != STT_OBJECT or symbol.st_value != 0
                or not 0 < section_index < len(sections)):
            continue
        section = sections[section_index]
        if (section.name == DEAD or not section.sh_flags & SHF_ALLOC
                or section.sh_flags & SHF_EXECINSTR):
            continue
        size = section_size(section)
        # A section alias or interior symbol needs a different addend mapping.
        if any(other.st_shndx == section_index and other.st_value != 0
               for other in symbols):
            continue
        if (symbol.bind == STB_LOCAL and section.sh_type == SHT_NOBITS
                and symbol.st_size == size
                and sum(other.st_shndx == section_index and other.type == STT_OBJECT
                        for other in symbols) == 1):
            native.append((index, symbol.name, size))
        expected = rows.get(symbol.name)
        if (symbol.bind != STB_LOCAL and expected is not None
                and expected[1] == symbol.st_size == size
                and (section.sh_type == SHT_NOBITS or not any(section.data))
                and not any(record.sh_info == section_index and record.relocations
                            for record in elf.relocations)):
            held.append((index, symbol.name, size))

    pairs = static_bss_pairs(source_path.read_text(), native, held)
    dropped = []
    for native_index, held_index in pairs:
        original, target = symbols[native_index], symbols[held_index]
        section_index = original.st_shndx
        if sections[section_index].name != layout.section_of(rows[target.name][0]):
            continue
        aliases = {index for index, symbol in enumerate(symbols)
                   if symbol.st_shndx == section_index}
        undefined = {index for index, symbol in enumerate(symbols)
                     if symbol.st_shndx == 0 and symbol.name == original.name}
        for record in elf.relocations:
            for relocation in record.relocations:
                if relocation.symbol_index in aliases or relocation.symbol_index in undefined:
                    relocation.symbol_index = held_index
        # Name the unresolved aliases too, so duplicate folding cannot send a
        # later reference back to the dead native definition.
        for index in undefined:
            symbols[index].name = target.name
            symbols[index].st_name = elf.strtab.add_symbol(target.name)
            symbols[index].st_shndx = target.st_shndx
            symbols[index].st_value = target.st_value
        section = sections[section_index]
        section.name = DEAD
        section.sh_name = elf.add_sh_symbol(DEAD)
        for record in elf.relocations:
            if record.sh_info == section_index:
                record.name = '.rel' + DEAD
                record.sh_name = elf.add_sh_symbol(record.name)
        placeholder_sections.add(target.st_shndx)
        dropped.append(original.name)
    return dropped


def bind_local_data(elf, unit, placeholder_sections):
    """Point compiled code at verified placeholders for the data it uses.

    Every incoming reference must agree with any established native identity.
    Both initialized and NOBITS copies need the complete declared object extent.
    Returns the names of the compiler's copies that were dropped.
    """
    lay = layout.Layout(ROOT / layout.YAML)
    if lay.kinds.get(unit) != "cpp":
        return []
    ranges = [(lo, hi) for _s, lo, hi in lay.sections(unit)]

    def in_unit(address):
        return any(lo <= address < hi for lo, hi in ranges)

    rows = layout.read_symbols(ROOT / layout.SYMBOLS)
    gp = next(a for a, n, _s, _f in rows if n == "_gp")
    # The unit's own names; a local that shares its name with another unit's
    # carries a `__<n>` suffix in main.symbols.txt and none in the object.
    names = {}
    for address, name, _size, _func in rows:
        if in_unit(address):
            names[name] = address
            names.setdefault(re.sub(r"__\d+$", "", name), address)

    sections = elf.sections
    symbols = elf.symtab.symbols
    address_of_section = {}
    defining_symbol = {}
    for index, symbol in enumerate(symbols):
        at = symbol.st_shndx
        if (not symbol.name or symbol.type == STT_SECTION or symbol.st_value != 0
                or not 0 < at < len(sections) or not sections[at].sh_flags & SHF_ALLOC
                or symbol.name.startswith(".")):
            continue
        code = bool(sections[at].sh_flags & SHF_EXECINSTR)
        if not code and at not in placeholder_sections:
            continue
        name = project_name(symbol.name)
        address = names.get(name)
        if address is None:
            m = INVENTED.fullmatch(name)
            if m and in_unit(int(m.group(1), 16)):
                address = int(m.group(1), 16)
        if address is not None and at not in address_of_section:
            address_of_section[at] = address
            defining_symbol[at] = index

    held = sorted((address_of_section[i], i) for i in placeholder_sections
                  if i in address_of_section)
    held_starts = [a for a, _i in held]

    def placeholder_at(address):
        k = bisect.bisect_right(held_starts, address) - 1
        if k < 0:
            return None
        start, index = held[k]
        return (start, index) if address < start + max(section_size(sections[index]), 1) else None

    for symbol in symbols:
        if symbol.st_shndx != 0:
            continue
        name = project_name(symbol.name)
        match = INVENTED.fullmatch(name)
        address = int(match.group(1), 16) if match else names.get(name)
        if address is None:
            continue
        found = placeholder_at(address)
        if found is None:
            found = next(((start, index) for index, start in address_of_section.items()
                          if sections[index].sh_flags & SHF_EXECINSTR
                          and start <= address < start + section_size(sections[index])), None)
        if found is not None:
            start, index = found
            symbol.st_shndx = index
            symbol.st_value = address - start

    retail = layout.Retail(ROOT / layout.ELF_PATH)
    addresses = {name: address for address, name, _size, _function in rows}
    code_starts = {index: start for index, start in address_of_section.items()
                   if sections[index].sh_flags & SHF_EXECINSTR}
    data_starts = {index: start for index, start in address_of_section.items()
                   if not sections[index].sh_flags & SHF_EXECINSTR}
    native = {index for index, section in enumerate(sections)
              if index and index not in placeholder_sections and section.name != DEAD
              and section.sh_flags & SHF_ALLOC and not section.sh_flags & SHF_EXECINSTR}
    # Infer complete section identities before mutating any reference. A data
    # consumer becomes an anchor only after its own incoming evidence agrees.
    inferred = {}
    while True:
        additions = {}
        for index in native - inferred.keys():
            targets = referenced_data_starts(elf, index, retail, addresses, code_starts,
                                             data_starts={**data_starts, **inferred})
            if targets is not None and len(targets) == 1:
                start = next(iter(targets))
                if in_unit(start):
                    additions[index] = start
        if not additions:
            break
        inferred.update(additions)

    declared = {start: size for start, _name, size, function in rows if not function and size}
    checked = {}

    def verified_copy(index, active=frozenset()):
        if index in checked:
            return checked[index]
        if index in active or index not in inferred:
            return False
        section = sections[index]
        start = inferred[index]
        size = section_size(section)
        owners = [symbol for symbol in symbols if symbol.st_shndx == index
                  and symbol.type != STT_SECTION]
        if (not size or len(owners) != 1 or owners[0].type != STT_OBJECT
                or owners[0].st_value or owners[0].st_size != size):
            checked[index] = False
            return False
        identity = address_of(project_name(owners[0].name), names)
        if identity is not None and identity != start:
            checked[index] = False
            return False
        entries = [entry for record in elf.relocations if record.sh_info == index
                   for entry in record.relocations]
        expected = {address - start: kind for address, kind in retail.relocations.items()
                    if start <= address < start + size}
        if section.sh_type == SHT_NOBITS:
            valid = (declared.get(start) == size and not entries and not expected
                     and any(kind in layout.NOBITS and lo <= start < start + size <= hi
                             for kind, lo, hi in lay.sections(unit)))
        elif section.sh_type == SHT_PROGBITS:
            actual = {entry.r_offset: entry.reloc_type for entry in entries}
            valid = (declared.get(start) == size
                     and len(actual) == len(entries) and actual == expected)
            data = bytearray(section.data)
            for entry in entries:
                if (not valid or entry.reloc_type != R_MIPS_32 or entry.r_offset % 4
                        or not 0 <= entry.r_offset <= size - 4):
                    valid = False
                    break
                target = symbols[entry.symbol_index]
                if target.st_shndx in inferred:
                    if not verified_copy(target.st_shndx, active | {index}):
                        valid = False
                        break
                    destination = inferred[target.st_shndx] + target.st_value
                elif target.st_shndx in address_of_section:
                    destination = address_of_section[target.st_shndx] + target.st_value
                else:
                    destination = address_of(project_name(target.name), addresses)
                if destination is None:
                    valid = False
                    break
                addend = struct.unpack_from('<I', data, entry.r_offset)[0]
                struct.pack_into('<I', data, entry.r_offset, (destination + addend) & 0xFFFFFFFF)
            valid = valid and bytes(data) == retail.bytes(start, start + size)
        else:
            valid = False
        checked[index] = valid
        return valid

    bound = {}
    for index, start in inferred.items():
        found = placeholder_at(start)
        if (found is None or found[0] != start
                or section_size(sections[index]) > section_size(sections[found[1]])
                or not verified_copy(index)):
            continue
        # Repointing to the base symbol preserves only zero-offset aliases.
        # Interior aliases stay live until an explicit equal-offset identity
        # exists; their offset must never be folded into an instruction field.
        incoming = [entry for record in elf.relocations if sections[record.sh_info].name != DEAD
                    for entry in record.relocations if symbols[entry.symbol_index].st_shndx == index]
        if any(symbols[entry.symbol_index].st_value for entry in incoming):
            continue
        bound[index] = defining_symbol[found[1]]

    # A rejected parent remains a live consumer. Do not discard its children
    # merely because a separate, valid reference established their addresses.
    while True:
        rejected = {index for index in bound
                    if any(record.sh_info not in code_starts
                           and record.sh_info not in placeholder_sections
                           and record.sh_info not in bound
                           and sections[record.sh_info].name != DEAD
                           and any(symbols[entry.symbol_index].st_shndx == index
                                   for entry in record.relocations)
                           for record in elf.relocations)}
        if not rejected:
            break
        for index in rejected:
            bound.pop(index)

    dropped = []
    for record in elf.relocations:
        for entry in record.relocations:
            replacement = bound.get(symbols[entry.symbol_index].st_shndx)
            if replacement is not None:
                entry.symbol_index = replacement
    for index in bound:
        label = next((symbol.name for symbol in symbols if symbol.st_shndx == index
                      and symbol.name and symbol.type != STT_SECTION), f'section {index}')
        sections[index].sh_name = elf.add_sh_symbol(DEAD)
        sections[index].name = DEAD
        for record in elf.relocations:
            if record.sh_info == index:
                record.sh_name = elf.add_sh_symbol('.rel' + DEAD)
                record.name = '.rel' + DEAD
        dropped.append(label)
    rename_shared_names(elf, rows, address_of_section, retail, gp)
    return dropped


def discard_external_vtables(elf, unit, placeholder_sections):
    lay = layout.Layout(ROOT / layout.YAML)
    ranges = [(lo, hi) for section, lo, hi in lay.sections(unit)]
    addresses = retail_addresses()
    declared = {name: size for _start, name, size, function in layout.read_symbols(ROOT / layout.SYMBOLS)
                if not function and size}
    retail = layout.Retail(ROOT / layout.ELF_PATH)
    symbols = elf.symtab.symbols
    for symbol in symbols:
        index = symbol.st_shndx
        if not symbol.name.startswith('__vt__') or not 0 < index < len(elf.sections):
            continue
        if index in placeholder_sections:
            continue
        start = address_of(project_name(symbol.name), addresses)
        if start is None or any(lo <= start < hi for lo, hi in ranges):
            continue
        data = bytearray(elf.sections[index].data)
        if symbol.st_size != declared.get(project_name(symbol.name)) or len(data) != symbol.st_size:
            raise ValueError(f'{symbol.name}: external vtable extent differs from retail')
        entries = [entry for record in elf.relocations if record.sh_info == index
                   for entry in record.relocations]
        actual = {entry.r_offset: entry.reloc_type for entry in entries}
        expected = {address - start: kind for address, kind in retail.relocations.items()
                    if start <= address < start + symbol.st_size}
        if (len(actual) != len(entries) or actual != expected
                or any(entry.r_offset % 4 or not 0 <= entry.r_offset <= symbol.st_size - 4
                       for entry in entries)):
            raise ValueError(f'{symbol.name}: external vtable relocation shape differs from retail')
        for record in elf.relocations:
            if record.sh_info != index:
                continue
            for relocation in record.relocations:
                target = address_of(project_name(symbols[relocation.symbol_index].name), addresses)
                if relocation.reloc_type != 2 or target is None:
                    raise ValueError(f'{symbol.name}: unresolved external vtable slot')
                offset = relocation.r_offset
                value = struct.unpack_from('<I', data, offset)[0]
                struct.pack_into('<I', data, offset, (value + target) & 0xFFFFFFFF)
        if data != retail.bytes(start, start + len(data)):
            raise ValueError(f'{symbol.name}: external vtable differs from retail')
        elf.sections[index].sh_name = elf.add_sh_symbol(DEAD)
        elf.sections[index].name = DEAD
        symbol.st_shndx = 0
        symbol.st_value = 0
        for record in elf.relocations:
            if record.sh_info == index:
                record.sh_name = elf.add_sh_symbol('.rel' + DEAD)
                record.name = '.rel' + DEAD


def discard_external_functions(elf, unit):
    """Discard non-owning weak bodies, reporting any without an exact retail proof."""
    ranges = layout.Layout(ROOT / layout.YAML).sections(unit)
    addresses = retail_addresses()
    rows = {name: (start, size, function)
            for start, name, size, function in layout.read_symbols(ROOT / layout.SYMBOLS)}
    retail = layout.Retail(ROOT / layout.ELF_PATH)
    for symbol in elf.symtab.symbols:
        index = symbol.st_shndx
        address = addresses.get(symbol.name)
        if (symbol.type != STT_FUNC or symbol.bind not in (STB_WEAK, STB_MWCC_COALESCED)
                or not 0 < index < len(elf.sections) or address is None
                or any(lo <= address < hi for section, lo, hi in ranges)):
            continue
        if not complete_code_consumer(
                elf, index, retail=retail, rows=rows,
                address_of_symbol=lambda target: address_of(project_name(target.name), addresses),
                gp=addresses.get('_gp')):
            print(f'{unit}: discarding external function {symbol.name} at {address:#010x}; '
                  'native body not verified against retail', file=sys.stderr)
        elf.sections[index].sh_name = elf.add_sh_symbol(DEAD)
        elf.sections[index].name = DEAD
        for record in elf.relocations:
            if record.sh_info == index:
                record.sh_name = elf.add_sh_symbol('.rel' + DEAD)
                record.name = '.rel' + DEAD
        for entry in elf.symtab.symbols:
            if entry.st_shndx == index:
                entry.st_shndx = 0
                entry.st_value = 0


def referenced_data_starts(elf, index, retail, addresses, code_starts, data_starts=None,
                           size=None):
    """Resolve every live incoming reference, rejecting incomplete evidence.

    HI16 entries share the next LO16 for their target in relocation order.
    No numeric compiler name or unchecked consumer supplies an identity.
    """
    data_starts = {} if data_starts is None else data_starts
    destinations = set()
    symbols = elf.symtab.symbols
    for record in elf.relocations:
        section = elf.sections[record.sh_info]
        if section.name == DEAD:
            continue
        incoming = [entry for entry in record.relocations
                    if symbols[entry.symbol_index].st_shndx == index]
        if not incoming:
            continue
        code_base = code_starts.get(record.sh_info)
        data_base = data_starts.get(record.sh_info)
        if code_base is None and data_base is None:
            return None
        contents = section.data
        pending = {}
        seen_offsets = set()
        for entry in incoming:
            offset, kind = entry.r_offset, entry.reloc_type
            target = symbols[entry.symbol_index]
            if offset % 4 or offset < 0 or offset + 4 > len(contents) or offset in seen_offsets:
                return None
            seen_offsets.add(offset)
            base = code_base if code_base is not None else data_base
            if retail.relocations.get(base + offset) != kind:
                return None
            value = struct.unpack_from('<I', contents, offset)[0]
            expected = retail.word(base + offset)
            if code_base is None:
                if kind != R_MIPS_32:
                    return None
                addend, destination = value, expected
            else:
                if kind not in (R_MIPS_HI16, R_MIPS_LO16, R_MIPS_GPREL16):
                    return None
                if (value ^ expected) & 0xFFFF0000:
                    return None
                if kind == R_MIPS_HI16:
                    pending.setdefault(entry.symbol_index, []).append((value, expected))
                    continue
                if kind == R_MIPS_LO16:
                    highs = pending.pop(entry.symbol_index, [])
                    if not highs:
                        return None
                    for high, retail_high in highs:
                        addend = ((high & 0xFFFF) << 16) + sext16(value) + target.st_value
                        destination = ((retail_high & 0xFFFF) << 16) + sext16(expected)
                        if size is not None and not 0 <= addend < size:
                            return None
                        destinations.add((destination - addend) & 0xFFFFFFFF)
                    continue
                if '_gp' not in addresses:
                    return None
                addend, destination = sext16(value), addresses['_gp'] + sext16(expected)
            addend += target.st_value
            if size is not None and not 0 <= addend < size:
                return None
            destinations.add((destination - addend) & 0xFFFFFFFF)
        if pending:
            return None
    return destinations


def bss_data_names(elf, unit, placeholders, *, retail, pieces, addresses, rows):
    """Select isolated native BSS identities by exact extent and all code consumers."""
    runs = pieces.unit(unit)
    declared = {name: size for _start, name, size, function in rows if not function and size}
    cuts = {start: (section, name, end) for section, run in runs if section in layout.NOBITS
            for name, start, end in run if name in declared}
    code = {name: start for section, run in runs if section in CODE for name, start, _end in run}
    symbols = elf.symtab.symbols
    code_starts = {symbol.st_shndx: code[symbol.name] for symbol in symbols if symbol.name in code}
    code_aliases = {}
    code_rows = {name: (start, size, function) for start, name, size, function in rows}
    alias_candidates = {}
    for name in code:
        if re.fullmatch(r'.+__\d+', name):
            alias_candidates.setdefault(re.sub(r'__\d+$', '', name), []).append(name)
    function_counts = Counter(symbol.name for symbol in symbols if symbol.type == STT_FUNC)
    for symbol in symbols:
        if (symbol.st_shndx in code_starts or symbol.type != STT_FUNC or symbol.bind != STB_LOCAL
                or symbol.st_value or not 0 < symbol.st_shndx < len(elf.sections)):
            continue
        candidates = alias_candidates.get(symbol.name, [])
        if len(candidates) != 1 or function_counts[symbol.name] != 1:
            continue
        name = candidates[0]
        matches = [row for row in rows if row[1] == name]
        if len(matches) != 1 or not matches[0][3]:
            continue
        code_starts[symbol.st_shndx] = code[name]
        code_aliases[id(symbol)] = name
        code_rows[symbol.name] = code_rows[name]
    aliased_indices = {symbol.st_shndx for symbol in symbols if id(symbol) in code_aliases}
    assignments = []
    for symbol in symbols:
        index = symbol.st_shndx
        if (index in placeholders or symbol.bind != STB_LOCAL or symbol.type != STT_OBJECT
                or symbol.st_value or not 0 < index < len(elf.sections)):
            continue
        section = elf.sections[index]
        if (section.name not in layout.NOBITS or section.sh_type != SHT_NOBITS
                or not section.sh_flags & SHF_ALLOC or not symbol.st_size
                or symbol.st_size != section_size(section)
                or any(other.st_shndx == index and other.st_value for other in symbols)
                or sum(other.st_shndx == index and other.type == STT_OBJECT for other in symbols) != 1
                or any(record.sh_info == index and record.relocations for record in elf.relocations)):
            continue
        targets = referenced_data_starts(elf, index, retail, addresses, code_starts,
                                         size=symbol.st_size)
        if targets is None or len(targets) != 1:
            continue
        start = next(iter(targets))
        cut = cuts.get(start)
        if cut is None:
            continue
        kind, name, end = cut
        if (kind != section.name or declared[name] != symbol.st_size
                or start + symbol.st_size > end
                or any(other is not symbol and other.name == name
                       and 0 < other.st_shndx < len(elf.sections)
                       and elf.sections[other.st_shndx].name != DEAD for other in symbols)):
            continue
        aliased_consumers = {record.sh_info for record in elf.relocations
                             if record.sh_info in aliased_indices
                             and any(symbols[entry.symbol_index].st_shndx == index
                                     for entry in record.relocations)}
        if aliased_consumers and re.fullmatch(r'at_\d+', symbol.name) is None:
            continue
        def symbol_address(target):
            if target.st_shndx == index:
                return start + target.st_value
            return address_of(code_aliases.get(id(target), target.name), addresses)
        if not all(complete_code_consumer(elf, consumer, retail=retail, rows=code_rows,
                                          address_of_symbol=symbol_address,
                                          gp=addresses.get('_gp')) for consumer in aliased_consumers):
            continue
        assignments.append((symbol, name))
    counts = Counter(name for _symbol, name in assignments)
    return {id(symbol): name for symbol, name in assignments
            if counts[name] == 1 and symbol.name != name}


def pointer_table_names(elf, unit, placeholders, *, retail, pieces, addresses, rows):
    """Select named local pointer tables before their compiler-owned literals.

    All code consumers establish the table address. Its nonpointer bytes,
    real relocation shape and each pointed-to native literal must match retail.
    """
    runs = pieces.unit(unit)
    cuts = {start: (section, name, end) for section, run in runs
            if section in ('.data', '.sdata', '.rodata') for name, start, end in run}
    declared = {name: size for _start, name, size, function in rows if not function and size}
    code = {name: start for section, run in runs if section in CODE for name, start, _end in run}
    symbols = elf.symtab.symbols
    code_starts = {symbol.st_shndx: code[symbol.name] for symbol in symbols if symbol.name in code}
    assignments = []
    for symbol in symbols:
        index = symbol.st_shndx
        if (index in placeholders or symbol.bind != STB_LOCAL or symbol.type != STT_OBJECT
                or symbol.st_value or not 0 < index < len(elf.sections)
                or re.fullmatch(r'at_\d+', symbol.name)
                or (symbol.name in addresses and addresses[symbol.name] in cuts)):
            continue
        section = elf.sections[index]
        if (section.name not in ('.data', '.sdata', '.rodata')
                or section.sh_type != SHT_PROGBITS or not section.sh_flags & SHF_ALLOC
                or section.sh_flags & SHF_EXECINSTR
                or not symbol.st_size or symbol.st_size != len(section.data)
                or any(other.st_shndx == index and other.st_value for other in symbols)
                or sum(other.st_shndx == index and other.type == STT_OBJECT for other in symbols) != 1):
            continue
        targets = referenced_data_starts(elf, index, retail, addresses, code_starts,
                                         size=symbol.st_size)
        if targets is None or len(targets) != 1:
            continue
        start = next(iter(targets))
        cut = cuts.get(start)
        if cut is None:
            continue
        kind, name, end = cut
        if (kind != section.name or declared.get(name) != symbol.st_size
                or start + symbol.st_size > end
                or any(other is not symbol and other.name == name
                       and 0 < other.st_shndx < len(elf.sections)
                       and elf.sections[other.st_shndx].name != DEAD for other in symbols)):
            continue
        entries = [entry for record in elf.relocations if record.sh_info == index
                   for entry in record.relocations]
        expected = {address - start: kind for address, kind in retail.relocations.items()
                    if start <= address < start + symbol.st_size}
        actual = {entry.r_offset: entry.reloc_type for entry in entries}
        if not entries or len(actual) != len(entries) or actual != expected:
            continue
        data = bytearray(section.data)
        literal_starts = {}
        valid = True
        for entry in entries:
            offset = entry.r_offset
            if entry.reloc_type != R_MIPS_32 or offset % 4 or not 0 <= offset <= len(data) - 4:
                valid = False
                break
            target = symbols[entry.symbol_index]
            addend = struct.unpack_from('<I', data, offset)[0]
            destination = retail.word(start + offset)
            known = (addresses.get(target.name)
                     if not re.fullmatch(r'at_\d+', target.name) else None)
            if known is not None:
                valid = (known + addend) & 0xFFFFFFFF == destination
            elif 0 < target.st_shndx < len(elf.sections):
                literal_index = target.st_shndx
                literal = elf.sections[literal_index]
                base = (destination - addend - target.st_value) & 0xFFFFFFFF
                literal_cut = cuts.get(base)
                owners = [other for other in symbols
                          if other.st_shndx == literal_index and other.type == STT_OBJECT]
                valid = (literal_index not in placeholders and literal.name == '.rodata'
                         and literal.sh_type == SHT_PROGBITS and literal.sh_flags & SHF_ALLOC
                         and len(owners) == 1 and owners[0].bind == STB_LOCAL
                         and owners[0].st_value == 0 and literal.data
                         and owners[0].st_size == len(literal.data)
                         and re.fullmatch(r'at_\d+', owners[0].name) is not None
                         and literal_cut is not None and literal_cut[0] == '.rodata'
                         and base + len(literal.data) <= literal_cut[2]
                         and literal.data == retail.bytes(base, base + len(literal.data))
                         and not any(record.sh_info == literal_index and record.relocations
                                     for record in elf.relocations)
                         and literal_starts.get(literal_index, base) == base)
                literal_starts[literal_index] = base
            else:
                valid = False
            if not valid:
                break
            struct.pack_into('<I', data, offset, destination)
        if valid and data == retail.bytes(start, start + len(data)):
            assignments.append((symbol, name))
    counts = Counter(name for _symbol, name in assignments)
    return {id(symbol): name for symbol, name in assignments if counts[name] == 1}


def complete_code_consumer(elf, index, *, retail, rows, address_of_symbol, gp):
    """Prove an entire native function, including every resolved relocation."""
    section = elf.sections[index]
    owners = [symbol for symbol in elf.symtab.symbols
              if symbol.st_shndx == index and symbol.type == STT_FUNC]
    if (section.name not in CODE or not section.sh_flags & SHF_EXECINSTR
            or len(owners) != 1 or owners[0].st_value):
        return False
    owner = owners[0]
    row = rows.get(owner.name)
    if row is None:
        return False
    base, size, function = row
    contents = section.data
    expected = retail.bytes(base, base + size)
    if (not function or not size or size % 4 or owner.st_size != size
            or len(contents) != size or len(expected) != size):
        return False
    entries = [entry for record in elf.relocations if record.sh_info == index
               for entry in record.relocations]
    offsets = [entry.r_offset for entry in entries]
    if (len(set(offsets)) != len(offsets)
            or any(offset % 4 or not 0 <= offset <= size - 4 for offset in offsets)):
        return False
    masks = {R_MIPS_32: 0xFFFFFFFF, R_MIPS_26: 0x03FFFFFF,
             R_MIPS_HI16: 0xFFFF, R_MIPS_LO16: 0xFFFF, R_MIPS_GPREL16: 0xFFFF}
    kinds = {entry.r_offset: entry.reloc_type for entry in entries}
    for offset in range(0, size, 4):
        kind = kinds.get(offset)
        if kind != retail.relocations.get(base + offset) or kind is not None and kind not in masks:
            return False
        mine = struct.unpack_from('<I', contents, offset)[0]
        theirs = struct.unpack_from('<I', expected, offset)[0]
        if (mine ^ theirs) & (0xFFFFFFFF ^ masks.get(kind, 0)):
            return False
    pending = {}
    for entry in entries:
        target = elf.symtab.symbols[entry.symbol_index]
        address = address_of_symbol(target)
        if address is None:
            return False
        mine = struct.unpack_from('<I', contents, entry.r_offset)[0]
        theirs = retail.word(base + entry.r_offset)
        kind = entry.reloc_type
        if kind == R_MIPS_HI16:
            pending.setdefault(entry.symbol_index, []).append((mine, theirs))
            continue
        if kind == R_MIPS_LO16:
            highs = pending.pop(entry.symbol_index, [])
            if not highs:
                return False
            for high, expected_high in highs:
                addend = ((high & 0xFFFF) << 16) + sext16(mine)
                if ((address + addend + 0x8000) >> 16) & 0xFFFF != expected_high & 0xFFFF:
                    return False
            same = (address + sext16(mine)) & 0xFFFF == theirs & 0xFFFF
        elif kind == R_MIPS_32:
            same = (address + mine) & 0xFFFFFFFF == theirs
        elif kind == R_MIPS_26:
            same = ((address + ((mine & 0x03FFFFFF) << 2)) >> 2) & 0x03FFFFFF == theirs & 0x03FFFFFF
        elif kind == R_MIPS_GPREL16:
            if gp is None:
                return False
            same = (address + sext16(mine) - gp) & 0xFFFF == theirs & 0xFFFF
        else:
            return False
        if not same:
            return False
    return not pending


def name_initialized_locals(elf, unit, placeholders, *, retail, pieces, addresses, rows):
    """Name nonpointer local tables from exact bytes and fully verified callers."""
    runs = pieces.unit(unit)
    cuts = {start: (kind, name, end) for kind, run in runs
            if kind in ('.data', '.sdata', '.rodata') for name, start, end in run}
    declared = {name: size for _start, name, size, function in rows if not function and size}
    own_names = {name for _kind, run in runs for name, _start, _end in run}
    own_addresses = {}
    for name in own_names:
        own_addresses.setdefault(re.sub(r'__\d+$', '', name), set()).add(addresses.get(name))

    def source_address(name):
        if name in own_names:
            return addresses.get(name)
        candidates = own_addresses.get(name, set())
        if candidates:
            return next(iter(candidates)) if len(candidates) == 1 else None
        return address_of(name, addresses)

    def family(name):
        match = re.fullmatch(r'([A-Za-z_]\w*)_\d+', re.sub(r'__\d+$', '', name))
        return match.group(1) if match else None

    symbols = elf.symtab.symbols
    code_starts = {symbol.st_shndx: source_address(symbol.name) for symbol in symbols
                   if symbol.type == STT_FUNC and source_address(symbol.name) is not None}
    code_rows = {name: (start, size, function) for start, name, size, function in rows}
    assignments = []
    for symbol in symbols:
        index = symbol.st_shndx
        if (index in placeholders or symbol.type != STT_OBJECT or symbol.bind != STB_LOCAL
                or symbol.st_value or not 0 < index < len(elf.sections)
                or family(symbol.name) in (None, 'at') or symbol.name in own_names):
            continue
        section = elf.sections[index]
        if (section.name not in ('.data', '.sdata', '.rodata')
                or section.sh_type != SHT_PROGBITS or not section.sh_flags & SHF_ALLOC
                or section.sh_flags & SHF_EXECINSTR or not symbol.st_size
                or symbol.st_size != len(section.data)
                or any(other.st_shndx == index and other.st_value for other in symbols)
                or sum(other.st_shndx == index and other.type == STT_OBJECT for other in symbols) != 1
                or any(record.sh_info == index and record.relocations for record in elf.relocations)):
            continue
        starts = referenced_data_starts(elf, index, retail, addresses, code_starts,
                                       size=symbol.st_size)
        if starts is None or len(starts) != 1:
            continue
        start = next(iter(starts))
        cut = cuts.get(start)
        if cut is None:
            continue
        kind, name, end = cut
        if (kind != section.name or family(name) != family(symbol.name)
                or declared.get(name) != symbol.st_size or start + symbol.st_size > end
                or section.data != retail.bytes(start, start + symbol.st_size)
                or any(start <= address < start + symbol.st_size for address in retail.relocations)
                or any(other is not symbol and other.name == name
                       and 0 < other.st_shndx < len(elf.sections)
                       and elf.sections[other.st_shndx].name != DEAD for other in symbols)):
            continue
        assignments.append((symbol, name, start))
    counts = Counter(name for _symbol, name, _start in assignments)
    pending = {symbol.st_shndx: (symbol, name, start)
               for symbol, name, start in assignments if counts[name] == 1}
    # Several locals may share one function. Verify all proposed identities
    # together, then remove dependent claims until every remaining consumer
    # is complete without relying on a rejected peer.
    while pending:
        section_bases = {}
        for other in symbols:
            address = source_address(other.name)
            if address is not None and 0 < other.st_shndx < len(elf.sections):
                section_bases.setdefault(other.st_shndx, set()).add(address - other.st_value)
        section_bases.update((index, {entry[2]}) for index, entry in pending.items())

        def symbol_address(target):
            bases = section_bases.get(target.st_shndx, set())
            if len(bases) == 1:
                return next(iter(bases)) + target.st_value
            return source_address(target.name)

        rejected = set()
        for index in pending:
            consumers = {record.sh_info for record in elf.relocations
                         if elf.sections[record.sh_info].name != DEAD
                         and any(symbols[entry.symbol_index].st_shndx == index
                                 for entry in record.relocations)}
            if not all(complete_code_consumer(elf, consumer, retail=retail, rows=code_rows,
                                              address_of_symbol=symbol_address,
                                              gp=addresses.get('_gp')) for consumer in consumers):
                rejected.add(index)
        if not rejected:
            break
        pending = {index: entry for index, entry in pending.items() if index not in rejected}
    for symbol, name, _start in pending.values():
        symbol.name = name
        symbol.st_name = elf.strtab.add_symbol(name)


def name_literal_data(elf, unit, placeholders, *, retail=None, pieces=None, addresses=None, rows=None,
                      padding_pieces=None):
    retail = layout.Retail() if retail is None else retail
    pieces = disassemble.Pieces(references=[]) if pieces is None else pieces
    addresses = retail_addresses() if addresses is None else addresses
    rows = layout.read_symbols(ROOT / layout.SYMBOLS) if rows is None else rows
    padding_pieces = pieces if padding_pieces is None else padding_pieces
    padding_ends = {(start, name): end for _kind, run in padding_pieces.unit(unit)
                    for name, start, end in run}
    regions = [(lo, retail.bytes(lo, hi)) for name, lo, hi in pieces.layout.sections(unit)
               if name in ('.rodata', '.sdata', '.data', '.ctor')]
    cuts = {start: (name, end) for section, run in pieces.unit(unit)
            if section in ('.rodata', '.sdata', '.data', '.ctor') for name, start, end in run}
    trailing = {run[-1][1] for section, run in pieces.unit(unit)
                if section in ('.rodata', '.sdata', '.data', '.ctor') and run}
    declared_sizes = {name: size for _address, name, size, function in rows
                      if not function and size}
    bss_names = bss_data_names(elf, unit, placeholders, retail=retail, pieces=pieces,
                               addresses=addresses, rows=rows)
    pointer_names = pointer_table_names(elf, unit, placeholders, retail=retail, pieces=pieces,
                                        addresses=addresses, rows=rows)
    positions = sorted(retail.relocations)
    code_addresses = {name: start for section, run in pieces.unit(unit)
                      if section in CODE for name, start, end in run}
    code_starts = {symbol.st_shndx: code_addresses[symbol.name]
                   for symbol in elf.symtab.symbols if symbol.name in code_addresses}
    data_starts = {
        symbol.st_shndx: addresses[symbol.name]
        for symbol in elf.symtab.symbols
        if symbol.type == STT_OBJECT and symbol.name in addresses
        and addresses[symbol.name] in cuts and symbol.st_value == 0
        and 0 < symbol.st_shndx < len(elf.sections)
        and symbol.st_shndx not in placeholders
        and elf.sections[symbol.st_shndx].name in ('.rodata', '.sdata', '.data', '.ctor')
        and elf.sections[symbol.st_shndx].sh_type == SHT_PROGBITS
        and elf.sections[symbol.st_shndx].sh_flags & SHF_ALLOC
        and not elf.sections[symbol.st_shndx].sh_flags & SHF_EXECINSTR
        and not re.fullmatch(r'at_\d+(?:__\d+)?', symbol.name)
    }
    data_starts.update((symbol.st_shndx, addresses[pointer_names[id(symbol)]])
                       for symbol in elf.symtab.symbols if id(symbol) in pointer_names)
    for symbol in elf.symtab.symbols:
        name = bss_names.get(id(symbol), pointer_names.get(id(symbol)))
        if name is not None:
            symbol.name = name
            symbol.st_name = elf.strtab.add_symbol(name)
            continue
        index = symbol.st_shndx
        if (index in placeholders or not re.fullmatch(r'(?:at_\d+|\.p__sinit_.+)', symbol.name)
                or symbol.type != STT_OBJECT or symbol.st_value != 0
                or not 0 < index < len(elf.sections)):
            continue
        section = elf.sections[index]
        if (section.name not in ('.rodata', '.sdata', '.data', '.ctor') or not section.data
                or symbol.st_size != len(section.data)):
            continue
        data = bytearray(section.data)
        entries = {}
        unresolved = False
        for record in elf.relocations:
            if record.sh_info != index:
                continue
            for entry in record.relocations:
                target = addresses.get(elf.symtab.symbols[entry.symbol_index].name)
                if entry.reloc_type != R_MIPS_32 or target is None:
                    unresolved = True
                    break
                value = struct.unpack_from('<I', data, entry.r_offset)[0]
                struct.pack_into('<I', data, entry.r_offset, (target + value) & 0xFFFFFFFF)
                entries[entry.r_offset] = entry.reloc_type
        if unresolved:
            continue
        found = []
        for lo, contents in regions:
            offset = contents.find(data)
            while offset >= 0:
                start = lo + offset
                first = bisect.bisect_left(positions, start)
                last = bisect.bisect_left(positions, start + len(data))
                actual = {place - start: retail.relocations[place] for place in positions[first:last]}
                if actual == entries and start in cuts:
                    found.append(start)
                offset = contents.find(data, offset + 1)
        # Known consumers constrain identity even when extents would leave one
        # byte candidate. Without reference evidence, exact declared sizes may
        # distinguish a literal from the prefix of a larger initialized object.
        if found:
            targets = set()
            for record in elf.relocations:
                base = code_starts.get(record.sh_info)
                if base is None:
                    continue
                contents = elf.sections[record.sh_info].data
                for position, entry in enumerate(record.relocations):
                    target = elf.symtab.symbols[entry.symbol_index]
                    offset = entry.r_offset
                    kind = entry.reloc_type
                    if (target.st_shndx != index or kind not in (R_MIPS_HI16, R_MIPS_GPREL16)
                            or retail.relocations.get(base + offset) != kind):
                        continue
                    value = struct.unpack_from('<I', contents, offset)[0]
                    expected = retail.word(base + offset)
                    if (value ^ expected) & 0xFFFF0000:
                        continue
                    if kind == R_MIPS_GPREL16:
                        destination = addresses['_gp'] + sext16(expected) - sext16(value)
                    else:
                        partner = next((other for other in record.relocations[position + 1:]
                                        if other.reloc_type == R_MIPS_LO16
                                        and other.symbol_index == entry.symbol_index), None)
                        if partner is None or retail.relocations.get(base + partner.r_offset) != R_MIPS_LO16:
                            continue
                        low = struct.unpack_from('<I', contents, partner.r_offset)[0]
                        expected_low = retail.word(base + partner.r_offset)
                        if (low ^ expected_low) & 0xFFFF0000:
                            continue
                        destination = ((expected & 0xFFFF) << 16) + sext16(expected_low)
                        destination -= ((value & 0xFFFF) << 16) + sext16(low)
                    destination -= target.st_value
                    targets.add(destination)
            for record in elf.relocations:
                base = data_starts.get(record.sh_info)
                if base is None:
                    continue
                contents = elf.sections[record.sh_info].data
                for entry in record.relocations:
                    target = elf.symtab.symbols[entry.symbol_index]
                    if (target.st_shndx != index or entry.reloc_type != R_MIPS_32
                            or retail.relocations.get(base + entry.r_offset) != R_MIPS_32):
                        continue
                    addend = struct.unpack_from('<I', contents, entry.r_offset)[0]
                    targets.add(retail.word(base + entry.r_offset) - addend - target.st_value)
            if targets:
                if len(targets) != 1 or not targets.issubset(found):
                    continue
                found = list(targets)
            else:
                found = [start for start in found
                         if declared_sizes.get(cuts[start][0], len(data)) == len(data)]
        if len(found) != 1:
            continue
        start = found[0]
        name, end = cuts[start]
        if any(other is not symbol and other.name == name
               and 0 < other.st_shndx < len(elf.sections)
               and elf.sections[other.st_shndx].name != DEAD for other in elf.symtab.symbols):
            continue
        end = min(end, padding_ends.get((start, name), end))
        if declared_sizes.get(name, len(data)) != len(data):
            continue
        # A terminal tail uses the same address-derived cap as the checker.
        # Reference-only cuts inside that tail remain bounded internal pieces.
        terminal_tail = (start in trailing and name in declared_sizes
                         and end == cuts[start][1])
        padding_limit = min(end & -end, MAX_DATA_ALIGNMENT) if terminal_tail else 16
        if start + len(data) > end:
            continue
        if ((end - start - len(data) >= padding_limit)
                or any(start + len(data) <= address < end for address in retail.relocations)):
            continue
        padding = retail.bytes(start + len(data), end)
        if len(padding) != end - start - len(data) or any(padding):
            continue
        section.data += bytes(len(padding))
        symbol.st_size = len(section.data)
        symbol.name = name
        symbol.st_name = elf.strtab.add_symbol(name)

    name_initialized_locals(elf, unit, placeholders, retail=retail, pieces=pieces,
                            addresses=addresses, rows=rows)
    # A local consumer needs every literal identity before its complete code
    # can prove an anonymous zero template. The second pass supplies no bytes.
    bss_names = bss_data_names(elf, unit, placeholders, retail=retail, pieces=pieces,
                               addresses=addresses, rows=rows)
    for symbol in elf.symtab.symbols:
        name = bss_names.get(id(symbol))
        if name is not None:
            symbol.name = name
            symbol.st_name = elf.strtab.add_symbol(name)


def native_data_extents(elf, placeholders):
    """Capture whole compiler objects before any naming or padding changes."""
    defined = {}
    for symbol in elf.symtab.symbols:
        if symbol.type != STT_SECTION and 0 < symbol.st_shndx < len(elf.sections):
            defined.setdefault(symbol.st_shndx, []).append(symbol)
    result = {}
    for index, symbols in defined.items():
        section = elf.sections[index]
        if (index in placeholders or len(symbols) != 1
                or section.name not in ('.data', '.sdata', '.rodata', '.bss', '.sbss')
                or section.sh_flags != FLAGS[section.name]
                or section.sh_type not in (SHT_PROGBITS, SHT_NOBITS)):
            continue
        symbol = symbols[0]
        size = section_size(section)
        if symbol.type == STT_OBJECT and symbol.st_value == 0 and symbol.st_size == size and size:
            result[index] = (symbol, size, section.sh_addralign, section.sh_type, section.name)
    return result


def materialize_alignment_fragments(elf, unit, placeholders, native_extents, *,
                                   held=frozenset(), retail=None, pieces=None, rows=None):
    """Split only zero storage required by two verified native object alignments."""
    retail = layout.Retail() if retail is None else retail
    pieces = disassemble.Pieces() if pieces is None else pieces
    rows = layout.read_symbols(ROOT / layout.SYMBOLS) if rows is None else rows
    declared = {name: (start, size) for start, name, size, function in rows if not function}
    row_addresses = {start for start, _name, _size, _function in rows}
    definitions = {}
    for symbol in elf.symtab.symbols:
        if symbol.type != STT_SECTION and 0 < symbol.st_shndx < len(elf.sections):
            definitions.setdefault(symbol.name, []).append(symbol)

    def native(name, start, kind):
        entries = definitions.get(name, [])
        if len(entries) != 1 or name in held:
            return None
        symbol = entries[0]
        index = symbol.st_shndx
        original = native_extents.get(index)
        if original is None or index in placeholders:
            return None
        owner, size, alignment, section_type, section_name = original
        section = elf.sections[index]
        if (owner is not symbol or symbol.type != STT_OBJECT or symbol.st_value
                or declared.get(name) != (start, size) or section_name != kind
                or section.name != kind or section.sh_type != section_type
                or section.sh_flags != FLAGS[kind]
                or alignment <= 0 or alignment > 16 or alignment & (alignment - 1)
                or start % alignment or section_size(section) < size
                or any(other is not symbol and other.type != STT_SECTION and other.st_shndx == index
                       for other in elf.symtab.symbols)):
            return None
        return symbol, size, alignment, section

    pending = []
    for kind, run in pieces.unit(unit):
        if kind not in ('.data', '.sdata', '.rodata', '.bss', '.sbss'):
            continue
        for position, (name, start, end) in enumerate(run):
            left = native(name, start, kind)
            if left is None:
                continue
            fragments = []
            following = position + 1
            while following < len(run):
                fragment, lo, hi = run[following]
                if fragment != f'D_{lo:08X}' or fragment in declared:
                    break
                fragments.append((fragment, lo, hi))
                following += 1
            if not fragments or following >= len(run):
                continue
            next_name, next_start, next_end = run[following]
            right = native(next_name, next_start, kind)
            if right is None:
                continue
            symbol, size, _alignment, section = left
            _next_symbol, next_size, alignment, next_section = right
            gap_start = start + size
            if (not 0 < next_start - gap_start < 16 or end < gap_start
                    or section_size(section) > end - start
                    or section_size(next_section) > next_end - next_start
                    or next_size > next_end - next_start
                    or ((gap_start + alignment - 1) & -alignment) != next_start
                    or any(gap_start <= address < next_start for address in row_addresses)
                    or any(gap_start <= address < next_start for address in retail.relocations)
                    or any(size <= entry.r_offset < next_start - start
                           for record in elf.relocations if record.sh_info == symbol.st_shndx
                           for entry in record.relocations)):
                continue
            cursor = end
            valid = True
            for fragment, lo, hi in fragments:
                existing = [entry for entry in elf.symtab.symbols if entry.name == fragment]
                if (lo != cursor or not lo < hi <= next_start or fragment in held
                        or len(existing) > 1 or any(entry.st_shndx or entry.st_value or entry.st_size
                                                  for entry in existing)):
                    valid = False
                    break
                cursor = hi
            if not valid or cursor != next_start:
                continue
            nobits = kind in layout.NOBITS
            if nobits != (section.sh_type == SHT_NOBITS) or nobits != (next_section.sh_type == SHT_NOBITS):
                continue
            if not nobits:
                padding = retail.bytes(gap_start, next_start)
                if (len(padding) != next_start - gap_start or any(padding)
                        or any(section.data[size:])):
                    continue
            pending.extend((kind, fragment, hi - lo, nobits) for fragment, lo, hi in fragments)

    if len({name for _kind, name, _size, _nobits in pending}) != len(pending):
        raise ValueError(f'{unit}: ambiguous native alignment fragments')
    for kind, name, size, nobits in pending:
        cls = BssSection if nobits else Section
        section = cls(elf.add_sh_symbol(kind), SHT_NOBITS if nobits else SHT_PROGBITS,
                      FLAGS[kind], 0, 0, size, 0, 0, 1, 0, b'' if nobits else bytes(size))
        section.name = kind
        index = elf.add_section(section)
        # Address labels describe alignment storage, not invented C++ objects.
        _position, symbol = elf.symtab.get_symbol_by_name(name)
        if symbol is None:
            symbol = Symbol(0, 0, size, 0x10, 0, index)
            symbol.name = name
            elf.add_symbol(symbol)
        else:
            symbol.st_shndx, symbol.st_size = index, size
            symbol.type, symbol.bind = 0, 1


def pad_data(elf, unit, placeholders, *, retail=None, pieces=None, rows=None,
             native_extents=None, held=frozenset()):
    """Retain proved alignment or an explicitly listed unresolved retail reservation."""
    retail = layout.Retail() if retail is None else retail
    pieces = disassemble.Pieces() if pieces is None else pieces
    rows = layout.read_symbols(ROOT / layout.SYMBOLS) if rows is None else rows
    runs = [(section, run) for section, run in pieces.unit(unit)
            if section in ('.data', '.sdata', '.rodata', '.bss', '.sbss', '.vtables')]
    cuts = {name: (start, end) for section, run in runs for name, start, end in run}
    trailing = {(section, run[-1][0]) for section, run in runs if run}
    declared_sizes = {name: size for _address, name, size, _is_function
                      in rows if size}
    declarations = {}
    for address, name, size, function in rows:
        declarations.setdefault(name, []).append((address, size, function))
    if native_extents is None:
        native_extents = native_data_extents(elf, placeholders)
    definitions = {}
    for symbol in elf.symtab.symbols:
        if symbol.type != STT_SECTION and 0 < symbol.st_shndx < len(elf.sections):
            definitions.setdefault(symbol.name, []).append(symbol)

    def native(name, start, kind, piece_end):
        symbols = definitions.get(name, [])
        if len(symbols) != 1:
            return None
        symbol = symbols[0]
        index = symbol.st_shndx
        original = native_extents.get(index)
        if original is None or index in placeholders:
            return None
        owner, size, alignment, section_type, section_name = original
        section = elf.sections[index]
        if (owner is not symbol or symbol.type != STT_OBJECT or symbol.st_value
                or declarations.get(name) != [(start, size, False)]
                or section_type != SHT_NOBITS or section_name != kind
                or section.name != kind or section.sh_type != SHT_NOBITS
                or section.sh_flags != FLAGS[kind]
                or section_size(section) < size or symbol.st_size != size
                or section_size(section) > max(size, piece_end - start)
                or alignment <= 0 or alignment > MAX_DATA_ALIGNMENT
                or alignment & (alignment - 1) or start % alignment
                or any(other is not symbol and other.type != STT_SECTION and other.st_shndx == index
                       for other in elf.symtab.symbols)):
            return None
        return size, alignment

    following_objects = {}
    for kind, run in runs:
        if kind not in layout.NOBITS:
            continue
        for position, (name, _start, end) in enumerate(run):
            cursor = end
            for fragment, lo, hi in run[position + 1:]:
                if lo != cursor or hi <= lo:
                    break
                if fragment == f'D_{lo:08X}' and fragment not in declarations:
                    entries = definitions.get(fragment, [])
                    if entries:
                        if len(entries) != 1:
                            break
                        label = entries[0]
                        index = label.st_shndx
                        section = elf.sections[index]
                        if (label.type != 0 or label.st_value or label.st_size != hi - lo
                                or index in placeholders or section.name != kind
                                or section.sh_type != SHT_NOBITS or section.sh_flags != FLAGS[kind]
                                or section.sh_addralign != 1
                                or section_size(section) != hi - lo
                                or any(other is not label and other.type != STT_SECTION
                                       and other.st_shndx == index for other in elf.symtab.symbols)
                                or any(record.sh_info == index and record.relocations
                                       for record in getattr(elf, 'relocations', ()))):
                            break
                    cursor = hi
                    continue
                next_rows = declarations.get(fragment, [])
                if (len(next_rows) == 1 and next_rows[0][0] == lo
                        and next_rows[0][1] and not next_rows[0][2]):
                    following_objects[name] = (kind, fragment, lo, next_rows[0][1], hi)
                break
    for symbol in elf.symtab.symbols:
        index = symbol.st_shndx
        if (symbol.type != STT_OBJECT or symbol.st_value or index in placeholders
                or not 0 < index < len(elf.sections) or symbol.name not in cuts):
            continue
        start, end = cuts[symbol.name]
        section = elf.sections[index]
        kind = layout.section_of(start)
        if symbol.name in declared_sizes and (kind, symbol.name) in trailing:
            end = min(end, start + declared_sizes[symbol.name])
        size = section_size(section)
        # Symbol sizes describe the object, whereas section pieces also own
        # the following alignment gap. Do not hide an incorrect object size
        # by filling it; only a correctly sized object may acquire padding.
        declared_size = declared_sizes.get(symbol.name)
        if declared_size is not None and size != declared_size:
            continue
        following = following_objects.get(symbol.name)
        if (following and section.name in layout.NOBITS and section.sh_type == SHT_NOBITS
                and size and end - start > size and native(symbol.name, start, kind, end)):
            next_kind, next_name, limit, next_size, next_end = following
            right = native(next_name, limit, kind, next_end)
            alignment = right[1] if right else 0
            proved = alignment and ((start + size + alignment - 1) & -alignment) == limit
            reservation = BSS_RETAIL_RESERVATIONS.get((unit, symbol.name))
            listed = False
            if reservation and reservation[:6] == (kind, start, size, next_name, limit, next_size):
                if right:
                    listed = alignment in reservation[6]
                elif None in reservation[6] and next_name in held:
                    entries = definitions.get(next_name, [])
                    if not entries:
                        listed = True
                    elif (len({entry.st_shndx for entry in entries}) == 1
                          and entries[0].st_shndx in placeholders):
                        marker = entries[0]
                        marker_section = elf.sections[marker.st_shndx]
                        marker_size = section_size(marker_section)
                        aliases = [other for other in elf.symtab.symbols
                                   if other.type != STT_SECTION and other.st_shndx == marker.st_shndx]
                        # Declarations may reference the same retained payload at offset zero.
                        listed = (marker.type == STT_OBJECT and not marker.st_value
                                  and next_size <= marker_size <= max(next_size, next_end - limit)
                                  and marker_section.name == kind
                                  and marker_section.sh_type == SHT_NOBITS
                                  and marker_section.sh_flags == FLAGS[kind]
                                  and 0 < marker_section.sh_addralign <= MAX_DATA_ALIGNMENT
                                  and not marker_section.sh_addralign & (marker_section.sh_addralign - 1)
                                  and all(other.name == next_name and other.type == STT_OBJECT
                                          and not other.st_value
                                          and other.st_size in (next_size, marker_size)
                                          for other in aliases)
                                  and any(other.st_size == marker_size for other in aliases)
                                  and not any(record.sh_info == marker.st_shndx and record.relocations
                                              for record in getattr(elf, 'relocations', ())))
            if (next_kind == kind and end <= limit and (proved or listed)
                    and not any(start + size <= address < limit for address, _name, _size, _function in rows)
                    and not any(start + size <= address < limit for address in retail.relocations)
                    and not any(size <= entry.r_offset < limit - start
                                for record in getattr(elf, 'relocations', ()) if record.sh_info == index
                                for entry in record.relocations)):
                section.sh_size = end - start
                continue
        if (section.name in ('.data', '.sdata', '.rodata', '.vtables') and size
                and 0 < end - start - size < 16):
            padding = retail.bytes(start + size, end)
            if (len(padding) == end - start - size and not any(padding)
                    and not any(start + size <= address < end for address in retail.relocations)):
                section.data += bytes(len(padding))
                symbol.st_size = len(section.data)


def order_sections(elf):
    addresses = retail_addresses()
    starts = {}
    for symbol in elf.symtab.symbols:
        address = address_of(symbol.name, addresses)
        if (address is not None and symbol.type != STT_SECTION
                and 0 < symbol.st_shndx < len(elf.sections)):
            starts[symbol.st_shndx] = address - symbol.st_value
    order = list(range(len(elf.sections)))
    for name in FLAGS:
        indices = [index for index, section in enumerate(elf.sections)
                   if section.name == name and index in starts]
        ordered = sorted((starts[index], index) for index in indices)
        for position, (address, index) in zip(indices, ordered):
            order[position] = index
    remap = {old: new for new, old in enumerate(order)}
    elf.sections = [elf.sections[index] for index in order]
    elf.e_shstrndx = remap[elf.e_shstrndx]
    for symbol in elf.symtab.symbols:
        if symbol.st_shndx in remap:
            symbol.st_shndx = remap[symbol.st_shndx]
    for section in elf.sections:
        if section.sh_link in remap:
            section.sh_link = remap[section.sh_link]
    for record in elf.relocations:
        record.sh_info = remap[record.sh_info]


def discard_shadow_vtables(elf, placeholder_sections, *, native_sizes=None):
    symbols = elf.symtab.symbols
    declared = {name: size for _start, name, size, function in layout.read_symbols(ROOT / layout.SYMBOLS)
                if not function and size}
    native_sizes = {} if native_sizes is None else native_sizes
    held = {}
    for index, symbol in enumerate(symbols):
        if symbol.st_shndx in placeholder_sections and symbol.name.startswith('__vt__'):
            held[project_name(symbol.name)] = index
    for index, symbol in enumerate(symbols):
        target_index = held.get(project_name(symbol.name))
        if target_index is None or symbol.st_shndx in placeholder_sections:
            continue
        section_index = symbol.st_shndx
        if not 0 < section_index < len(elf.sections):
            continue
        section = elf.sections[section_index]
        target = symbols[target_index]
        original = bytearray(section.data)
        expected = bytearray(elf.sections[target.st_shndx].data)
        original_size = native_sizes.get(id(symbol), symbol.st_size)
        if (original_size != declared.get(project_name(target.name))
                or not original_size <= len(original) <= len(expected)
                or any(expected[len(original):])):
            raise ValueError(f'{symbol.name}: vtable extent differs from retail')
        actual_relocations = {}
        expected_relocations = {}
        for record in elf.relocations:
            if record.sh_info not in (section_index, target.st_shndx):
                continue
            destination = actual_relocations if record.sh_info == section_index else expected_relocations
            data = original if record.sh_info == section_index else expected
            for relocation in record.relocations:
                offset = relocation.r_offset
                if (offset in destination or offset % 4
                        or not 0 <= offset <= original_size - 4):
                    raise ValueError(f'{symbol.name}: invalid or duplicate vtable relocation site')
                name = project_name(symbols[relocation.symbol_index].name)
                destination[offset] = (relocation.reloc_type, name, struct.unpack_from('<I', data, offset)[0])
                struct.pack_into('<I', data, offset, 0)
        if original != expected[:len(original)] or actual_relocations != expected_relocations:
            raise ValueError(f'{symbol.name}: compiled vtable differs from retail')
        for record in elf.relocations:
            for relocation in record.relocations:
                if relocation.symbol_index == index:
                    relocation.symbol_index = target_index
            if record.sh_info == section_index:
                record.sh_name = elf.add_sh_symbol('.rel' + DEAD)
                record.name = '.rel' + DEAD
        section.sh_name = elf.add_sh_symbol(DEAD)
        section.name = DEAD


def bind_suffixed_references(elf, unit):
    """Bind unique in-unit duplicate names and preserve their reference addends."""
    lay = layout.Layout(ROOT / layout.YAML)
    if lay.kinds.get(unit) != "cpp":
        return
    ranges = [(lo, hi) for _s, lo, hi in lay.sections(unit)]
    names = {name for address, name, _size, _func in layout.read_symbols(ROOT / layout.SYMBOLS)
             if any(lo <= address < hi for lo, hi in ranges)}
    own = {name for name in names if re.fullmatch(r".+__\d+", name)}
    symbols = elf.symtab.symbols
    defined = {}
    for index, symbol in enumerate(symbols):
        if (symbol.name and symbol.type != STT_SECTION and 0 < symbol.st_shndx < len(elf.sections)
                and elf.sections[symbol.st_shndx].name != DEAD):
            defined.setdefault(symbol.name, index)
    remap = {}
    for name in sorted(own - set(defined)):
        plain = re.sub(r"__\d+$", "", name)
        if plain not in defined:
            continue
        if plain in names or sum(re.sub(r"__\d+$", "", candidate) == plain for candidate in own) != 1:
            continue
        definition = symbols[defined[plain]]
        for index, symbol in enumerate(symbols):
            if symbol.st_shndx == 0 and symbol.name == name:
                remap[index] = defined[plain]
        definition.name = name
        definition.st_name = elf.strtab.add_symbol(name)
    # The main unit's handwritten callback is assembled under the split's
    # duplicate suffix. Its native C++ declaration uses the original local
    # name; bind that reference to this unit's assembled body.
    if unit == 'main' and 'VSyncCallBack__Fi__2' in defined:
        for index, symbol in enumerate(symbols):
            if symbol.name == 'VSyncCallBack__Fi':
                remap[index] = defined['VSyncCallBack__Fi__2']
                # mwccgap may already have pointed the unresolved declaration
                # at the assembled section; only the suffixed name is exported.
                symbol.st_shndx = 0
                symbol.st_value = 0
    for record in elf.relocations:
        for relocation in record.relocations:
            if relocation.symbol_index in remap:
                relocation.symbol_index = remap[relocation.symbol_index]


def fold_duplicates(elf):
    """Keep one symbol per global name; repoint relocations at it."""
    symbols = elf.symtab.symbols
    local = {}
    for index, symbol in enumerate(symbols):
        if (index and symbol.bind == STB_LOCAL and symbol.name and symbol.type != STT_SECTION
                and 0 < symbol.st_shndx < len(elf.sections)):
            local.setdefault(symbol.name, index)
    own = {index: local[symbol.name] for index, symbol in enumerate(symbols)
           if index and symbol.st_shndx == 0 and symbol.bind != STB_LOCAL
           and symbol.name in local}
    if own:
        for record in elf.relocations:
            for relocation in record.relocations:
                relocation.symbol_index = own.get(relocation.symbol_index, relocation.symbol_index)
    keep = {}
    for index, symbol in enumerate(symbols):
        if index == 0 or symbol.bind == STB_LOCAL or not symbol.name:
            continue
        held = keep.get(symbol.name)
        if held is None:
            keep[symbol.name] = index
            continue
        previous = symbols[held]
        if previous.st_shndx == 0 and symbol.st_shndx != 0:
            keep[symbol.name] = index
        elif (0 < previous.st_shndx < len(elf.sections)
              and elf.sections[previous.st_shndx].name == DEAD
              and 0 < symbol.st_shndx < len(elf.sections)
              and elf.sections[symbol.st_shndx].name != DEAD):
            keep[symbol.name] = index
    remap = {}
    kept = []
    for index, symbol in enumerate(symbols):
        if index and symbol.bind != STB_LOCAL and symbol.name and keep[symbol.name] != index:
            continue
        remap[index] = len(kept)
        kept.append(symbol)
    if len(kept) == len(symbols):
        return
    # sh_info counts the leading entries the table treats as local.
    elf.symtab.sh_info = sum(1 for i in range(elf.symtab.sh_info) if i in remap)
    for index, symbol in enumerate(symbols):
        if index not in remap:
            remap[index] = remap[keep[symbol.name]]
    elf.symtab.symbols = kept
    for record in elf.relocations:
        for relocation in record.relocations:
            relocation.symbol_index = remap[relocation.symbol_index]


def discard_unused_literals(elf):
    referenced = {elf.symtab.symbols[relocation.symbol_index].st_shndx
                  for record in elf.relocations for relocation in record.relocations}
    for symbol in elf.symtab.symbols:
        index = symbol.st_shndx
        if (symbol.type != STT_OBJECT or symbol.bind != STB_LOCAL
                or not re.fullmatch(r'at_\d+', symbol.name)
                or not 0 < index < len(elf.sections) or index in referenced):
            continue
        section = elf.sections[index]
        if section.name not in ('.rodata', '.sdata', '.sbss', '.bss'):
            continue
        section.sh_name = elf.add_sh_symbol(DEAD)
        section.name = DEAD
        for record in elf.relocations:
            if record.sh_info == index:
                record.sh_name = elf.add_sh_symbol('.rel' + DEAD)
                record.name = '.rel' + DEAD


def discard_dead_code_records(elf):
    """Drop compiler metadata only when every relocation names discarded code."""
    symbols = elf.symtab.symbols
    records_by_section = {}
    for record in elf.relocations:
        records_by_section.setdefault(record.sh_info, []).append(record)

    for index, section in enumerate(elf.sections):
        if section.name != '.mwcats':
            continue
        records = records_by_section.get(index, ())
        targets = [symbols[relocation.symbol_index].st_shndx
                   for record in records for relocation in record.relocations]
        if not targets:
            continue
        dead = [0 < target < len(elf.sections) and elf.sections[target].name == DEAD
                for target in targets]
        if any(dead) and not all(dead):
            raise ValueError(f'.mwcats section {index} references both dead and live code')
        if not all(dead):
            continue
        section.sh_name = elf.add_sh_symbol(DEAD)
        section.name = DEAD
        for record in records:
            record.sh_name = elf.add_sh_symbol('.rel' + DEAD)
            record.name = '.rel' + DEAD


def retail_sections(elf, addresses, unit=None):
    """{section index: retail section name} for every section retail names."""
    out = {}
    ranges = layout.Layout(ROOT / layout.YAML).sections(unit) if unit else []
    for symbol in elf.symtab.symbols:
        index = symbol.st_shndx
        if not symbol.name or symbol.type == STT_SECTION or not (0 < index < len(elf.sections)):
            continue
        if symbol.st_value != 0:
            continue
        section = elf.sections[index]
        if not section.sh_flags & SHF_ALLOC or section.name == DEAD:
            continue
        address = address_of(symbol.name, addresses)
        if address is None:
            continue
        if (symbol.bind == STB_LOCAL and symbol.name.startswith("at_") and ranges
                and not any(lo <= address < hi for section_name, lo, hi in ranges)):
            continue
        name = layout.section_of(address)
        if name is None:
            raise ValueError(f"{symbol.name}: 0x{address:08X} is in no retail section")
        if out.get(index, name) != name:
            raise ValueError(f"section {index} holds symbols of {out[index]} and {name}")
        out[index] = name
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("object", type=Path)
    ap.add_argument("--order-only", action="store_true")
    args = ap.parse_args()

    elf = Elf(args.object.read_bytes())
    name_sections(elf)
    if args.order_only:
        order_sections(elf)
        args.object.write_bytes(elf.pack())
        return 0
    placeholder_sections = drop_placeholder_aliases(elf)
    anonymous = project_native_names(elf)
    vtable_sizes = {id(symbol): symbol.st_size for symbol in elf.symtab.symbols
                    if symbol.name.startswith('__vt__') and symbol.st_shndx not in placeholder_sections}
    name = args.object.name
    unit = None
    if name.endswith(".cpp.o"):
        object_path = args.object.resolve()
        parts = object_path.parts
        if 'obj' in parts:
            unit = '/'.join(parts[parts.index('obj') + 1:])[:-len('.cpp.o')]
        else:
            unit = name[:-len('.cpp.o')]
        native_extents = native_data_extents(elf, placeholder_sections)
        bind_named_static_bss(elf, unit, placeholder_sections)
        rename_dng_main_local_static(elf, unit)
        bind_local_data(elf, unit, placeholder_sections)
        name_literal_data(elf, unit, placeholder_sections,
                          padding_pieces=disassemble.Pieces())
        source = (ROOT / layout.Layout().source(unit)).read_text()
        import objdiff_data
        held = objdiff_data.fallback_data_names(source)
        materialize_alignment_fragments(elf, unit, placeholder_sections, native_extents,
                                        held=held)
        pad_data(elf, unit, placeholder_sections, native_extents=native_extents, held=held)
        bind_suffixed_references(elf, unit)
        pad_data(elf, unit, placeholder_sections, native_extents=native_extents, held=held)
        discard_external_vtables(elf, unit, placeholder_sections)
        discard_external_functions(elf, unit)
    discard_shadow_vtables(elf, placeholder_sections, native_sizes=vtable_sizes)
    fold_duplicates(elf)
    discard_unused_literals(elf)
    discard_dead_code_records(elf)
    # Temporary identities do not leave unused strings in discarded records.
    for symbol in anonymous:
        if (symbol in elf.symtab.symbols and 0 < symbol.st_shndx < len(elf.sections)
                and elf.sections[symbol.st_shndx].name != DEAD):
            symbol.st_name = elf.strtab.add_symbol(symbol.name)
    addresses = retail_addresses()
    renamed = retail_sections(elf, addresses, unit)

    for index, name in renamed.items():
        section = elf.sections[index]
        nobits = name in layout.NOBITS
        if nobits and section.sh_type == SHT_PROGBITS and index in placeholder_sections and not any(section.data):
            section.sh_size = len(section.data)
            section.sh_type = SHT_NOBITS
            section = BssSection(section.sh_name, section.sh_type, section.sh_flags,
                                 section.sh_addr, section.sh_offset, section.sh_size,
                                 section.sh_link, section.sh_info, section.sh_addralign,
                                 section.sh_entsize, b'')
            elf.sections[index] = section
        if nobits != (section.sh_type == SHT_NOBITS):
            raise ValueError(f"section {index} ({section.name}) cannot become {name}")
        section.sh_name = elf.add_sh_symbol(name)
        section.name = name
        section.sh_flags = FLAGS[name]
        if name not in CODE:
            section.sh_addralign = 1

    for index, section in enumerate(elf.sections):
        if (index not in renamed and section.name == ".rodata" and section.sh_flags & SHF_ALLOC
                and section.sh_addralign < RODATA_ALIGNMENT):
            section.sh_addralign = RODATA_ALIGNMENT

    for record in elf.relocations:
        if record.sh_info in renamed:
            record.sh_name = elf.add_sh_symbol(".rel" + renamed[record.sh_info])
            record.name = ".rel" + renamed[record.sh_info]

    empty = [s.name for s in elf.sections if s.sh_flags & SHF_ALLOC and s.name != DEAD
             and (s.sh_size if s.sh_type == SHT_NOBITS else len(s.data)) == 0]
    if empty:
        raise ValueError(f"zero-sized sections, which MWLD rejects: {empty}")

    for symbol in elf.symtab.symbols:
        if symbol.bind == STB_MWCC_COALESCED and symbol.type in (STT_FUNC, STT_OBJECT):
            symbol.bind = STB_WEAK

    order_sections(elf)

    args.object.write_bytes(elf.pack())
    return 0


if __name__ == "__main__":
    sys.exit(main())
