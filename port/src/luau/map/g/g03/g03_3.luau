--!strict
-- map/g/g03/g03_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_07ef4c54 = require("@lib/event/helper_07ef4c54")
local helper_22f4340d = require("@lib/event/helper_22f4340d")
local helper_2f481f12 = require("@lib/event/helper_2f481f12")
local helper_32dba483 = require("@lib/event/helper_32dba483")
local helper_38d14d3a = require("@lib/event/helper_38d14d3a")
local helper_3e566142 = require("@lib/event/helper_3e566142")
local helper_50794d2a = require("@lib/event/helper_50794d2a")
local helper_51116d28 = require("@lib/event/helper_51116d28")
local helper_55f8d64c = require("@lib/event/helper_55f8d64c")
local helper_638d969d = require("@lib/event/helper_638d969d")
local helper_7e5e1a93 = require("@lib/event/helper_7e5e1a93")
local helper_8bbac5f2 = require("@lib/event/helper_8bbac5f2")
local helper_b027b809 = require("@lib/event/helper_b027b809")
local helper_b47b782d = require("@lib/event/helper_b47b782d")
local helper_cab9a899 = require("@lib/event/helper_cab9a899")
local helper_e2020895 = require("@lib/event/helper_e2020895")
local helper_e8f4b85c = require("@lib/event/helper_e8f4b85c")
local helper_ea79295f = require("@lib/event/helper_ea79295f")
local helper_ee8539bd = require("@lib/event/helper_ee8539bd")

