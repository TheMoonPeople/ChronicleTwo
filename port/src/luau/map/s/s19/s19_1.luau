--!strict
-- map/s/s19/s19_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0858de06 = require("@lib/event/helper_0858de06")
local helper_34ac0071 = require("@lib/event/helper_34ac0071")
local helper_3c5c511a = require("@lib/event/helper_3c5c511a")
local helper_474c5bc8 = require("@lib/event/helper_474c5bc8")
local helper_4d759d26 = require("@lib/event/helper_4d759d26")
local helper_6b897f9c = require("@lib/event/helper_6b897f9c")
local helper_6c885b04 = require("@lib/event/helper_6c885b04")
local helper_8679ad6e = require("@lib/event/helper_8679ad6e")
local helper_b12ae5f0 = require("@lib/event/helper_b12ae5f0")
local helper_b2196964 = require("@lib/event/helper_b2196964")
local helper_b8b453c5 = require("@lib/event/helper_b8b453c5")
local helper_bb6cc3ff = require("@lib/event/helper_bb6cc3ff")
local helper_ceeb2253 = require("@lib/event/helper_ceeb2253")
local helper_e5d5457f = require("@lib/event/helper_e5d5457f")
local helper_f5bf5736 = require("@lib/event/helper_f5bf5736")

--- Program 99.
local function program_99()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.LoadSound(4684)
	flag = event.GetFlag(408) or flag
	flag_2 = event.GetFlag(420) or flag_2
	var2 = event.GetSavedataEtc(2) or var2
	if flag == 1 and flag_2 == 0 and var2 == 1 then
	else
		event.StopBgm(0)
		helper_474c5bc8(4)
		if vm.skipping() then
			return skip(1)
		end
		event.LoadBgm(167)
		event.PlayBgm(0)
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	local landing2: () -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_8679ad6e()
				if not vm.skipping() then
					return landing1()
				end
			end
			return
		end
		if at <= 4 then
			if at <= 3 then
				helper_6b897f9c()
				if not vm.skipping() then
					return landing2()
				end
			end
			return
		end
		if at <= 6 then
			if at <= 5 then
				helper_474c5bc8(6)
			end
			return
		end
		if at <= 7 then
			helper_6c885b04()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	function landing1()
		event.GotoEdit(75, 500)
	end
	function landing2()
		event.SetBitCtrl(1, 1)
	end
	program_99()
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(400) or flag
	flag_2 = event.GetFlag(408) or flag_2
	flag_3 = event.GetFlag(420) or flag_3
	if flag == 1 then
		if flag_2 == 0 then
			helper_8679ad6e()
			if vm.skipping() then
				return skip(2)
			end
			event.GotoEdit(75, 500)
			return
		end
		if flag_3 == 0 then
			var3 = event.GetSavedataEtc(2) or var3
			if var3 ~= 0 then
				helper_bb6cc3ff(1)
				if vm.skipping() then
					return skip(3)
				end
				helper_6b897f9c()
				if vm.skipping() then
					return skip(4)
				end
				event.SetBitCtrl(1, 1)
				return
			else
				helper_b12ae5f0()
				if vm.skipping() then
					return skip(5)
				end
				event.SoundAllStop()
				helper_474c5bc8(6)
				if vm.skipping() then
					return skip(6)
				end
				event.LoadBgm(18)
				event.LoadSound(4601)
				event.PlayBgm(0)
				event.LoadScript("d04/d04.stb", 1000)
				return
			end
		else
			helper_6c885b04()
			if vm.skipping() then
				return skip(7)
			end
		end
	else
		helper_6c885b04()
		if vm.skipping() then
			return skip(8)
		end
	end
	return part2()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_8679ad6e()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFadeIn(30)
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.SetCharaPos(0, -29.1, 1.4, 787.9)
	event.DngPause(17, 0)
	event.LoadMonsterFile(516, 1)
	event.LoadMonsterFile(1001, 0)
	event.AutoSetMonster(516, -50.0, -46.69, 202.57, 0.0, 0.0, 0.0)
	event.GetCharaPos(0)
	event.Finish()
end

--- Program 152.
script[152] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3c5c511a(64)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_3c5c511a(64)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 153.
script[153] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f5bf5736()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	event.DngPause(1, 1)
	event.SetFadeOut(0)
	event.DngPause(16, 1)
	helper_474c5bc8(30)
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeIn(30)
	event.DelMonster(-1)
	helper_f5bf5736()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 154.
script[154] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3c5c511a(64)
		end
	end
	event.SetCameraRef(-33.22, 3.88, 763.5)
	if vm.wait() then
		return skip(1)
	end
	helper_3c5c511a(64)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 155.
