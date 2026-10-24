--!strict
-- map/s/s61/s61_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_17a6d269 = require("@lib/event/helper_17a6d269")
local helper_2384101b = require("@lib/event/helper_2384101b")
local helper_24d1805d = require("@lib/event/helper_24d1805d")
local helper_2ba993e3 = require("@lib/event/helper_2ba993e3")
local helper_2ce9c3c3 = require("@lib/event/helper_2ce9c3c3")
local helper_3735c566 = require("@lib/event/helper_3735c566")
local helper_42651a24 = require("@lib/event/helper_42651a24")
local helper_42da9aa6 = require("@lib/event/helper_42da9aa6")
local helper_52a96d71 = require("@lib/event/helper_52a96d71")
local helper_6d4d2398 = require("@lib/event/helper_6d4d2398")
local helper_86ccaca9 = require("@lib/event/helper_86ccaca9")
local helper_8980cad2 = require("@lib/event/helper_8980cad2")
local helper_aadfd919 = require("@lib/event/helper_aadfd919")
local helper_c760475c = require("@lib/event/helper_c760475c")
local helper_d797a244 = require("@lib/event/helper_d797a244")
local helper_e9655638 = require("@lib/event/helper_e9655638")
local helper_f3a90693 = require("@lib/event/helper_f3a90693")
local helper_fc1fa664 = require("@lib/event/helper_fc1fa664")

--- Program 99.
local function program_99()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_d797a244()
		end
	end
	event.LoadSound(8694)
	var0 = event.GetCnt(17) or var0
	if bit32.band(var0, 1) == 0 or bit32.band(var0, 2) == 0 then
		event.StopBgm(0)
		helper_8980cad2(4)
		if vm.skipping() then
			return skip(1)
		end
		event.LoadBgm(190)
		event.PlayBgm(0)
	else
		event.SetLoadbgFile("snd2/bgm/bg_193.sound.json")
		helper_d797a244()
		if vm.skipping() then
			return skip(2)
		end
		event.LoadBgmPack(193)
		event.PlayBgm(0)
	end
end