--- Helper function.
local function helper_1aad4()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e2020895(0, -1, 5, 256, 208)
		end
	end
	event.Initialize()
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var3 = vm.f32(vm.f32(vm.sin(vm.f32(-1.39)) * 30.0) + var0)
	var4 = var1
	var5 = vm.f32(vm.f32(vm.cos(vm.f32(-1.39)) * 30.0) + var2)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsMove(0, var3, var4, var5, 30, 1)
	event.ObjsReference(0, var3, var4, var5, 10)
	event.ObjsSetMotion(0, "歩き")
	var6 = 0
	while var6 < 30 do
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		var1 = vm.f32(var1 + 30.0)
		event.SetCameraRef(var0, var1, var2)
		var6 = var6 + 1
		if vm.wait() then
			return skip(1)
		end
	end
	event.ObjsSetMotion(0, "立ち")
	event.SetMesWindowMode(0, 1)
	event.SetMesShippo(0, 0)
	event.MesMake_2(0, "Was war das f[UNI00fc]r ein Weinen eben?\nSehen wir zuerst in der\nH[UNI00f6]hle nach, ja?")
	helper_e2020895(0, -1, 5, 256, 208)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_10340(arg0: s32)
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			helper_e2020895(0, -1, 5, 0, 0)
		end
		helper_b47b782d()
	end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(612) or flag
	if flag == 0 then
		return
	end
	event.SetMesWindowMode(0, 12)
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetColor(0, 255, 255, 255, 255)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(20, 0)
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.SpriteSetDraw(0, 1)
	event.SetFadeIn(0)
	if vm.wait() then
		return skip(2)
	end
	if arg0 ~= 0 then
		event.MesMake_2(0, "Wir sind mit der Zeitreise-\nFunktion des Ixion in die\nZukunft gereist.")
	else
		event.MesMake_2(0, "Wir sind mit der Zeitreise-\nFunktion des Ixion in die\nGegenwart zur[UNI00fc]ckgekehrt.")
	end
	if vm.wait() then
		return skip(3)
	end
	helper_e2020895(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
	if vm.wait() then
		return skip(5)
	end
	event.SetFadeOut(0, 255.0, 255.0, 255.0)
	if vm.wait() then
		return skip(6)
	end
	helper_b47b782d()
end

--- Helper function.
local function helper_108c8(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32, arg5: s32)
	local flag: s32 = 0
	local now_party_chara_id: s32 = 0
	local active_chr_no: s32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_b027b809()
			end
			if at <= 2 then
				helper_638d969d()
			end
			if at <= 3 then
				helper_2f481f12(30)
			end
			if at <= 4 then
				helper_e8f4b85c(0)
			end
			if at <= 5 then
				helper_638d969d()
			end
			if at <= 6 then
				helper_e8f4b85c(6)
			end
			if at <= 7 then
				helper_2f481f12(60)
			end
			if at <= 8 then
				helper_2f481f12(60)
			end
			if at <= 9 then
				helper_10340(1)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		if flag ~= 0 then
			event.SndSeStop(var12, 0)
		else
			event.SndSeStop(var13, 0)
		end
		event.FadeOutBgm(30)
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 0 then
			event.DelExtMotion(0)
			event.DeleteChara(33)
		end
		if active_chr_no == 1 then
			event.DeleteChara(32)
		end
		now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
		if now_party_chara_id ~= -1 then
			event.DeleteChara(34)
		end
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.DeleteChara(38)
		event.DeleteChara(39)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	flag = event.GetFlag(612) or flag
	event.SetMotion(0, "立ち")
	if arg4 ~= 0 then
		event.SetLoadbgFile("event/time_gate/red/tg_maru_red.gltf", "event/time_gate/red/tg_sita_red.gltf")
	else
		event.SetLoadbgFile("event/time_gate/blue/tg_maru_blue.gltf", "event/time_gate/blue/tg_sita_blue.gltf")
	end
	event.CmrsInit()
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_b027b809()
	if vm.skipping() then
		return skip(2)
	end
	helper_638d969d()
	if vm.skipping() then
		return skip(3)
	end
	event.InitDramaScene()
	event.SetSkipBotton(20)
	event.SetSkipFcol(255.0, 255.0, 255.0)
	event.SetWorldCoord(arg0, arg1, arg2, arg3)
	event.SetCharaShow(120, 0)
	event.SetCharaShow(121, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	if arg4 ~= 0 then
		event.LoadChara(5, "event/time_gate/red/tg_maru_red.gltf", "info", 35)
		event.LoadChara(5, "event/time_gate/red/tg_sita_red.gltf", "info2", 36)
	else
		event.LoadChara(5, "event/time_gate/blue/tg_maru_blue.gltf", "info", 35)
		event.LoadChara(5, "event/time_gate/blue/tg_sita_blue.gltf", "info2", 36)
	end
	event.CharaActive(35)
	event.SetCharaType(35, 4)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, 0.0, 70.0, 0.0)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.CharaActive(36)
	event.SetCharaType(36, 4)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 0.0, 0.0, 0.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id ~= -1 then
		event.LoadCharaNpc(0, 5, now_party_chara_id, 34)
		event.CharaActive(34)
		event.EohSyncChara(2, 34)
		event.EohSetPos(2, 49.73999, 0.0, 8.969971)
		event.EohSetRot(2, 0.0, -1.76, 0.0)
	end
	if arg5 ~= 0 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 0 then
			event.GetEquipItemno(1, 2)
			event.GetEquipItemno(1, 3)
			event.GetEquipItemno(1, 4)
		end
		if active_chr_no == 1 then
			event.GetEquipItemno(0, 2)
			event.GetEquipItemno(0, 3)
			event.GetEquipItemno(0, 4)
		end
		if active_chr_no == 0 then
			if flag ~= 0 then
				event.LoadMotion(5, "event/e00/e80/e80_mints.gltf", "info", 0)
			else
				event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
			end
			event.CharaActive(0)
			event.EohSyncChara(0, 0)
			event.LoadChara(5, "chara/c02_base.gltf", "info", 33)
			event.CharaActive(33)
			event.EohSyncChara(1, 33)
			event.LoadEquip(5, 1, 4, "info", 33)
			event.LoadEquip(5, 1, 3, "info", 33)
			event.LoadEquip(5, 1, 2, "info", 33, 37)
			event.CharaActive(37)
			event.EohSyncChara(5, 37)
			event.EohSetShow(5, 1)
		end
		if active_chr_no == 1 then
			event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
			if flag ~= 0 then
				event.LoadMotion(5, "event/e00/e80/e80_mints.gltf", "info", 32)
			else
				event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 32)
			end
			event.CharaActive(32)
			event.EohSyncChara(0, 32)
			event.LoadEquip(5, 0, 4, "info", 32)
			event.LoadEquip(5, 0, 3, "info", 32)
			event.LoadEquip(5, 0, 2, "info", 32, 37)
			event.CharaActive(37)
			event.EohSyncChara(5, 37)
			event.EohSetShow(5, 1)
			event.CharaActive(0)
			event.EohSyncChara(1, 0)
		end
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 38.0, 0.0, 22.0)
		event.ObjsSetRot(0, 0.0, -2.12, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsTexAnime(0, 0)
		event.EohSetPos(1, 18.619995, 0.0, 35.179993)
		event.EohSetRot(1, 0.0, -2.48, 0.0)
		event.EohSetMotion(1, "立ち", 0.02)
		event.EohResetDaPosition(1)
	else
		event.GetEquipItemno(1, 2)
		event.GetEquipItemno(1, 3)
		event.GetEquipItemno(1, 4)
		event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
		event.LoadMotion(5, "event/e500/e523/e523_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 38.0, 0.0, 22.0)
		event.ObjsSetRot(0, 0.0, -2.12, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsTexAnime(0, 0)
	end
	if flag ~= 0 then
		var12 = event.SndLoadSound(8, "snd2/sp/sp_043.sound.json") or var12
	else
		var13 = event.SndLoadSound(8, "snd2/sp/sp_013.sound.json") or var13
	end
	if arg4 ~= 0 then
		event.SetLoadbgFile("event/time_gate/red/atora_shine.gltf", "event/time_gate/red/atora_glare.gltf")
	else
		event.SetLoadbgFile("event/time_gate/blue/atora_shine2.gltf", "event/time_gate/blue/atora_glare2.gltf")
	end
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "旧・立ち", 4)
	event.ObjsResetDaPosition(0)
	if flag ~= 0 then
		event.SndSePlay(var12, 0)
	else
		event.SndSePlay(var13, 0)
		helper_2f481f12(30)
		if vm.skipping() then
			return skip(4)
		end
	end
	event.SetFadeIn(30)
	if flag ~= 0 then
		event.CmrsSetPos(-56.29, 15.74, 3.56)
		event.CmrsSetRef(-12.65, 16.48, 2.06)
	else
		event.CmrsSetPos(-48.179993, 19.61, -28.70996)
		event.CmrsSetRef(-0.789978, 16.48, -0.05999756)
	end
	if arg5 == 0 and arg4 == 0 and flag == 0 then
		event.CmrsSetPos(-30.09, 19.5, 4.41)
		event.CmrsSetRef(-14.63, 21.71, 1.0)
	end
	event.ObjsSetMotion(0, "タイムワープ", 6, 0.45)
	event.ObjsNextMotion(0, "タイムワープL", 4)
	event.ObjsTexAnime(0, 1, "開閉口")
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_638d969d()
	if vm.skipping() then
		return skip(6)
	end
	if arg4 ~= 0 then
		event.LoadChara(5, "event/time_gate/red/atora_shine.gltf", "info", 38)
	else
		event.LoadChara(5, "event/time_gate/blue/atora_shine2.gltf", "info", 38)
	end
	if flag ~= 0 then
		event.CharaActive(0, 38)
	else
		event.CharaActive(1, 38)
	end
	event.EohSyncChara(6, 38)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	do
		local out1, out2, out3 = event.EohGetFramePos(0, "atoramiria")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	if arg4 ~= 0 then
		event.ObjsSetPos(6, pos_x, pos_y, pos_z)
	else
		event.ObjsSetPos(6, -3.54, 17.04, -1.46)
	end
	event.ObjsSetRot(6, -0.45, -2.12, 0.0)
	event.CmrsSetPos(-21.5, 23.92, -12.580017)
	event.CmrsSetRef(-0.789978, 16.17, -0.05999756)
	event.ObjsTexAnime(0, 0, "開閉口")
	event.ObjsTexAnime(0, 1, "開き口")
	event.ObjsSetMotion(0, "タイムワープL", 5)
	event.ObjsSetMotion(6, "発動", 6)
	event.ObjsNextMotion(6, "発動L", 4)
	if flag == 0 then
		helper_e8f4b85c(6)
		if vm.skipping() then
			return skip(7)
		end
	else
		event.SndSePlay(var12, 2)
	end
	if arg4 ~= 0 then
		event.LoadChara(5, "event/time_gate/red/atora_glare.gltf", "info", 39)
	else
		event.LoadChara(5, "event/time_gate/red/atora_glare.gltf", "info", 39)
	end
	event.CharaActive(39)
	event.EohSyncChara(7, 39)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.ObjsSetPos(7, 0.0, 0.0, 0.0)
	event.ObjsSetRot(7, 0.0, -2.12, 0.0)
	event.CmrsSetPos(-40.590027, 19.47, -24.339966)
	event.CmrsSetRef(13.950012, 15.23, 9.190002)
	event.CmrsMove2(-128.31, 19.47, -78.22998, 13.950012, 48.35, 9.190002, 90, 0, 0.4)
	event.ObjsSetScale(3, 2.8, 2.8, 2.8, 90)
	event.ObjsSetScale(4, 2.0, 2.0, 2.0, 90)
	event.ObjsSetScale(7, 2.0, 2.0, 2.0, 90)
	helper_2f481f12(60)
	if vm.skipping() then
		return skip(8)
	end
	event.SetFadeOut(60, 255.0, 255.0, 255.0)
	helper_2f481f12(60)
	if vm.skipping() then
		return skip(9)
	end
	helper_10340(1)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

--- Helper function.
local function helper_173d4(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local member: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_108c8(arg0, arg1, arg2, arg3, 1, 0)
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SetWorldCoord(0.0, 0.0, 0.0, 0.0)
	end
	member = event.JoinPartyMember(1) or member
	if member == 1 then
		helper_108c8(arg0, arg1, arg2, arg3, 1, 1)
		if vm.skipping() then
			return skip(1)
		end
	else
		helper_108c8(arg0, arg1, arg2, arg3, 1, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_3e566142

--- Program 100.
script[100] = function()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local old_sub_map_no: s32 = 0
	local var5: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local get_old_interior_map_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			var3 = 0
			helper_32dba483(-140.0, 165.0, 1865.0, vm.f32(2.28))
			var3 = 1
			helper_38d14d3a()
		end
		if at <= 2 then
			var3 = 1
			helper_07ef4c54()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 3 then
			helper_7e5e1a93()
		end
		if at <= 4 then
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			helper_7e5e1a93()
		end
		if at <= 5 then
			helper_ee8539bd(1)
		end
	end
	function part2()
		helper_ee8539bd(1)
		if vm.skipping() then
			return skip(6)
		end
	end
	function landing1()
		return part2()
	end
	helper_3e566142()
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		helper_32dba483(vm.f32(1832.4), vm.f32(-5.2), vm.f32(-406.6), vm.f32(-1.16))
		event.ResetCamera(1, 0.0, 10.0)
	else
		old_map_no = event.GetOldMapNo() or old_map_no
		var2 = event.GetMapType(old_map_no) or var2
		print("old_map = ", old_map_no, "\n")
		print("old_map_type = ", var2, "\n")
		if var2 ~= -1 then
			if var2 == 7 or var2 == 8 or old_map_no == 84 then
				helper_22f4340d()
				if vm.skipping() then
					return skip(1)
				end
			else
				var3 = 0
				if old_map_no == 82 then
					helper_32dba483(-140.0, 165.0, 1865.0, vm.f32(2.28))
					event.ResetCamera(1, 0.0, 10.0)
					event.SetFadeIn(30)
					var3 = 1
				end
				if old_map_no == 75 then
					helper_38d14d3a()
					if vm.skipping() then
						return skip(2)
					end
					var3 = 1
				end
				old_sub_map_no = event.GetOldSubmapNo() or old_sub_map_no
				var5 = event.GetMapType(old_sub_map_no) or var5
				if var3 == 0 and not (old_map_no == 2 and var5 == 2) then
					flag = event.GetFlag(402) or flag
					flag_2 = event.GetFlag(360) or flag_2
					if flag == 0 and flag_2 == 1 then
						helper_07ef4c54()
						if vm.skipping() then
							return skip(3)
						end
					else
						helper_7e5e1a93()
						if vm.skipping() then
							return skip(4)
						end
					end
				end
			end
		else
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			get_old_interior_map_no = event.GetOldInteriorMapNo() or get_old_interior_map_no
			if 0 <= get_old_interior_map_no then
			else
				helper_7e5e1a93()
				if vm.skipping() then
					return skip(5)
				end
			end
		end
	end
	return part2()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_7e5e1a93()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 201.
script[201] = function()
	local flag: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local var7: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_cab9a899()
		end
		if at <= 3 then
			helper_22f4340d()
		end
	end
	flag = event.GetFlag(404) or flag
	if flag == 0 then
		helper_1aad4()
		if vm.skipping() then
			return skip(1)
		end
	else
		local t0 = helper_cab9a899()
		if vm.skipping() then
			return skip(2)
		end
		if t0 ~= 0 then
			event.DngSetStageId(3)
			event.GotoMenu(3, 3)
			if vm.wait() then
				return skip(3)
			end
			do
				local _, out2, out3, _ = event.GetMenuParam_4()
				var2 = out2 or var2
				var3 = out3 or var3
			end
			if var3 == 0 then
				helper_22f4340d()
				if vm.skipping() then
					return skip(4)
				end
				return
			end
			if var3 == 20 then
				flag_2 = event.GetFlag(438) or flag_2
				flag_3 = event.GetFlag(444) or flag_3
				if flag_2 == 1 and flag_3 == 0 then
					event.GotoDng(3, var3, 1010)
				else
					var2 = 3
					var3 = 20
					var7 = event.GetFloorInfo(var2, var3, 7) or var7
					var7 = vm.i32(var7 + 1)
					event.SetFloorInfo(var2, var3, 7, var7)
					event.MapJump(-1, "d04b01", 100)
				end
			else
				flag_4 = event.GetFlag(406) or flag_4
				flag_5 = event.GetFlag(424) or flag_5
				if var3 == 2 and flag_4 == 0 or var3 == 17 and flag_5 == 0 or var3 == 19 then
					event.BgmLoadCancel()
				end
				event.GotoDng(3, var3, 1010)
			end
		end
	end
end

--- Program 202.
script[202] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_ea79295f()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		flag = event.GetFlag(404) or flag
		if flag == 0 then
			event.BgmLoadCancel()
		end
		event.MapJump(-1, "s27")
	end
end

--- Program 203.
script[203] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_50794d2a()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.MapJump(-1, "s09")
	end
end

--- Program 300.
script[300] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_173d4(vm.f32(-136.7), 165.0, vm.f32(1866.8), 0.0)
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "f03")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 310.
script[310] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ee8539bd(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_55f8d64c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3e566142()
	helper_51116d28()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3e566142()
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.SetCharaPos(0, 1425.7, 0.0, 1034.8)
	event.SetCharaRot(0, 0.0, -2.37, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.ResetCamera(1, 3.14, 10.0)
	event.SetFadeIn(30)
end

--- Program 520.
script[520] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = helper_8bbac5f2()
			helper_e2020895(0, -1, 8, 0, 0)
		end
		if at <= 2 then
			helper_ee8539bd(1)
		end
	end
	helper_3e566142()
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.SetCharaPos(0, -140.0, 165.0, 1800.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.ResetCamera(1, 3.14, 10.0)
	event.SetFadeIn(30)
	var0 = helper_8bbac5f2()
	if var0 == 0 then
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.MesMake_2(
			0,
			"[(!)]Erf[UNI00fc]lle die Georama-Bedingungen\n   und nimm das Zentral-Labor wieder\n   in Betrieb, um fortzufahren."
		)
		helper_e2020895(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMesPreset(0, 0)
	end
	helper_ee8539bd(1)
	if vm.skipping() then
		return skip(3)
	end
end

--- Program 14020.
script[14020] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3e566142()
	helper_07ef4c54()
	if vm.skipping() then
		return skip(1)
	end
end

return script