script[155] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_6b897f9c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 160.
script[160] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3c5c511a(64)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_3c5c511a(64)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 200.
script[200] = function()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			if at <= 2 then
				helper_b8b453c5(0, 21, 5, 256, 208)
			end
			return
		end
	end
	event.Initialize()
	var0 = event.GetBitCtrl(1) or var0
	if var0 == 1 then
		event.DngPause(9, 1)
		event.ActchrSetDefMotion(0)
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.MesMake_2(0, "You better feed this fish to\nShingala, and fast!!")
		helper_b8b453c5(0, -1, 5, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		event.DngPause(9, 0)
		return
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.SetMotion(0, "立ち")
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_b8b453c5(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		else
			helper_b8b453c5(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(3)
			end
		end
		event.Finish()
		return
	end
	local t0 = helper_4d759d26(0)
	if vm.skipping() then
		return skip(4)
	end
	if t0 ~= 0 then
		event.LoadScript("d04/d04.stb", 1000)
	end
end

--- Program 201.
script[201] = function()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local stage_id: s32 = 0
	local var3: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			if at <= 2 then
				helper_b8b453c5(0, 21, 5, 256, 208)
			end
			return
		end
		if at <= 4 then
			helper_474c5bc8(6)
		end
	end
	event.Initialize()
	var0 = event.GetBitCtrl(1) or var0
	if var0 == 1 then
		event.DngPause(9, 1)
		event.ActchrSetDefMotion(0)
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.MesMake_2(0, "You better feed this fish to\nShingala, and fast!!")
		helper_b8b453c5(0, -1, 5, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		event.DngPause(9, 0)
		return
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.SetMotion(0, "立ち")
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_b8b453c5(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		else
			helper_b8b453c5(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(3)
			end
		end
		event.Finish()
		return
	end
	local t0 = helper_4d759d26(1)
	if vm.skipping() then
		return skip(4)
	end
	if t0 ~= 0 then
		stage_id = event.DngGetStageId() or stage_id
		var3 = event.DngGetFloorId() or var3
		argc = event.GetNextFloor(var3, 0) or argc
		event.DngSetFloorId(argc)
		event.SetFloorInfo(stage_id, var3, 5, 2)
		event.SetFloorInfo(stage_id, argc, 5, 1)
		event.StopBgm(0)
		event.StopEnvBgm()
		event.SndStopSrc()
		helper_474c5bc8(6)
		if vm.skipping() then
			return skip(5)
		end
		event.LoadBgm(18)
		event.LoadSound(4601)
		event.PlayBgm(0)
		event.LoadScript("d04/d04.stb", 1000)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_bb6cc3ff(0)
		end
		if at <= 3 then
			helper_f5bf5736()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.BgmLoadCancel()
		event.GotoEdit(75, 100)
		if vm.wait() then
			return skip(5)
		end
	end
	event.Initialize()
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	event.DelMonster(-1)
	event.SetSavedataEtc(4)
	event.SetBitCtrl(1, 0)
	helper_bb6cc3ff(0)
	if vm.skipping() then
		return skip(3)
	end
	helper_f5bf5736()
	if vm.skipping() then
		return skip(4)
	end
	return part2()
end

--- Program 510.
script[510] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local argc: s32 = 0
	local battle_bgm_vol: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local debug_flag: s32 = 0
	local load_no: s32 = 0
	local boss_map: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 9 then
			if at <= 1 then
				var0 = 0
				helper_474c5bc8(30)
			end
			if at <= 2 then
				helper_34ac0071()
			end
			if at <= 3 then
				helper_474c5bc8(30)
			end
			if at <= 4 then
				helper_b8b453c5(0, -1, 8, 0, 0)
			end
			if at <= 5 then
				helper_474c5bc8(30)
			end
			if at <= 6 then
				helper_474c5bc8(120)
			end
			if at <= 7 then
				local _ = helper_b2196964(0)
			end
			if at <= 8 then
				debug_flag = 0
				helper_474c5bc8(30)
			end
			return 1
		end
		return 0
	end
	helper_0858de06()
	if vm.skipping() then
		return skip(1)
	end
	event.DngPause(1, 0)
	var0 = 0
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	event.DngPause(16384, 1)
	event.GetActiveBgmStatus(-1)
	var1 = event.GetEventInfoSndid(4) or var1
	argc = event.GetSeStatus(var1, 0) or argc
	battle_bgm_vol = event.GetBtlBgmVol() or battle_bgm_vol
	event.SndSeStop(var1, 0)
	event.StopBgm(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetLoadbgFile("snd2/bgm/bg_060.sound.json", "textures/dungeon/image/gameover/gameover_1.json")
	helper_474c5bc8(30)
	if vm.skipping() then
		return skip(2)
	end
	helper_34ac0071()
	if vm.skipping() then
		return skip(3)
	end
	event.LoadBgmPack(60)
	event.PlayBgm(0)
	helper_474c5bc8(30)
	if vm.skipping() then
		return skip(4)
	end
	event.DngPause(1, 1)
	event.DngCollisionAllClr()
	event.SetMesWindowMode(0, 8)
	event.MesMake_2(0, "Oh, no! Shingala's dead...\nBut we needed him to get the future back to normal...")
	helper_b8b453c5(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	block = event.LoadImg_4(5, "textures/dungeon/image/gameover/gameover_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "gameover1", block)
	event.SpriteSetColor(0, 128, 128, 128, 128)
	event.SpriteSetUvsize(0, 0, 0, 576, 128)
	event.SpriteSetPutsize(0, 576, 128)
	event.SpriteSetPos(0, -320, 208)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsMove(0, 288, 208, 0.0, 20)
	helper_474c5bc8(30)
	if vm.skipping() then
		return skip(6)
	end
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "gameover1", block)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 128, 576, 64)
	event.SpriteSetPutsize(1, 576, 64)
	event.SpriteSetPos(1, 256, 208)
	event.SpriteSetDraw(1, 1)
	event.EohSyncSprite(1, 1)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetColor(1, 128, 128, 128, 128, 120)
	helper_474c5bc8(120)
	if vm.skipping() then
		return skip(7)
	end
	while true do
		if helper_b2196964(0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(8)
			end
		end
	end
	debug_flag = event.GetDebugFlag() or debug_flag
	debug_flag = 0
	if debug_flag == 1 then
		event.DngDebugCommand(0)
		event.ActchrSetDefMotion(0, 4)
	else
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		helper_474c5bc8(30)
		if vm.skipping() then
			return skip(9)
		end
		if active_chr_no == 2 then
			event.EsmClear()
		end
		event.StopBgm(0)
		event.SpriteSetDraw(0, 0)
		event.SpriteSetDraw(1, 0)
		event.DelImg(0)
		if var0 == 1 then
			event.AddHpRate(1.0, 0)
			event.AddWhp(0, 999)
			event.AddWhp(1, 999)
			event.DngRunEvent(-1)
			event.DelMonster(-1)
			event.DngPause(1, 0)
			event.Finish()
			return 1
		else
			event.SetExitFlag(1)
			event.Finish()
			return 0
		end
	end
	event.StopBgm(0)
	helper_474c5bc8(4)
	if vm.skipping() then
		return skip(10)
	end
	load_no = event.GetBgmStatusNowNo() or load_no
	event.LoadBgm(load_no)
	event.SetActiveBgmStatus(-1)
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 0)
	event.DelImg(0)
	boss_map = event.DngCheckBossMap() or boss_map
	if boss_map ~= 1 then
		if argc == 1 then
			event.SndSePlay(var1, 0)
			event.SndSetSeVol(var1, 0, battle_bgm_vol)
		end
	end
	event.SetCameraCtrl(1)
	event.SetStatusbarShow(1, 1.0)
	if debug_flag ~= 1 then
		event.SetFadeIn(30)
	end
	event.DngPause(16385, 0)
	event.Finish()
	return 0
end

--- Program 550.
script[550] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.DngPause(3, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(
		0,
		"[(!)]If you hurt Shingala, he'll get angry\n   and head right for you.\n   He'll have his mouth wide open then,<page>   so that'll be your chance to throw\n   the Electric Fish right in!"
	)
	helper_b8b453c5(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(3, 0)
	event.Finish()
end

--- Program 1200.
script[1200] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local value: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_e5d5457f(0, 8610070)
			end
			return
		end
	end
	flag = event.GetFlag(416) or flag
	flag_2 = event.GetFlag(420) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		value = event.GetRandInt(100) or value
		if value < 50 then
			helper_e5d5457f(0, 8610060)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_e5d5457f(0, 8610070)
			if vm.skipping() then
				return skip(2)
			end
		end
		return
	end
	helper_ceeb2253(0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Program 14080.
script[14080] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8679ad6e()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.ResetEventTrg()
		event.GotoEdit(75, 500)
	end
	event.SetFadeOut(0)
	event.SetFlag(400, 1)
	event.SetFlag(402, 1)
	event.SetFlag(404, 1)
	event.SetFlag(406, 1)
	event.SetFlag(408, 0)
	program_99()
	if vm.skipping() then
		return skip(1)
	end
	helper_8679ad6e()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 14100.
script[14100] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b12ae5f0()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	event.SetFlag(400, 1)
	event.SetFlag(402, 1)
	event.SetFlag(404, 1)
	event.SetFlag(406, 1)
	event.SetFlag(408, 1)
	event.SetFlag(410, 0)
	program_99()
	if vm.skipping() then
		return skip(1)
	end
	helper_b12ae5f0()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 14160.
script[14160] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_6b897f9c()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	program_99()
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(400, 1)
	event.SetFlag(402, 1)
	event.SetFlag(404, 1)
	event.SetFlag(406, 1)
	event.SetFlag(408, 1)
	helper_6b897f9c()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 14200.
script[14200] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f5bf5736()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.ResetEventTrg()
		event.BgmLoadCancel()
		event.GotoEdit(75, 100)
		if vm.wait() then
			return skip(3)
		end
	end
	event.SetFlag(400, 1)
	event.SetFlag(402, 1)
	event.SetFlag(404, 1)
	event.SetFlag(406, 1)
	event.SetFlag(408, 1)
	event.SetFlag(416, 1)
	program_99()
	if vm.skipping() then
		return skip(1)
	end
	helper_f5bf5736()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

return script