--- Helper function.
local function helper_28ef0()
	local var0: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 2 then
				var0 = 0
				var0 = var0 + 1
				helper_2384101b()
			end
			if at <= 3 then
				helper_8980cad2(30)
			end
			if at <= 4 then
				helper_2ce9c3c3(0)
			end
			if at <= 5 then
				helper_2ce9c3c3(1)
			end
			if at <= 6 then
				helper_8980cad2(30)
			end
			if at <= 7 then
				helper_8980cad2(30)
			end
			if vm.skip_end() then
				return skip(9)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CharaActive(1, 0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.SpriteSetDraw(0, 0)
		event.DelImg(0)
		event.SetFadeIn(30)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	if vm.wait() then
		return skip(2)
	end
	var1 = event.SndLoadSound(5, "snd2/mon/en_008.sound.json") or var1
	event.AssignStack(5)
	event.ClearStack(5)
	event.CharaActive(0, 0)
	event.ChangeDir("dungeon/monster/")
	event.LoadChara(5, "e202d.gltf", "e202d", 8)
	event.CopyChara(5, 8, 9)
	var0 = 0
	while var0 < 2 do
		event.CharaActive(1, 8 + var0)
		event.EohSyncChara(0 + var0, 8 + var0)
		event.ObjsInit(0 + var0)
		event.ObjsSyncObj(0 + var0, 0 + var0)
		event.EohSetSoundId(0 + var0, var1)
		var0 = var0 + 1
	end
	event.ChangeDir("")
	block = event.LoadImg_4(5, "textures/event/e800/d07domari/d07domari01_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "d07domari01", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 256, 312)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(6, 0)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.InitDramaScene()
	event.SetFadeIn(30)
	event.ObjsSetPos(0, -36.58, 0.0, 153.99)
	event.ObjsSetRot(0, 0.0, 2.92, 0.0)
	event.ObjsSetPos(1, 30.72, 0.0, 154.46)
	event.ObjsSetRot(1, 0.0, -2.88, 0.0)
	event.ObjsSetMotion(0, "立ち", 0)
	event.ObjsSetMotion(1, "立ち", 0)
	event.CmrsSetPos(-6.83, 70.86, -98.29)
	event.CmrsSetRef(-5.15, 18.65, -28.34)
	event.CmrsMove2(-3.71, 16.94, 31.66, -2.03, 28.09, 101.61, 30, 0, 0.4)
	helper_2384101b()
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "攻撃１", 6)
	event.ObjsNextMotion(0, "立ち", 0)
	event.ObjsSetMotion(1, "攻撃１", 6)
	event.ObjsNextMotion(1, "立ち", 0)
	event.ObjsSetColor(6, 128, 128, 128, 128, 30)
	helper_8980cad2(30)
	if vm.skipping() then
		return skip(4)
	end
	helper_2ce9c3c3(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_2ce9c3c3(1)
	if vm.skipping() then
		return skip(6)
	end
	helper_8980cad2(30)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeOut(30)
	helper_8980cad2(30)
	if vm.skipping() then
		return skip(8)
	end
	return part2()
end

--- Helper function.
local function helper_2a060()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.LoadMonsterFile(7, 1)
	event.AutoSetMonster(7, 38.17, 0.0, 157.66, -2.88)
	event.AutoSetMonster(7, -28.88, 0.0, 155.99, 2.92)
	event.DngPause(16384, 1)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_28ef0()
			if not vm.skipping() then
				return landing1()
			end
		end
		var0 = vm.i32(bit32.bor(var0, 1))
		helper_2a060()
		helper_c760475c(0.0, 0.0, -800.0, 0.0)
	end
	function part2()
		helper_c760475c(0.0, 0.0, -800.0, 0.0)
		event.SetCameraRef(0.0, 30.0, -800.0)
		event.SetCameraPos(0.0, 40.0, -920.0)
		event.ResetCamera(0)
		event.SetFadeIn(30)
		event.Finish()
	end
	function landing1()
		var0 = event.GetCnt(20) or var0
		var0 = vm.i32(bit32.bor(var0, 1))
		event.SetCnt(20, var0)
		helper_2a060()
		return part2()
	end
	program_99()
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	if vm.wait() then
		return skip(2)
	end
	var0 = event.GetCnt(17) or var0
	if bit32.band(var0, 1) == 0 or bit32.band(var0, 2) == 0 then
		var0 = event.GetCnt(20) or var0
		if bit32.band(var0, 1) == 0 then
			helper_28ef0()
			if vm.skipping() then
				return skip(3)
			end
			var0 = event.GetCnt(20) or var0
			var0 = vm.i32(bit32.bor(var0, 1))
			event.SetCnt(20, var0)
		end
		helper_2a060()
	end
	return part2()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3735c566(64)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_3735c566(64)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 160.
script[160] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_3735c566(64)
		end
	end
	helper_28ef0()
	if vm.skipping() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	helper_3735c566(64)
	if vm.skipping() then
		return skip(3)
	end
end

--- Program 170.
script[170] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3735c566(64)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_3735c566(64)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 200.
script[200] = function()
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.AddItem(305, 1)
	event.AddItem(306, 1)
	argc = event.GetItemHaveNum(10) or argc
	if argc <= 0 then
		event.AddItem(10, 1)
	end
	argc = event.GetItemHaveNum(302) or argc
	if argc <= 0 then
		event.AddItem(302, 1)
	end
	event.SetFlag(220, 1)
	event.SetFlag(317, 1)
	event.DelMonster(-1)
	event.Finish()
end

--- Program 300.
script[300] = function()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_f3a90693(0, 21, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			helper_8980cad2(30)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_f3a90693(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_f3a90693(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return
	end
	var1 = helper_52a96d71(2, -1)
	if vm.skipping() then
		return skip(3)
	end
	if var1 == 0 then
		event.DngPause(16384, 0)
		event.SetFadeOut(30)
		helper_8980cad2(30)
		if vm.skipping() then
			return skip(4)
		end
		event.DelMonster(-1)
		event.LoadScript("d07/d07.stb", 1000)
	else
		event.Finish()
	end
end

--- Program 1100.
script[1100] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var1 = vm.i32(bit32.bor(var1, 1))
		var2 = vm.i32(bit32.bor(var2, 2))
	end
	var0 = helper_6d4d2398()
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 207 then
		var1 = event.GetCnt(17) or var1
		var1 = vm.i32(bit32.bor(var1, 1))
		event.SetCnt(17, var1)
	end
	if var0 == 198 then
		var2 = event.GetCnt(17) or var2
		var2 = vm.i32(bit32.bor(var2, 2))
		event.SetCnt(17, var2)
	end
end

--- Program 1120.
script[1120] = function()
	local active_chr_no: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var11: s32 = 0
	local weight: f32 = 0
	local var14: f32 = 0
	local now_party_chara_id: s32 = 0
	local var17: s32 = 0
	local var18: s32 = 0
	local var19: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local pos_x_4: f32 = 0
	local pos_y_4: f32 = 0
	local pos_z_4: f32 = 0
	local var26: f32 = 0
	local value: s32 = 0
	local angle: f32 = 0
	local value_2: s32 = 0
	local var30: s32 = 0
	local var31: f32 = 0
	local var32: s32 = 0
	local result: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_f3a90693(0, 23, 8, 0, 0)
			end
			var1 = vm.f32(vm.f32(vm.sin(yaw) * 25.0) + pos_x)
			var2 = pos_y
			var3 = vm.f32(vm.f32(vm.cos(yaw) * 25.0) + pos_z)
			return
		end
		if at <= 3 then
			helper_e9655638()
			helper_d797a244()
		end
		if at <= 5 then
			helper_d797a244()
		end
		if at <= 6 then
			var14 = vm.f32(var14 - vm.f32(3.1415927))
			var18 = 0
			var19 = vm.f32(0.6)
			var14 = vm.f32(var14 + var19)
			helper_42651a24()
			local _ = helper_fc1fa664(0)
		end
		if at <= 7 then
			var18 = var18 + 1
		end
		if at <= 8 then
			helper_aadfd919()
			value = 0
			value = value + 4
			var18 = 0
			var14 = vm.f32(var14 + var19)
		end
		if at <= 9 then
			var19 = vm.f32(var19 * vm.f32(0.9))
			angle = var26
			local _ = helper_17a6d269(var14, angle, vm.f32(0.08)) == 0
			var17 = 0
			angle = vm.f32(var26 - vm.f32(3.1415927))
			local _ = helper_17a6d269(var14, angle, vm.f32(0.08)) == 0
			var17 = 1
			var18 = vm.i32(var18 + 1)
			local _ = helper_17a6d269(var14, var26, 1.0) == 0
			var17 = 0
			var17 = 1
			var26 = var14
			helper_8980cad2(20)
		end
		if at <= 10 then
			var30 = 100
			var30 = 6
			var30 = 0
			var30 = 2
			var30 = 100
			var30 = 4
			var26 = vm.f32(var26 + vm.f32(3.14))
			var17 = 1
			var17 = 0
			helper_8980cad2(10)
		end
		if at <= 11 then
			var26 = vm.f32(var26 + vm.f32(3.14))
			var26 = vm.f32(var26 + vm.f32(1.57))
			var26 = vm.f32(var26 + vm.f32(1.57))
			helper_8980cad2(20)
		end
		if at <= 12 then
			local _ = helper_17a6d269(var14, var26, 1.0) == 0
			var17 = 0
			var17 = 1
			var31 = 1.0
			var18 = 0
			var31 = vm.f32(var31 + vm.f32(0.03))
			var18 = var18 + 1
		end
		if at <= 13 then
			helper_f3a90693(0, 2310, 8, 0, 0)
		end
		if at <= 14 then
			helper_f3a90693(0, 2311, 8, 0, 0)
		end
		if at <= 15 then
			helper_f3a90693(0, 2312, 8, 0, 0)
		end
		if at <= 16 then
			helper_f3a90693(0, 2313, 8, 0, 0)
		end
		if at <= 17 then
			helper_f3a90693(0, 2314, 8, 0, 0)
		end
		if at <= 18 then
			var31 = vm.f32(var31 - vm.f32(0.03))
			var18 = var18 + 1
		end
		if at <= 19 then
			helper_f3a90693(0, 2320, 8, 0, 0)
		end
		if at <= 20 then
			helper_f3a90693(0, 2321, 8, 0, 0)
		end
		if at <= 21 then
			helper_f3a90693(0, 2322, 8, 0, 0)
		end
		if at <= 22 then
			helper_f3a90693(0, 2323, 8, 0, 0)
		end
		if at <= 23 then
			helper_f3a90693(0, 2324, 8, 0, 0)
		end
		if at <= 24 then
			helper_f3a90693(0, 2325, 8, 0, 0)
		end
		if at <= 25 then
			helper_f3a90693(0, 2328, 8, 0, 0)
		end
		if at <= 26 then
			helper_f3a90693(0, 2326, 8, 0, 0)
		end
		if at <= 27 then
			helper_f3a90693(0, 2329, 8, 0, 0)
		end
		if at <= 28 then
			helper_f3a90693(0, 2327, 8, 0, 0)
		end
		if at <= 29 then
			helper_f3a90693(0, 2330, 8, 0, 0)
		end
	end
	event.Initialize()
	event.DngPause(513, 1)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		helper_e9655638()
		if active_chr_no == 2 then
			helper_f3a90693(0, 22, 8, 0, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_f3a90693(0, 23, 8, 0, 0)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 0)
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		do
			local out1, out2, out3 = event.RandomCircleGetPos(-1)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		yaw = event.GetRefAngle(pos_x, pos_y, pos_z, var1, var2, var3) or yaw
		var1 = vm.f32(vm.f32(vm.sin(yaw) * 25.0) + pos_x)
		var2 = pos_y
		var3 = vm.f32(vm.f32(vm.cos(yaw) * 25.0) + pos_z)
		event.SetCharaPos(0, var1, var2, var3)
		event.DngPause(513, 0)
		event.Finish()
		return
	end
	event.SetLoadbgFile("snd2/sp/sp_011.sound.json")
	if vm.wait() then
		return skip(3)
	end
	helper_e9655638()
	do
		local out1, out2, out3 = event.RandomCircleGetPos(-1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	event.SetCameraCtrl(0)
	event.SetFcameraFollowFlag(1)
	event.SetFcameraFollowA(pos_x_2, pos_y_2 + 30.0, pos_z_2)
	event.SetCameraSpeed(8.0)
	event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
	event.SetFcameraHeight(0.0)
	event.SetFcameraDist(80.0)
	event.AssignStack(5)
	event.ClearStack(5)
	helper_d797a244()
	if vm.skipping() then
		return skip(4)
	end
	var11 = event.SndLoadSound(8, "snd2/sp/sp_011.sound.json") or var11
	event.ChangeDir("event/dng/")
	event.SetLoadbgFile("ring.gltf", "randomcoin.gltf")
	if vm.wait() then
		return skip(5)
	end
	helper_d797a244()
	if vm.skipping() then
		return skip(6)
	end
	weight = event.GetRndcMotNowt() or weight
	event.RandomCircleOff(-1)
	event.LoadChara(5, "ring.gltf", "info", 12)
	event.CharaActive(1, 12)
	event.SetCharaPos(12, pos_x_2, pos_y_2, pos_z_2)
	event.SetMotion(12, "ループ", 6)
	event.CharaNormalDrive(12)
	event.SetCharaMotNowt(12, weight)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsNextMotion(4, "消滅", 6)
	event.LoadChara(5, "randomcoin.gltf", "info", 13)
	event.CharaActive(1, 13)
	event.SetCharaPos(13, pos_x_2, pos_y_2 - 30.0, pos_z_2)
	var14 = event.GetRand(6.2831855) or var14
	var14 = vm.f32(var14 - vm.f32(3.1415927))
	var14 = event.AngleLimit(var14) or var14
	event.SetCharaRot(13, 0.0, var14, 0.0)
	event.ChangeDir("")
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	event.EohSyncChara(5, 13)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetScale(5, 0.0, 0.0, 0.0)
	event.ObjsSetScale(5, 1.0, 1.0, 1.0, 40)
	event.ObjsMove2(5, pos_x_2, pos_y_2 + 40.0, pos_z_2, 30, 2, 0.5)
	var18 = 0
	var19 = vm.f32(0.6)
	while true do
		do
			local _, out2, _ = event.GetCharaRot(13)
			var14 = out2 or var14
		end
		var14 = vm.f32(var14 + var19)
		var14 = event.AngleLimit(var14) or var14
		event.SetCharaRot(13, 0.0, var14, 0.0)
		if var18 == 10 then
			event.SndSePlay(var11, 0)
		end
		if var18 == 30 then
			helper_42651a24()
		end
		if (if var18 >= 30 then helper_fc1fa664(0) else 0) ~= 0 or var18 > 300 then
			event.SndSeStop(var11, 0)
			event.SndSePlay(var11, 3)
			if vm.wait() then
				return skip(7)
			end
			break
		else
			var18 = var18 + 1
			if vm.wait() then
				return skip(8)
			end
		end
	end
	helper_aadfd919()
	event.EohSyncChara(5, 13)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x_3 = out1 or pos_x_3
		pos_y_3 = out2 or pos_y_3
		pos_z_3 = out3 or pos_z_3
	end
	do
		local out1, out2, out3 = event.GetCameraRef()
		pos_x_4 = out1 or pos_x_4
		pos_y_4 = out2 or pos_y_4
		pos_z_4 = out3 or pos_z_4
	end
	var26 = event.GetRefAngle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	value = 0
	value = event.GetRandInt(10) or value
	value = vm.i32(value + 4)
	var18 = 0
	while true do
		do
			local _, out2, _ = event.GetCharaRot(13)
			var14 = out2 or var14
		end
		var14 = vm.f32(var14 + var19)
		var14 = event.AngleLimit(var14) or var14
		event.SetCharaRot(13, 0.0, var14, 0.0)
		if vm.wait() then
			return skip(9)
		end
		if var18 >= value then
			if var19 > vm.f32(0.08) then
				var19 = vm.f32(var19 * vm.f32(0.9))
			end
			angle = var26
			angle = event.AngleLimit(angle) or angle
			if var14 < angle and helper_17a6d269(var14, angle, vm.f32(0.08)) == 0 then
				event.SetCharaRot(13, 0.0, angle, 0.0)
				var17 = 0
				break
			end
			angle = vm.f32(var26 - vm.f32(3.1415927))
			angle = event.AngleLimit(angle) or angle
			if var14 < angle and helper_17a6d269(var14, angle, vm.f32(0.08)) == 0 then
				event.SetCharaRot(13, 0.0, angle, 0.0)
				var17 = 1
				break
			end
		end
		var18 = vm.i32(var18 + 1)
	end
	var26 = event.GetRefAngle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	do
		local _, out2, _ = event.GetCharaRot(13)
		var14 = out2 or var14
	end
	if helper_17a6d269(var14, var26, 1.0) == 0 then
		var17 = 0
	else
		var17 = 1
	end
	var26 = var14
	helper_8980cad2(20)
	if vm.skipping() then
		return skip(10)
	end
	value_2 = event.GetRandInt(10) or value_2
	if now_party_chara_id == 24 then
		var30 = 100
	else
		var30 = 6
	end
	if value_2 < var30 then
		value_2 = event.GetRandInt(10) or value_2
		if var17 == 0 then
			if now_party_chara_id == 24 then
				var30 = 0
			else
				var30 = 2
			end
		elseif now_party_chara_id == 24 then
			var30 = 100
		else
			var30 = 4
		end
		if value_2 < var30 then
			var26 = vm.f32(var26 + vm.f32(3.14))
			var26 = event.AngleLimit(var26) or var26
			event.ObjsRotation(5, 0.0, var26, 0.0, 8)
			if var17 == 0 then
				var17 = 1
			else
				var17 = 0
			end
			helper_8980cad2(10)
			if vm.skipping() then
				return skip(11)
			end
		else
			value_2 = event.GetRandInt(10) or value_2
			if value_2 < 1 then
				var26 = vm.f32(var26 + vm.f32(3.14))
				var26 = event.AngleLimit(var26) or var26
				event.ObjsRotation(5, 0.0, var26, 0.0, 6)
				var26 = vm.f32(var26 + vm.f32(1.57))
				var26 = event.AngleLimit(var26) or var26
				event.ObjsRotation(5, 0.0, var26, 0.0, 3)
				var26 = vm.f32(var26 + vm.f32(1.57))
				var26 = event.AngleLimit(var26) or var26
				event.ObjsRotation(5, 0.0, var26, 0.0, 3)
				helper_8980cad2(20)
				if vm.skipping() then
					return skip(12)
				end
			end
		end
	end
	var26 = event.GetRefAngle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	do
		local _, out2, _ = event.GetCharaRot(13)
		var14 = out2 or var14
	end
	if helper_17a6d269(var14, var26, 1.0) == 0 then
		var17 = 0
	else
		var17 = 1
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	var31 = 1.0
	var18 = 0
	var32 = event.GetRndCircleTrapid(var17) or var32
	if var17 == 0 then
		event.SndSePlay(var11, 1)
		while var18 < 30 do
			event.BscnSetBlightRate(var31)
			var31 = vm.f32(var31 + vm.f32(0.03))
			var18 = var18 + 1
			if vm.wait() then
				return skip(13)
			end
		end
		helper_f3a90693(0, 2310, 8, 0, 0)
		if vm.skipping() then
			return skip(14)
		end
		result = event.SetRndCircleStatus(var32) or result
		if var32 == 1 then
			helper_f3a90693(0, 2311, 8, 0, 0)
			if vm.skipping() then
				return skip(15)
			end
		end
		if var32 == 2 then
			helper_f3a90693(0, 2312, 8, 0, 0)
			if vm.skipping() then
				return skip(16)
			end
		end
		if var32 == 3 then
			helper_f3a90693(0, 2313, 8, 0, 0)
			if vm.skipping() then
				return skip(17)
			end
		end
		if var32 == 4 then
			event.PostTreasureBox(pos_x_2, pos_y_2, pos_z_2, var26, 294)
			helper_f3a90693(0, 2314, 8, 0, 0)
			if vm.skipping() then
				return skip(18)
			end
		end
	else
		event.SndSePlay(var11, 2)
		while var18 < 30 do
			event.BscnSetBlightRate(var31)
			var31 = vm.f32(var31 - vm.f32(0.03))
			var18 = var18 + 1
			if vm.wait() then
				return skip(19)
			end
		end
		helper_f3a90693(0, 2320, 8, 0, 0)
		if vm.skipping() then
			return skip(20)
		end
		result = event.SetRndCircleStatus(var32) or result
		if var32 == 5 then
			if active_chr_no == 0 or active_chr_no == 2 then
				helper_f3a90693(0, 2321, 8, 0, 0)
				if vm.skipping() then
					return skip(21)
				end
			end
			if active_chr_no == 1 or active_chr_no == 3 then
				helper_f3a90693(0, 2322, 8, 0, 0)
				if vm.skipping() then
					return skip(22)
				end
			end
		end
		if var32 == 6 then
			if active_chr_no == 0 then
				helper_f3a90693(0, 2323, 8, 0, 0)
				if vm.skipping() then
					return skip(23)
				end
			end
			if active_chr_no == 1 or active_chr_no == 3 then
				helper_f3a90693(0, 2324, 8, 0, 0)
				if vm.skipping() then
					return skip(24)
				end
			end
			if active_chr_no == 2 then
				helper_f3a90693(0, 2325, 8, 0, 0)
				if vm.skipping() then
					return skip(25)
				end
			end
		end
		if var32 == 8 then
			helper_f3a90693(0, 2328, 8, 0, 0)
			if vm.skipping() then
				return skip(26)
			end
		end
		if var32 == 9 then
			helper_f3a90693(0, 2326, 8, 0, 0)
			if vm.skipping() then
				return skip(27)
			end
		end
		if var32 == 10 then
			helper_f3a90693(0, 2329, 8, 0, 0)
			if vm.skipping() then
				return skip(28)
			end
		end
		if var32 == 11 then
			helper_f3a90693(0, 2327, 8, 0, 0)
			if vm.skipping() then
				return skip(29)
			end
		end
		if var32 == 12 then
			helper_f3a90693(0, 2330, 8, 0, 0)
			if vm.skipping() then
				return skip(30)
			end
		end
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.BscnSetBlightRate(1.0)
	if var32 == 1 then
		event.SetPullItem(pos_x_2, pos_y_2, pos_z_2, 1, 10, result / 10.0)
	end
	event.DngPause(513, 0)
	event.SetCameraCtrl(1)
	do
		local out1, out2, out3 = event.GetBeforeCameraNextPos()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.SetCameraPos(position_x, position_y, position_z)
	do
		local out1, out2, out3 = event.GetBeforeCameraNextRef()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.SetCameraRef(position_x, position_y, position_z)
	event.DeleteChara(12)
	event.DeleteChara(13)
	event.SetCrossfade(15)
	event.Finish()
end

--- Program 1130.
script[1130] = function()
	local active_chr_no: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local argc: s32 = 0
	local stage_id: s32 = 0
	local var23: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_f3a90693(0, 23, 8, 0, 0)
			end
			return
		end
		if at <= 3 then
			helper_d797a244()
		end
		if at <= 5 then
			helper_d797a244()
		end
		if at <= 6 then
			pos_y_2 = vm.f32(var9 + 18.0)
			var17 = vm.f32(var17 + vm.f32(2.9))
			var17 = vm.f32(var17 + vm.f32(2.4))
			var8 = vm.f32(vm.f32(vm.sin(var17) * 14.0) + pos_x_2)
			var10 = vm.f32(vm.f32(vm.cos(var17) * 14.0) + pos_z_2)
			var17 = vm.f32(var17 - vm.f32(3.1415927))
			var18 = vm.f32(vm.f32(vm.sin(var17) * 8.0) + var8)
			var19 = vm.f32(var9 + 18.0)
			var20 = vm.f32(vm.f32(vm.cos(var17) * 8.0) + var10)
			helper_8980cad2(16)
		end
		if at <= 7 then
			helper_8980cad2(2)
		end
		if at <= 8 then
			helper_8980cad2(10)
		end
		if at <= 9 then
			helper_8980cad2(20)
		end
		if at <= 10 then
			helper_2ce9c3c3(0)
		end
		if at <= 11 then
			helper_f3a90693(0, 2400, 8, 0, 0)
		end
	end
	event.Initialize()
	event.DngPause(513, 1)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		helper_e9655638()
		if active_chr_no == 2 then
			helper_f3a90693(0, 22, 8, 0, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_f3a90693(0, 23, 8, 0, 0)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 0)
		event.DngPause(513, 0)
		event.Finish()
		return
	end
	event.DngPause(16, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetFlag(31, 1)
	event.SetMotion(0, "立ち")
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	if active_chr_no == 0 then
		event.SetLoadbgFile(
			"dungeon/chara/c01_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		if vm.wait() then
			return skip(3)
		end
		helper_d797a244()
		if vm.skipping() then
			return skip(4)
		end
		event.LoadMotion(5, "dungeon/chara/c01_gio.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.SetLoadbgFile(
			"dungeon/chara/c02_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		if vm.wait() then
			return skip(5)
		end
		helper_d797a244()
		if vm.skipping() then
			return skip(6)
		end
		event.LoadMotion(5, "dungeon/chara/c02_gio.gltf", "info", 0)
	end
	var4 = event.SndLoadSound(8, "snd2/sp/sp_012.sound.json") or var4
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	event.CopyVector(var8, var9, var10)
	event.GeostoneAnimeOff()
	event.EohSyncGeostone(1)
	do
		local out1, out2, out3 = event.EohGetPos(1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	pos_y_2 = vm.f32(var9 + 18.0)
	event.EohSetPos(1, pos_x_2, pos_y_2, pos_z_2)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	var17 = event.GetRefAngle(pos_x_2, pos_y_2, pos_z_2, pos_x, pos_y, pos_z) or var17
	var17 = event.AngleLimit(var17) or var17
	if active_chr_no == 0 then
		var17 = vm.f32(var17 + vm.f32(2.9))
	end
	if active_chr_no == 1 then
		var17 = vm.f32(var17 + vm.f32(2.4))
	end
	var17 = event.AngleLimit(var17) or var17
	var8 = vm.f32(vm.f32(vm.sin(var17) * 14.0) + pos_x_2)
	var10 = vm.f32(vm.f32(vm.cos(var17) * 14.0) + pos_z_2)
	event.SetCharaPos(0, var8, var9, var10)
	var17 = vm.f32(var17 - vm.f32(3.1415927))
	var17 = event.AngleLimit(var17) or var17
	event.SetCharaRot(0, 0.0, var17, 0.0)
	event.EohResetDaPosition(0)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 12)
	event.CharaActive(0, 12)
	if active_chr_no == 0 then
		event.SetCameraCtrl(0)
		event.SetFcameraFollowFlag(1)
		event.SetFcameraFollowA(var8, var9 + 18.0, var10)
		event.SetCameraSpeed(16.0)
		event.SetFcameraFollowOfs(0.0, 6.0, 0.0)
		event.SetFcameraHeight(-14.0)
		event.SetFcameraDist(54.0)
		event.SetCharaPos(12, var8, var9 + 36.0, var10)
	end
	if active_chr_no == 1 then
		event.SetCameraCtrl(0)
		event.SetFcameraFollowFlag(1)
		event.SetFcameraFollowA(var8, var9 + 18.0, var10)
		event.SetCameraSpeed(16.0)
		event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
		event.SetFcameraHeight(-5.0)
		event.SetFcameraDist(34.0)
		var18 = vm.f32(vm.f32(vm.sin(var17) * 8.0) + var8)
		var19 = vm.f32(var9 + 18.0)
		var20 = vm.f32(vm.f32(vm.cos(var17) * 8.0) + var10)
		event.SetCharaPos(12, var18, var19, var20)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.SetCrossfade(30)
	event.ObjsSetMotion(0, "取る", 6)
	event.ObjsNextMotion(0, "取るL", 4)
	helper_8980cad2(16)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSePlay(var4, 0)
	helper_8980cad2(2)
	if vm.skipping() then
		return skip(8)
	end
	event.EohSetPos(1, 0.0, 0.0, 0.0)
	event.GeostoneSetReference(0, "item")
	helper_8980cad2(10)
	if vm.skipping() then
		return skip(9)
	end
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var17 = event.GetRefAngle(var8, var9, var10, pos_x, pos_y, pos_z) or var17
	event.SetCharaRot(12, 0.0, var17, 0.0)
	event.CharaActive(1, 12)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetMotion(4, "発動", 6, 1.2)
	event.ObjsMotionWait(4)
	event.ObjsResetMotion(4)
	event.ObjsSetMotion(4, "発動", 5)
	helper_8980cad2(20)
	if vm.skipping() then
		return skip(10)
	end
	event.SndSePlay(var4, 1)
	helper_2ce9c3c3(0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	argc = event.GetSysSndId() or argc
	event.SndSePlay(argc, 18)
	helper_f3a90693(0, 2400, 8, 0, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	stage_id = event.DngGetStageId() or stage_id
	var23 = event.DngGetFloorId() or var23
	event.SetFloorInfo(stage_id, var23, 5, 256)
	event.SetCrossfade(10)
	if active_chr_no == 1 then
		event.SetMotion(0, "取る戻り", 6)
		if vm.wait() then
			return skip(13)
		end
	end
	event.DngPause(529, 0)
	event.SetMotion(0, "立ち", 4)
	event.SetCharaPos(0, var1, var2, var3)
	event.EohResetDaPosition(0)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.GeostoneDelReference()
	event.GeostoneSetFlag(0)
	event.EohSetScale(1, 1.0, 1.0, 1.0)
	event.DelExtMotion(0)
	event.DeleteChara(12)
	event.SetCameraCtrl(1)
	event.Finish()
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_86ccaca9(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1500.
script[1500] = function()
	local var0: s32 = 0
	local stage_id: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8980cad2(30)
		end
		if at <= 2 then
			helper_d797a244()
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.ActchrSetDefMotion(0, 4)
	event.FadeOutBgm(60)
	var0 = event.GetCnt(17) or var0
	if bit32.band(var0, 1) == 0 then
		event.PostTreasureBox(50.0, 0.0, 600.0, 3.14, 207)
	end
	if bit32.band(var0, 2) == 0 then
		event.PostTreasureBox(-50.0, 0.0, 600.0, 3.14, 198)
	end
	if bit32.band(var0, 1) == 0 or bit32.band(var0, 2) == 0 then
		event.SetCrossfade(30)
		event.SetCameraPos(-6.54, 68.0, 251.52)
		event.SetCameraRef(-1.83, 30.0, 381.43)
		event.SetCharaPos(0, -1.83, 0.0, 381.43)
		event.SetCharaRot(0, 0.0, 0.08, 0.0)
		helper_8980cad2(30)
		if vm.skipping() then
			return skip(2)
		end
		event.ResetCamera(0)
	end
	event.SetLoadbgFile("snd2/bgm/bg_193.sound.json")
	helper_d797a244()
	if vm.skipping() then
		return skip(3)
	end
	event.LoadBgmPack(193)
	event.PlayBgm(0)
	stage_id = event.DngGetStageId() or stage_id
	var2 = event.DngGetFloorId() or var2
	event.SetFloorInfo(stage_id, var2, 5, 2)
	event.Finish()
end

--- Program 2500.
script[2500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.DngPause(513, 1)
	event.SetFlag(50, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	helper_f3a90693(0, 2600, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(513, 0)
	event.Finish()
end

--- Program 2510.
script[2510] = function()
	local var0: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			_, var0 = helper_42da9aa6(0, 0, var0)
		end
		helper_2ba993e3(0)
	end
	event.Initialize()
	event.DngPause(515, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	helper_24d1805d(0, 2610, 8, 0, 0)
	helper_8980cad2(30)
	if vm.skipping() then
		return skip(1)
	end
	_, var0 = helper_42da9aa6(0, 0, var0)
	if vm.skipping() then
		return skip(2)
	end
	helper_2ba993e3(0)
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(515, 0)
	event.Finish()
end

--- Program 2520.
script[2520] = function()
	local var0: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			_, var0 = helper_42da9aa6(0, 0, var0)
		end
		if at <= 2 then
			helper_2ba993e3(0)
			helper_f3a90693(0, 2621, 8, 0, 0)
		end
		if at <= 3 then
			helper_f3a90693(0, 2622, 8, 0, 0)
		end
		if at <= 4 then
			helper_f3a90693(0, 2623, 8, 0, 0)
		end
		if at <= 5 then
			helper_f3a90693(0, -1, 8, 0, 0)
		end
	end
	event.Initialize()
	event.DngPause(515, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	helper_24d1805d(0, 2620, 8, 0, 0)
	helper_8980cad2(30)
	if vm.skipping() then
		return skip(1)
	end
	_, var0 = helper_42da9aa6(0, 0, var0)
	if vm.skipping() then
		return skip(2)
	end
	helper_2ba993e3(0)
	helper_f3a90693(0, 2621, 8, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
	helper_f3a90693(0, 2622, 8, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
	helper_f3a90693(0, 2623, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, 'Mehr erf[UNI00e4]hrst du unter\n"Hilfe" im Hauptmen[UNI00fc].')
	helper_f3a90693(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	if vm.wait() then
		return skip(7)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(515, 0)
	event.Finish()
end

--- Program 2530.
script[2530] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.DngPause(513, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(
		0,
		"[(!)]Lenken des Buggys\n   Beschleunige mit (L)↑, bremse mit (L)↓.\n   lenke mit (L) ← oder →.\n   Scharfe Kurven: [l1] + (L) ← oder →."
	)
	helper_f3a90693(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(513, 0)
	event.Finish()
end

--- Program 2540.
script[2540] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f3a90693(0, -1, 8, 0, 0)
		end
		if at <= 2 then
			helper_f3a90693(0, -1, 8, 0, 0)
		end
		if at <= 3 then
			helper_f3a90693(0, -1, 8, 0, 0)
		end
		if at <= 4 then
			helper_f3a90693(0, -1, 8, 0, 0)
		end
	end
	event.Initialize()
	event.DngPause(515, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(0, "[(!)]Du kannst die Magie-Raub-\nKlinge jetzt verwenden.")
	helper_f3a90693(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Die Fertigkeit Magie-Raub-Klinge\nerlaubt es dir, die Energie von\nElementarangriffen wie Feuer beim\nAbwehren aufzunehmen.<page>Beim Angriff verwandelt\nsie sich in Magie."
	)
	helper_f3a90693(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Die Energie eines Elements kannst\ndu immer weiter aufladen.\nNimmst du aber einen anderen Elementar-\nTyp auf, verlierst du die ganze Ladung."
	)
	helper_f3a90693(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Wie viel Elementarenergie du\nabsorbieren kannst, h[UNI00e4]ngt von der\nHaltbarkeit deiner Waffe ab."
	)
	helper_f3a90693(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Um absorbierte Elementarenergie als\nMagie abzugeben, dr[UNI00fc]cke [l1]\n w[UNI00e4]hrend du mit [r1] abwehrst."
	)
	helper_f3a90693(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	if vm.wait() then
		return skip(6)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(515, 0)
	event.Finish()
end

return script
