--!strict
-- map/d/d04/b01/d04b01_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_05ce8bed = require("@lib/event/helper_05ce8bed")
local helper_06be3d41 = require("@lib/event/helper_06be3d41")
local helper_2f481f12 = require("@lib/event/helper_2f481f12")
local helper_32dba483 = require("@lib/event/helper_32dba483")
local helper_33e0e88d = require("@lib/event/helper_33e0e88d")
local helper_345547bb = require("@lib/event/helper_345547bb")
local helper_388bfdd0 = require("@lib/event/helper_388bfdd0")
local helper_5cf27d8b = require("@lib/event/helper_5cf27d8b")
local helper_62073482 = require("@lib/event/helper_62073482")
local helper_7d755610 = require("@lib/event/helper_7d755610")
local helper_7d7eee8f = require("@lib/event/helper_7d7eee8f")
local helper_801114c3 = require("@lib/event/helper_801114c3")
local helper_8e96a195 = require("@lib/event/helper_8e96a195")
local helper_92bc9bbd = require("@lib/event/helper_92bc9bbd")
local helper_975561a4 = require("@lib/event/helper_975561a4")
local helper_afc36ef3 = require("@lib/event/helper_afc36ef3")
local helper_b9f5404c = require("@lib/event/helper_b9f5404c")
local helper_baeaba52 = require("@lib/event/helper_baeaba52")
local helper_d2b0d438 = require("@lib/event/helper_d2b0d438")
local helper_e8f4b85c = require("@lib/event/helper_e8f4b85c")
local helper_ea1a74f3 = require("@lib/event/helper_ea1a74f3")
local helper_f86d86cb = require("@lib/event/helper_f86d86cb")
local helper_ff960c0e = require("@lib/event/helper_ff960c0e")

--- Program 99.
local function program_99()
	local flag: s32 = 0
	local flag_2: s32 = 0
	event.StopBgm(0)
	helper_f86d86cb()
	flag = event.GetFlag(438) or flag
	flag_2 = event.GetFlag(444) or flag_2
	event.EohSyncObj(0, "p01_battleship")
	if flag == 1 and flag_2 == 0 then
		event.EohSetShow(0, 1)
	else
		event.EohSetShow(0, 0)
	end
end

