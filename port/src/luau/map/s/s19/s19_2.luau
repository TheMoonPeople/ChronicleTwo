--!strict
-- map/s/s19/s19_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0865c947 = require("@lib/event/helper_0865c947")
local helper_34ac0071 = require("@lib/event/helper_34ac0071")
local helper_3c5c511a = require("@lib/event/helper_3c5c511a")
local helper_4156933d = require("@lib/event/helper_4156933d")
local helper_41c448af = require("@lib/event/helper_41c448af")
local helper_474c5bc8 = require("@lib/event/helper_474c5bc8")
local helper_5b5625ad = require("@lib/event/helper_5b5625ad")
local helper_6ce9e84a = require("@lib/event/helper_6ce9e84a")
local helper_7eb64821 = require("@lib/event/helper_7eb64821")
local helper_7f001297 = require("@lib/event/helper_7f001297")
local helper_9273be40 = require("@lib/event/helper_9273be40")
local helper_9a21f55f = require("@lib/event/helper_9a21f55f")
local helper_b2196964 = require("@lib/event/helper_b2196964")
local helper_b8b453c5 = require("@lib/event/helper_b8b453c5")
local helper_b8c16789 = require("@lib/event/helper_b8c16789")

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

--- Helper function.
local function helper_241e0()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_474c5bc8(30)
		end
		if at <= 2 then
			helper_41c448af(0)
		end
	end
	event.ActchrSetDefMotion(0, 4)
	event.SetFadeOut(30)
	helper_474c5bc8(30)
	if vm.skipping() then
		return skip(1)
	end
	event.DngPause(1, 1)
	event.DelMonster(-1)
	helper_474c5bc8(30)
	if vm.skipping() then
		return skip(2)
	end
	event.Initialize()
	var0 = event.SndLoadSound(5, "snd2/mon/en_360.sound.json") or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetStatusbarShow(0, 1.0)
	event.LoadChara(5, "dungeon/monster/b07a.gltf", "b07a", 8)
	event.CharaActive(1, 8)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetFadeIn(15)
	event.SetCameraPos(-50.62, 42.66, 812.75)
	event.SetCameraRef(-50.82, 71.75, 656.03)
	event.CharaActive(0, 0)
	event.SndSePlay(var0, 24)
	event.ObjsSetPos(0, -50.62, 4.34, 553.77)
	event.ObjsSetRot(0, 0.0, 0.02, 0.0)
	event.ObjsSetMotion(0, "死に", 6)
	event.ObjsMotionWait(0)
	helper_41c448af(0)
	if vm.skipping() then
		return skip(3)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no ~= 2 then
		event.SetCameraPos(-21.21, 14.5, 728.16)
		event.SetCameraRef(-33.94, 17.9, 751.25)
	else
		event.SetCameraPos(8.06, 23.77, 675.07)
		event.SetCameraRef(-39.51, 29.49, 761.36)
	end
	event.CharaActive(1, 0)
	event.SetCharaPos(0, -40.07, 1.76, 766.47)
	event.SetCharaRot(0, 0.0, -3.12, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.DeleteChara(8)
	event.Finish()
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
				helper_9273be40()
				if not vm.skipping() then
					return landing1()
				end
			end
			return
		end
		if at <= 4 then
			if at <= 3 then
				helper_6ce9e84a()
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
			helper_7f001297()
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
			helper_9273be40()
			if vm.skipping() then
				return skip(2)
			end
			event.GotoEdit(75, 500)
			return
		end
		if flag_3 == 0 then
			var3 = event.GetSavedataEtc(2) or var3
			if var3 ~= 0 then
				helper_0865c947(1)
				if vm.skipping() then
					return skip(3)
				end
				helper_6ce9e84a()
				if vm.skipping() then
					return skip(4)
				end
				event.SetBitCtrl(1, 1)
				return
			else
				helper_9a21f55f()
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
			helper_7f001297()
			if vm.skipping() then
				return skip(7)
			end
		end
	else
		helper_7f001297()
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
	helper_9273be40()
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
			helper_4156933d()
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
	helper_4156933d()
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
	helper_6ce9e84a()
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
		event.MesMake_2(0, "Il faut donner ce poisson\n[UNI00e0] Shingala, et vite !")
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
	local t0 = helper_5b5625ad(0)
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
		event.MesMake_2(0, "Il faut donner ce poisson\n[UNI00e0] Shingala, et vite !")
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
	local t0 = helper_5b5625ad(1)
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
			helper_0865c947(0)
		end
		if at <= 3 then
			helper_4156933d()
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
	helper_0865c947(0)
	if vm.skipping() then
		return skip(3)
	end
	helper_4156933d()
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
	helper_241e0()
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
	event.MesMake_2(0, "Oh, non ! Shingala est mort... Et\nil devait nous aider [UNI00e0] restaurer le\nfutur...")
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
		"[(!)]Si tu frappes Shingala, il va\n   s'[UNI00e9]nerver et se pr[UNI00e9]cipiter sur toi.\n   Il aura la gueule grande ouverte et l[UNI00e0],<page>   tu auras l'occasion d'y jeter\n   le poisson [UNI00e9]lectris[UNI00e9] !"
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
				helper_7eb64821(0, 8610070)
			end
			return
		end
	end
	flag = event.GetFlag(416) or flag
	flag_2 = event.GetFlag(420) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		value = event.GetRandInt(100) or value
		if value < 50 then
			helper_7eb64821(0, 8610060)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_7eb64821(0, 8610070)
			if vm.skipping() then
				return skip(2)
			end
		end
		return
	end
	helper_b8c16789(0)
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
			helper_9273be40()
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
	helper_9273be40()
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
			helper_9a21f55f()
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
	helper_9a21f55f()
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
			helper_6ce9e84a()
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
	helper_6ce9e84a()
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
			helper_4156933d()
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
	helper_4156933d()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

return script