--- Helper function.
local function helper_31e34(arg0: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local player_chara: s32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var13: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local angle: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local angle_2: f32 = 0
	local angle_3: f32 = 0
	local angle_4: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local value: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e8f4b85c(0)
		end
		if at <= 2 then
			helper_ea1a74f3(0, -1, 6, 170, 0)
		end
		if at <= 3 then
			helper_e8f4b85c(0)
		end
	end
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.GetCameraRef()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	player_chara = event.GetControlChrid() or player_chara
	do
		local out1, out2, out3 = event.GetCharaPos(player_chara)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, _, out3 = event.GetCharaPos(arg0)
		var11 = out1 or var11
		var13 = out3 or var13
	end
	do
		local _, out2, _ = event.GetCharaRot(player_chara)
		var17 = out2 or var17
	end
	var18 = event.GetRotLookPos(var11 - var8, var13 - var10) or var18
	angle = vm.f32(var18 - var17)
	angle = event.AngleLimit(angle) or angle
	do
		local _, out2, _ = event.GetCharaRot(arg0)
		var20 = out2 or var20
	end
	var21 = event.GetRotLookPos(var8 - var11, var10 - var13) or var21
	angle_2 = vm.f32(var21 - var20)
	angle_2 = event.AngleLimit(angle_2) or angle_2
	if -0.5 < angle and angle < 0.5 then
		event.SetMotion(player_chara, "立ち")
	else
		event.SetMotion(player_chara, "歩き")
	end
	if -0.5 < angle_2 and angle_2 < 0.5 then
	else
		event.SetMotion(arg0, "歩き")
	end
	event.CmrsInit()
	if arg0 == 13 or arg0 == 14 or arg0 == 15 then
		event.CmrsSetRef(var8, var9 + 63.0, var10)
		angle_3 = vm.f32(var21 - vm.f32(0.73))
		angle_3 = event.AngleLimit(angle_3) or angle_3
		event.CmrsSetAhd(angle_3, 41.5, 179.0)
	else
		event.CmrsSetRef(var8, var9 + 130.0, var10)
		angle_4 = vm.f32(var21 - vm.f32(0.73))
		angle_4 = event.AngleLimit(angle_4) or angle_4
		event.CmrsSetAhd(angle_4, 45.0, 468.0)
	end
	var25 = 0.0
	var26 = vm.f32(helper_baeaba52(helper_05ce8bed(angle), helper_05ce8bed(angle_2)) * 8.0)
	while var25 < var26 do
		var27 = helper_ff960c0e(0.0, angle, var25, var26)
		var27 = vm.f32(var27 + var17)
		event.SetCharaRot(player_chara, 0.0, var27, 0.0)
		var28 = helper_ff960c0e(0.0, angle_2, var25, var26)
		var28 = vm.f32(var28 + var20)
		event.SetCharaRot(arg0, 0.0, var28, 0.0)
		var25 = vm.f32(var25 + 1.0)
		if vm.wait() then
			return skip(1)
		end
	end
	event.SetCharaRot(player_chara, 0.0, var18, 0.0)
	event.SetMotion(player_chara, "立ち")
	event.EohSyncChara(0, arg0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetRot(0, 0.0, var21, 0.0)
	event.ObjsSetMotion(0, "会話入り", 6)
	event.ObjsNextMotion(0, "会話L", 4)
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Bonjouuuur.\nBeau temps, non ?")
	if arg0 == 8 then
		event.MesMake_2(
			0,
			"On dirait que [UNI00e7]a pourrait aussi \nmarcher sur mes blessures.\nVas-y, gu[UNI00e9]ris-moi !"
		)
	end
	if arg0 == 9 then
		event.MesMake_2(0, "Bienvenue au village des Shiguras. \nJe vous souhaite un bon s[UNI00e9]jour.")
	end
	if arg0 == 10 then
		event.MesMake_2(0, "C'est le chef de notre village.\nAlors soyez polis, je vous prie.")
	end
	if arg0 == 11 then
		event.MesMake_2(
			0,
			"Nous sommes un peuple migrateur,\net chaque ann[UNI00e9]e, nous faisons un\nlong voyage pour venir jusqu'ici."
		)
	end
	if arg0 == 12 then
		event.MesMake_2(0, "C'est ici que nous nous reposons\nde notre long voyage. Alors ne\nfaites pas de bruit...")
	end
	if arg0 == 13 or arg0 == 14 or arg0 == 15 then
		value = event.GetRandInt(10) or value
		if value == 0 then
			event.MesMake_2(0, "Aiaa[UNI00ef][UNI00ef][UNI00ef] !")
		end
		if value == 1 then
			event.MesMake_2(0, "Aa[UNI00ef][UNI00ef][UNI00ef][UNI00ef][UNI00ef][UNI00ef]")
		end
		if value == 2 then
			event.MesMake_2(0, "Erraaah")
		end
		if value == 3 then
			event.MesMake_2(0, "Aaaa[UNI00ef] !")
		end
		if value == 4 then
			event.MesMake_2(0, "Ooh oh ooohhhhh !")
		end
		if value == 5 then
			event.MesMake_2(0, "Raaaaargh")
		end
		if value == 6 then
			event.MesMake_2(0, "Rouuwwwouuu")
		end
		if value == 7 then
			event.MesMake_2(0, "Rouuwwww")
		end
		if value == 8 then
			event.MesMake_2(0, "Raaaahr ?")
		end
		if value == 9 then
			event.MesMake_2(0, "Raaaahr !")
		end
	end
	helper_ea1a74f3(0, -1, 6, 170, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "会話戻り", 2)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(4)
	end
	event.Finish()
	event.SetCameraPos(pos_x, pos_y, pos_z)
	event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
	event.SetCrossfade(10)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local mc_load: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
		if at <= 4 then
			helper_32dba483(250.0, 0.0, 250.0, 0.0)
			return
		end
	end
	program_99()
	event.SetFadeOut(0)
	event.SetBitCtrl(16, 1)
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		helper_7d7eee8f(1900.0, 0.0, -330.0, 0.0)
		event.ResetCamera(1, 3.14, 10.0)
		event.SetFadeIn(30)
		return
	end
	flag = event.GetFlag(400) or flag
	if flag == 1 then
		flag_2 = event.GetFlag(438) or flag_2
		flag_3 = event.GetFlag(432) or flag_3
		flag_4 = event.GetFlag(436) or flag_4
		flag_5 = event.GetFlag(444) or flag_5
		if flag_2 == 0 and (flag_3 == 0 and flag_4 == 0) then
			argc = event.GetItemHaveNum(373) or argc
			if argc >= 1 then
				helper_92bc9bbd()
				if vm.skipping() then
					return skip(1)
				end
				return
			else
				helper_975561a4()
				if vm.skipping() then
					return skip(2)
				end
				return
			end
		end
		if flag_2 == 1 and flag_5 == 0 then
			event.SetBitCtrl(16, 0)
			helper_d2b0d438()
			if vm.skipping() then
				return skip(3)
			end
			if vm.wait() then
				return skip(4)
			end
			event.SetBitCtrl(1, 1)
			event.LoadMonsterFile(514, 1)
			event.LoadMonsterFile(522, 0)
			event.AutoSetMonster(
				514,
				250.0 + vm.f32(vm.sin(vm.f32(-2.617994)) * 450.0),
				0.0,
				250.0 + vm.f32(vm.cos(vm.f32(-2.617994)) * 450.0),
				0.0,
				0.5235988,
				0.0
			)
			event.AutoSetMonster(
				514,
				250.0 + vm.f32(vm.sin(vm.f32(-1.5707964)) * 450.0),
				0.0,
				250.0 + vm.f32(vm.cos(vm.f32(-1.5707964)) * 450.0),
				0.0,
				1.5707964,
				0.0
			)
			event.AutoSetMonster(
				514,
				250.0 + vm.f32(vm.sin(vm.f32(-0.5235988)) * 450.0),
				0.0,
				250.0 + vm.f32(vm.cos(vm.f32(-0.5235988)) * 450.0),
				0.0,
				2.617994,
				0.0
			)
			event.AutoSetMonster(
				514,
				250.0 + vm.f32(vm.sin(vm.f32(0.5235988)) * 450.0),
				0.0,
				250.0 + vm.f32(vm.cos(vm.f32(0.5235988)) * 450.0),
				0.0,
				-2.617994,
				0.0
			)
			event.AutoSetMonster(
				514,
				250.0 + vm.f32(vm.sin(vm.f32(1.5707964)) * 450.0),
				0.0,
				250.0 + vm.f32(vm.cos(vm.f32(1.5707964)) * 450.0),
				0.0,
				-1.5707964,
				0.0
			)
			event.AutoSetMonster(
				514,
				250.0 + vm.f32(vm.sin(vm.f32(2.617994)) * 450.0),
				0.0,
				250.0 + vm.f32(vm.cos(vm.f32(2.617994)) * 450.0),
				0.0,
				-0.5235988,
				0.0
			)
			event.AutoSetMonster(522, 186.17, 130.0, 141.45)
			helper_32dba483(250.0, 0.0, 250.0, 0.0)
			event.SetCameraRef(250.0, 30.0, 250.0)
			event.SetCameraPos(250.0, 40.0, 130.0)
			event.ResetCamera(0)
			event.SetFadeIn(30)
			event.Finish()
			return
		end
	end
	helper_62073482()
	if vm.skipping() then
		return skip(5)
	end
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_92bc9bbd()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 170.
script[170] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_06be3d41(64)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_06be3d41(64)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 200.
script[200] = function()
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			return
		end
	end
	local t0 = helper_33e0e88d()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.DngSetStageId(3)
		event.GotoMenu(3, 3)
		if vm.wait() then
			return skip(2)
		end
		do
			local _, _, out3, _ = event.GetMenuParam_4()
			var2 = out3 or var2
		end
		if var2 == 20 then
			event.SetFadeIn(30)
			return
		end
		helper_7d755610()
		event.SetBitCtrl(16, 0)
		if var2 == 0 then
			event.MapJump(-1, "g03", 100)
		else
			event.GotoDng(3, var2, 1010)
		end
		if vm.wait() then
			return skip(3)
		end
		return
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_388bfdd0()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 501.
script[501] = function()
	local stage_id: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_801114c3()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SubItem(373)
		event.SetBitCtrl(16, 0)
		event.SetBitCtrl(1, 0)
		event.GotoEdit(2, 520)
		if vm.wait() then
			return skip(3)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(1)
	end
	event.DelMonster(-1)
	stage_id = event.DngGetStageId() or stage_id
	var1 = event.DngGetFloorId() or var1
	event.SetFloorInfo(stage_id, var1, 5, 2)
	helper_801114c3()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_b9f5404c()
	if vm.skipping() then
		return skip(1)
	end
	event.SetCharaPos(0, 400.0, 0.0, 30.0)
	event.SetFadeIn(30)
	event.ResetCamera(0)
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local argc: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
	end
	var0 = 0
	var1 = event.GetEventData_2(9) or var1
	var2 = event.PlacePartsNameStrcmp(var1, "p01_otona") or var2
	if var2 == 0 then
		var0 = 8
	end
	var2 = event.PlacePartsNameStrcmp(var1, "p01_otona-1") or var2
	if var2 == 0 then
		var0 = 9
	end
	var2 = event.PlacePartsNameStrcmp(var1, "p01_otona-2") or var2
	if var2 == 0 then
		var0 = 10
	end
	var2 = event.PlacePartsNameStrcmp(var1, "p01_otona-3") or var2
	if var2 == 0 then
		var0 = 11
	end
	var2 = event.PlacePartsNameStrcmp(var1, "p01_otona-4") or var2
	if var2 == 0 then
		var0 = 12
	end
	var2 = event.PlacePartsNameStrcmp(var1, "p01_kodomo") or var2
	if var2 == 0 then
		var0 = 13
	end
	var2 = event.PlacePartsNameStrcmp(var1, "p01_kodomo-1") or var2
	if var2 == 0 then
		var0 = 14
	end
	var2 = event.PlacePartsNameStrcmp(var1, "p01_kodomo-2") or var2
	if var2 == 0 then
		var0 = 15
	end
	if var0 == 0 then
		return
	end
	argc = event.GetItemHaveNum(373) or argc
	if argc <= 0 then
		helper_afc36ef3(var0)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	if var0 == 8 then
		flag = event.GetFlag(434) or flag
		if flag == 0 then
			event.AddItem(375)
			helper_5cf27d8b()
			if vm.skipping() then
				return skip(2)
			end
			return
		end
	end
	helper_31e34(var0)
	if vm.skipping() then
		return skip(3)
	end
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
				helper_345547bb(0, 8620070)
			end
			return
		end
	end
	flag = event.GetFlag(440) or flag
	flag_2 = event.GetFlag(444) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		value = event.GetRandInt(100) or value
		if value < 50 then
			helper_345547bb(0, 8620060)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_345547bb(0, 8620070)
			if vm.skipping() then
				return skip(2)
			end
		end
		return
	end
	helper_8e96a195(0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Program 14400.
script[14400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(438, 1)
	program_99()
	helper_d2b0d438()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 14440.
script[14440] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_801114c3()
	if vm.skipping() then
		return skip(1)
	end
	event.GotoEdit(2, 520)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 24020.
script[24020] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2f481f12(4)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.StopBgm(0)
	helper_2f481f12(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(34)
	event.PlayBgm(0)
	event.LoadMonsterFile(514, 1)
	event.LoadMonsterFile(522, 0)
	event.AutoSetMonster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(-2.617994)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(-2.617994)) * 450.0),
		0.0,
		0.5235988,
		0.0
	)
	event.AutoSetMonster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(-1.5707964)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(-1.5707964)) * 450.0),
		0.0,
		1.5707964,
		0.0
	)
	event.AutoSetMonster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(-0.5235988)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(-0.5235988)) * 450.0),
		0.0,
		2.617994,
		0.0
	)
	event.AutoSetMonster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(0.5235988)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(0.5235988)) * 450.0),
		0.0,
		-2.617994,
		0.0
	)
	event.AutoSetMonster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(1.5707964)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(1.5707964)) * 450.0),
		0.0,
		-1.5707964,
		0.0
	)
	event.AutoSetMonster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(2.617994)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(2.617994)) * 450.0),
		0.0,
		-0.5235988,
		0.0
	)
	event.AutoSetMonster(522, 186.17, 130.0, 141.45)
	if vm.wait() then
		return skip(3)
	end
	event.Finish()
end

return script
