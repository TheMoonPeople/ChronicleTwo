--!strict
-- map/d/d05/d05_sfida_0.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_166cb93a = require("@lib/event/helper_166cb93a")
local helper_1a7fd8eb = require("@lib/event/helper_1a7fd8eb")
local helper_22878665 = require("@lib/event/helper_22878665")
local helper_39ab7f1f = require("@lib/event/helper_39ab7f1f")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_49c6448e = require("@lib/event/helper_49c6448e")
local helper_4c0e734e = require("@lib/event/helper_4c0e734e")
local helper_581cb30c = require("@lib/event/helper_581cb30c")
local helper_59ffae1f = require("@lib/event/helper_59ffae1f")
local helper_6992f518 = require("@lib/event/helper_6992f518")
local helper_7982ab52 = require("@lib/event/helper_7982ab52")
local helper_79d90c82 = require("@lib/event/helper_79d90c82")
local helper_7b560508 = require("@lib/event/helper_7b560508")
local helper_7ddc1f42 = require("@lib/event/helper_7ddc1f42")
local helper_82705ce2 = require("@lib/event/helper_82705ce2")
local helper_86f3f24c = require("@lib/event/helper_86f3f24c")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_9e7d1511 = require("@lib/event/helper_9e7d1511")
local helper_c190f878 = require("@lib/event/helper_c190f878")
local helper_c44453a9 = require("@lib/event/helper_c44453a9")
local helper_ce85b54c = require("@lib/event/helper_ce85b54c")
local helper_dff48a5c = require("@lib/event/helper_dff48a5c")
local helper_e91d3484 = require("@lib/event/helper_e91d3484")
local helper_eedf6c6c = require("@lib/event/helper_eedf6c6c")
local helper_f680702c = require("@lib/event/helper_f680702c")
local helper_f7fba8ce = require("@lib/event/helper_f7fba8ce")
local helper_f90045b0 = require("@lib/event/helper_f90045b0")
local helper_ff6b5892 = require("@lib/event/helper_ff6b5892")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local argc: s32 = 0
	event.Initialize()
	vm.wait(1)
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

--- The dungeon system event run when the player steps into a random circle.
function script.random_circle()
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
	local var27: s32 = 0
	local angle: f32 = 0
	local var29: s32 = 0
	local var30: s32 = 0
	local var31: f32 = 0
	local var32: s32 = 0
	local result: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	event.Initialize()
	event.DngPause(513, 1)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		helper_ce85b54c()
		if active_chr_no == 2 then
			helper_9e7d1511(0, 22, 8, 0, 0)
		else
			helper_9e7d1511(0, 23, 8, 0, 0)
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
	event.SetLoadbgFile_1("snd2/sp/sp_011.sound.json")
	vm.wait(3)
	helper_ce85b54c()
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
	helper_479dc9e9()
	var11 = event.SndLoadSound_3(8, "snd2/sp/sp_011.sound.json") or var11
	event.ChangeDir("event/dng/")
	event.SetLoadbgFile_2("ring.gltf", "randomcoin.gltf")
	vm.wait(5)
	helper_479dc9e9()
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
			helper_ff6b5892()
		end
		if (if var18 >= 30 then helper_581cb30c(0) else 0) ~= 0 or var18 > 300 then
			event.SndSeStop(var11, 0)
			event.SndSePlay(var11, 3)
			vm.wait(7)
			break
		else
			var18 = var18 + 1
			vm.wait(8)
		end
	end
	helper_4c0e734e()
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
	var27 = 0
	var27 = vm.float_bits(event.GetRand(10)) or var27
	var27 = vm.i32(var27 + 4)
	var18 = 0
	while true do
		do
			local _, out2, _ = event.GetCharaRot(13)
			var14 = out2 or var14
		end
		var14 = vm.f32(var14 + var19)
		var14 = event.AngleLimit(var14) or var14
		event.SetCharaRot(13, 0.0, var14, 0.0)
		vm.wait(9)
		if var18 >= var27 then
			if var19 > vm.f32(0.08) then
				var19 = vm.f32(var19 * vm.f32(0.9))
			end
			angle = var26
			angle = event.AngleLimit(angle) or angle
			if var14 < angle and helper_f7fba8ce(var14, angle, vm.f32(0.08)) == 0 then
				event.SetCharaRot(13, 0.0, angle, 0.0)
				var17 = 0
				break
			end
			angle = vm.f32(var26 - vm.f32(3.1415927))
			angle = event.AngleLimit(angle) or angle
			if var14 < angle and helper_f7fba8ce(var14, angle, vm.f32(0.08)) == 0 then
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
	if helper_f7fba8ce(var14, var26, 1.0) == 0 then
		var17 = 0
	else
		var17 = 1
	end
	var26 = var14
	helper_888ab2a3(20)
	var29 = vm.float_bits(event.GetRand(10)) or var29
	if now_party_chara_id == 24 then
		var30 = 100
	else
		var30 = 6
	end
	if var29 < var30 then
		var29 = vm.float_bits(event.GetRand(10)) or var29
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
		if var29 < var30 then
			var26 = vm.f32(var26 + vm.f32(3.14))
			var26 = event.AngleLimit(var26) or var26
			event.ObjsRotation(5, 0.0, var26, 0.0, 8)
			if var17 == 0 then
				var17 = 1
			else
				var17 = 0
			end
			helper_888ab2a3(10)
		else
			var29 = vm.float_bits(event.GetRand(10)) or var29
			if var29 < 1 then
				var26 = vm.f32(var26 + vm.f32(3.14))
				var26 = event.AngleLimit(var26) or var26
				event.ObjsRotation(5, 0.0, var26, 0.0, 6)
				var26 = vm.f32(var26 + vm.f32(1.57))
				var26 = event.AngleLimit(var26) or var26
				event.ObjsRotation(5, 0.0, var26, 0.0, 3)
				var26 = vm.f32(var26 + vm.f32(1.57))
				var26 = event.AngleLimit(var26) or var26
				event.ObjsRotation(5, 0.0, var26, 0.0, 3)
				helper_888ab2a3(20)
			end
		end
	end
	var26 = event.GetRefAngle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	do
		local _, out2, _ = event.GetCharaRot(13)
		var14 = out2 or var14
	end
	if helper_f7fba8ce(var14, var26, 1.0) == 0 then
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
			vm.wait(13)
		end
		helper_9e7d1511(0, 2310, 8, 0, 0)
		result = event.SetRndCircleStatus(var32) or result
		if var32 == 1 then
			helper_9e7d1511(0, 2311, 8, 0, 0)
		end
		if var32 == 2 then
			helper_9e7d1511(0, 2312, 8, 0, 0)
		end
		if var32 == 3 then
			helper_9e7d1511(0, 2313, 8, 0, 0)
		end
		if var32 == 4 then
			event.PostTreasureBox(pos_x_2, pos_y_2, pos_z_2, var26, 294)
			helper_9e7d1511(0, 2314, 8, 0, 0)
		end
	else
		event.SndSePlay(var11, 2)
		while var18 < 30 do
			event.BscnSetBlightRate(var31)
			var31 = vm.f32(var31 - vm.f32(0.03))
			var18 = var18 + 1
			vm.wait(19)
		end
		helper_9e7d1511(0, 2320, 8, 0, 0)
		result = event.SetRndCircleStatus(var32) or result
		if var32 == 5 then
			if active_chr_no == 0 or active_chr_no == 2 then
				helper_9e7d1511(0, 2321, 8, 0, 0)
			end
			if active_chr_no == 1 or active_chr_no == 3 then
				helper_9e7d1511(0, 2322, 8, 0, 0)
			end
		end
		if var32 == 6 then
			if active_chr_no == 0 then
				helper_9e7d1511(0, 2323, 8, 0, 0)
			end
			if active_chr_no == 1 or active_chr_no == 3 then
				helper_9e7d1511(0, 2324, 8, 0, 0)
			end
			if active_chr_no == 2 then
				helper_9e7d1511(0, 2325, 8, 0, 0)
			end
		end
		if var32 == 8 then
			helper_9e7d1511(0, 2328, 8, 0, 0)
		end
		if var32 == 9 then
			helper_9e7d1511(0, 2326, 8, 0, 0)
		end
		if var32 == 10 then
			helper_9e7d1511(0, 2329, 8, 0, 0)
		end
		if var32 == 11 then
			helper_9e7d1511(0, 2327, 8, 0, 0)
		end
		if var32 == 12 then
			helper_9e7d1511(0, 2330, 8, 0, 0)
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

--- The dungeon system event run when the player uses the geostone.
function script.geostone()
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
	event.Initialize()
	event.DngPause(513, 1)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		helper_ce85b54c()
		if active_chr_no == 2 then
			helper_9e7d1511(0, 22, 8, 0, 0)
		else
			helper_9e7d1511(0, 23, 8, 0, 0)
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
		event.SetLoadbgFile_3(
			"dungeon/chara/c01_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(3)
		helper_479dc9e9()
		event.LoadMotion(5, "dungeon/chara/c01_gio.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.SetLoadbgFile_3(
			"dungeon/chara/c02_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(5)
		helper_479dc9e9()
		event.LoadMotion(5, "dungeon/chara/c02_gio.gltf", "info", 0)
	end
	var4 = event.SndLoadSound_3(8, "snd2/sp/sp_012.sound.json") or var4
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
	helper_888ab2a3(16)
	event.SndSePlay(var4, 0)
	helper_888ab2a3(2)
	event.EohSetPos(1, 0.0, 0.0, 0.0)
	event.GeostoneSetReference(0, "item")
	helper_888ab2a3(10)
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
	helper_888ab2a3(20)
	event.SndSePlay(var4, 1)
	helper_0958ca60(0)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	argc = event.GetSysSndId() or argc
	event.SndSePlay(argc, 18)
	helper_9e7d1511(0, 2400, 8, 0, 0)
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	stage_id = event.DngGetStageId() or stage_id
	var23 = event.DngGetFloorId() or var23
	event.SetFloorInfo(stage_id, var23, 5, 256)
	event.SetCrossfade(10)
	if active_chr_no == 1 then
		event.SetMotion(0, "取る戻り", 6)
		vm.wait(13)
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

--- The dungeon system event run on the first examination of a random stone.
function script.random_stone_guide()
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.DngPause(513, 1)
	event.SetFlag(50, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	helper_9e7d1511(0, 2600, 8, 0, 0)
	vm.wait(2)
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(513, 0)
	event.Finish()
end

--- Event 2510, which map data, a script or the engine runs by number.
function script.event_2510()
	local var0: s32 = 0
	event.Initialize()
	event.DngPause(515, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	helper_82705ce2(0, 2610, 8, 0, 0)
	helper_888ab2a3(30)
	do
		local _: any
		_, var0 = helper_7ddc1f42(0, 0, var0)
	end
	helper_6992f518(0)
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(515, 0)
	event.Finish()
end

--- The dungeon system event run the first time the player levels up.
function script.level_up_guide()
	local var0: s32 = 0
	event.Initialize()
	event.DngPause(515, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	helper_82705ce2(0, 2620, 8, 0, 0)
	helper_888ab2a3(30)
	do
		local _: any
		_, var0 = helper_7ddc1f42(0, 0, var0)
	end
	helper_6992f518(0)
	helper_9e7d1511(0, 2621, 8, 0, 0)
	helper_9e7d1511(0, 2622, 8, 0, 0)
	helper_9e7d1511(0, 2623, 8, 0, 0)
	event.MesMake_2(0, "詳しくは、メインメニューの\n『ヘルプ』を参照してください。")
	helper_9e7d1511(0, -1, 8, 0, 0)
	vm.wait(7)
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(515, 0)
	event.Finish()
end

--- The dungeon system event run the first time the ridepod's wheels are used.
function script.robo_bike_guide()
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.DngPause(513, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(
		0,
		"[(!)]「バギー」パーツでの移動方法\n   (L)↑で加速、(L)↓で減速。\n   (L)←→でハンドル、[l1]＋(L)←→でクイックターン。"
	)
	helper_9e7d1511(0, -1, 8, 0, 0)
	vm.wait(2)
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(513, 0)
	event.Finish()
end

--- The dungeon system event run the first time the magic sword counter fills.
function script.magic_sword_guide()
	event.Initialize()
	event.DngPause(515, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(0, "[(!)]「吸収魔法剣」を使えるようになった。")
	helper_9e7d1511(0, -1, 8, 0, 0)
	event.MesMake_2(
		0,
		"「吸収魔法剣」とは、炎などの属性を持った攻撃を\nガードすることによって吸収し、剣の振りと共に\n魔法として放出する技です。"
	)
	helper_9e7d1511(0, -1, 8, 0, 0)
	event.MesMake_2(
		0,
		"同じ属性なら連続して吸収することが可能で\n途中一度でも違う属性を吸収すると\nそれまで吸収した属性は無効になります。"
	)
	helper_9e7d1511(0, -1, 8, 0, 0)
	event.MesMake_2(
		0,
		"一度に吸収できる量は装備している\n武器の耐久力によって変化します。"
	)
	helper_9e7d1511(0, -1, 8, 0, 0)
	event.MesMake_2(
		0,
		"吸収した属性を魔法として放つには、\n[r1]でガード中に[l1]を押して放出します。"
	)
	helper_9e7d1511(0, -1, 8, 0, 0)
	vm.wait(6)
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(515, 0)
	event.Finish()
end

--- The Sphida event run when the player stands at the ball and presses the action button.
function script.sphida_shot()
	local var0: s32 = 0
	local tex_bank: s32 = 0
	local var2: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: s32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: s32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var30: s32 = 0
	local var31: f32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	local var38: f32 = 0
	local var39: f32 = 0
	local var40: f32 = 0
	local var41: f32 = 0
	local var42: s32 = 0
	local var43: s32 = 0
	local var44: s32 = 0
	local var45: s32 = 0
	local var46: s32 = 0
	local var47: s32 = 0
	local var48: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var52: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local yaw: f32 = 0
	local count: s32 = 0
	local var58: any = 0
	vm.wait(1)
	event.Initialize()
	helper_ce85b54c()
	event.SetMotion(0, "立ち")
	if helper_59ffae1f() ~= 0 then
		event.Finish()
		return
	end
	var0 = event.SphidaGetOmakeMode() or var0
	if var0 == 0 then
		event.SetStatusbarShow(0, 0.1)
	end
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetLoadbgFile_4(
		"dungeon/sphida/c01_golf.gltf",
		"dungeon/chara/c01b_miss.gltf",
		"dungeon/sphida/gool_end.gltf",
		"dungeon/sphida/mizu_eff.gltf"
	)
	vm.wait(3)
	helper_479dc9e9()
	event.LoadMotion(5, "dungeon/sphida/c01_golf.gltf", "info", 0)
	event.LoadMotion(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	tex_bank = event.SphidaGetTexb() or tex_bank
	event.LoadChara(5, "dungeon/sphida/gool_end.gltf", "info", 12)
	event.CharaActive(0, 12)
	var2 = event.SndLoadSound_3(5, "snd2/mon/en_900.sound.json") or var2
	event.CreateSwordEffect(5, 64, 16)
	event.SwordEffectColor(128, 128, 128, 80, 128, 128, 128, 80)
	event.EsmInitialize(5, 1)
	event.EsmLoadBasePack("足水パシャ", "dungeon/sphida/mizu_eff.gltf")
	event.EsmInitFix(5)
	event.EohSyncChara(0, 2)
	event.EohSetShow(0, 0)
	event.SetCrossfade(15)
	event.SphidaResetPowgage()
	do
		local out1, out2, out3 = event.SphidaGetBallPos()
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	var3, var4, var5, var7 = helper_49c6448e(var3, var4, var5, var7)
	helper_1a7fd8eb(var7)
	event.SphidaSetStatusFlag(1)
	var12 = 12.5
	event.SphidaCalcCarry(vm.f32(var12 * vm.f32(3.1415927)) / 180.0)
	var13, var14, var15 = helper_39ab7f1f(var13, var14, var15)
	event.SphidaSetPowgageSafeLevel(var15)
	do
		local out1, out2, out3 = event.ZeroVector()
		var16 = out1 or var16
		var17 = out2 or var17
		var18 = out3 or var18
	end
	while true do
		event.SphidaSetMinimapFlag(1)
		event.SphidaSetMmLineFlag(1)
		local t0: s32
		t0, var7, var12 = helper_86f3f24c(var7, var12, tex_bank)
		if t0 ~= 0 then
			event.SphidaSetMinimapFlag(0)
			event.SphidaSetMmLineFlag(0)
			event.SphidaSetBallPos(var9, var10, var11)
			event.SetCharaPos(8, var9, var10, var11)
			event.SetCharaPos(9, var9, var10, var11)
			helper_166cb93a(0)
			return
		end
		event.SphidaSetMinimapFlag(0)
		event.SphidaSetMmLineFlag(0)
		local t1: s32
		t1, var13, var7, var17, var16, var15 = helper_22878665(var13, tex_bank, var7, var17, var16, var2, var15)
		if t1 == 0 then
			break
		else
			vm.wait(8)
		end
	end
	do
		local out1, out2, out3 = event.CopyVector(var3, var4, var5)
		var19 = out1 or var19
		var20 = out2 or var20
		var21 = out3 or var21
	end
	var22 = 0
	if var15 ~= 1 and var15 ~= -1 and var15 ~= 4 then
		event.SpriteSetType(0, 1)
		event.SpriteSetDraw(0, 1)
		event.SpriteSetPutsize(0, 10.8, 11.6)
		event.SpriteSetPos(0, var3, var4 + 30.0, var5)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		if var15 == 0 then
			event.SpriteSetUvsize(0, 78, 198, 54, 58)
		end
		if var15 == 2 or var15 == -2 then
			event.SpriteSetUvsize(0, 186, 190, 70, 66)
		end
		if var15 == 3 or var15 == -3 then
			event.SpriteSetUvsize(0, 132, 198, 54, 58)
		end
		event.EohSyncSprite(18, 0)
		event.ObjsInit(18)
		event.ObjsSyncObj(18, 18)
		event.ObjsSetColor(18, 128, 128, 128, 128, 4)
		event.ObjsColorDelay(18, 20)
		event.ObjsSetColor(18, 128, 128, 128, 0, 6)
		helper_888ab2a3(10)
	end
	if var13 <= vm.f32(0.3) then
		event.SetMotion(0, "小ショット", 2)
		helper_888ab2a3(25)
		if var15 ~= 4 then
			event.SndSePlay(var2, 3)
		end
	elseif var13 <= vm.f32(0.6) then
		event.SetMotion(0, "中ショット", 2)
		helper_888ab2a3(34)
		event.SndSePlay(var2, 2)
	else
		event.SetMotion(0, "大ショット", 2)
		helper_888ab2a3(39)
		if var15 == 0 then
			event.SndSePlay(var2, 12)
		else
			event.SndSePlay(var2, 1)
		end
	end
	if var15 == 4 then
		helper_888ab2a3(50)
		helper_f90045b0(var2)
		event.SphidaSetBallPos(var9, var10, var11)
		event.SetCharaPos(8, var9, var10, var11)
		event.SetCharaPos(9, var9, var10, var11)
		helper_166cb93a(0)
		return
	end
	if var15 == 0 then
		event.SpriteSetType(1, 0)
		event.SpriteSetDraw(1, 1)
		event.SpriteSetPos(1, 256, 278)
		event.SpriteSetUvsize(1, 246, 104, 266, 42)
		event.SpriteSetPutsize(1, 266, 42)
		event.SpriteSetColor(1, 128, 128, 128, 0)
		event.SpriteSetScale(1, 10, 10, 10)
		event.EohSyncSprite(19, 1)
		event.ObjsInit(19)
		event.ObjsSyncObj(19, 19)
		event.ObjsJump(19, 256, 138, 0, 3.6, 20)
		event.ObjsSetScale(19, 1, 1, 1, 18)
		event.ObjsSetColor(19, 128, 128, 128, 128, 12)
		event.ObjsColorDelay(19, 30)
		event.ObjsSetColor(19, 128, 128, 128, 0, 6)
	end
	var13 = helper_dff48a5c(var13)
	var12 = vm.f32(vm.f32(var12 * vm.f32(3.1415927)) / 180.0)
	var13 = vm.f32(var13 - vm.f32(var13 * var12))
	var23 = vm.f32(vm.sin(var7) * vm.f32(var13 * vm.cos(var12)))
	var24 = vm.f32(var13 * vm.sin(var12))
	var25 = vm.f32(vm.cos(var7) * vm.f32(var13 * vm.cos(var12)))
	var17 = vm.f32(vm.f32(var17 * vm.f32(3.1415927)) / 2.0)
	var18 = vm.f32(vm.f32(vm.f32(-var25 * var14) * var16) * vm.f32(0.4))
	var16 = vm.f32(vm.f32(vm.f32(-var23 * var14) * var16) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.SphidaGetPinPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var30 = 0
	var15 = 0
	var43 = 0
	do
		local out1, out2, out3, out4, out5 =
			event.ChkIntersectionPoint_13(0, var3, var4 + 5.0, var5, var3, var4, var5, 0)
		var31 = out1 or var31
		var32 = out2 or var32
		var33 = out3 or var33
		var42 = out4 or var42
		var44 = out5 or var44
	end
	if var42 >= 0 and (var44 == 1 or var44 == 7) then
		print("----------------START_MIZU-------------------\n")
		var13 = 1.0
	else
		print("----------------START_SOTO-------------------\n")
		var13 = 0.0
	end
	var47 = 0
	while true do
		if var4 >= 180.0 then
			var23 = vm.f32(var23 * vm.f32(0.999))
			var24 = vm.f32(var24 + vm.f32(vm.f32(-0.0098) * (var47 + 1)))
			var25 = vm.f32(var25 * vm.f32(0.999))
		else
			var42 = event.ChkIntersectionPoint_9(12, var3, var4, var5, var3, vm.f32(var4 - 3.0) - vm.f32(0.01), var5, 0)
				or var42
			if var15 == 1 and var42 >= 0 then
				var23 = vm.f32(var23 * vm.f32(0.94))
				var24 = vm.f32(var24 + vm.f32(vm.f32(-0.00045) * (var47 + 1)))
				var25 = vm.f32(var25 * vm.f32(0.94))
				var23 = vm.f32(var23 + var16)
				var25 = vm.f32(var25 + var18)
				var16 = vm.f32(var16 * vm.f32(0.8))
				var18 = vm.f32(var18 * vm.f32(0.8))
			else
				var23 = vm.f32(var23 * vm.f32(0.999))
				var24 = vm.f32(var24 + vm.f32(vm.f32(-0.0045) * (var47 + 1)))
				var25 = vm.f32(var25 * vm.f32(0.999))
			end
		end
		do
			local out1, out2, out3 = event.AddVector(var3, var4, var5, var23, var24, var25)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		if var17 ~= 0.0 then
			var12 = event.GetRefAngle(var19, var20, var21, var3, var4, var5) or var12
			var12 = vm.f32(var12 + var17)
			var12 = event.AngleLimit(var12) or var12
			var23 = vm.f32(var23 + vm.f32(vm.f32(vm.sin(var12) / 10.0) * var14))
			var25 = vm.f32(var25 + vm.f32(vm.f32(vm.cos(var12) / 10.0) * var14))
		end
		var41 = event.DistVector(var16, 0.0, var18) or var41
		if var41 > vm.f32(0.01) then
			var26 = event.DistVector(var16, 0.0, var18) or var26
			var12 = event.GetRefAngle(var19, var20, var21, var19 + var16, var20, var21 + var18) or var12
			do
				local out1, out2, out3 = event.GetCharaRot(8)
				var6 = out1 or var6
				var7 = out2 or var7
				var8 = out3 or var8
			end
			event.SetCharaRot(8, var6, var12, var8)
			event.AddCharaRot(8, var26 * 12.0, 0.0, 0.0)
			event.SetCharaRot(9, var6, var12, var8)
			event.AddCharaRot(9, var26 * 12.0, 0.0, 0.0)
		else
			var26 = event.DistVector(var23, 0.0, var25) or var26
			var12 = event.GetRefAngle(var19, var20, var21, var3, var4, var5) or var12
			do
				local out1, out2, out3 = event.GetCharaRot(8)
				var6 = out1 or var6
				var7 = out2 or var7
				var8 = out3 or var8
			end
			event.SetCharaRot(8, var6, var12, var8)
			event.AddCharaRot(8, var26 / 10.0, 0.0, 0.0)
			event.SetCharaRot(9, var6, var12, var8)
			event.AddCharaRot(9, var26 / 10.0, 0.0, 0.0)
		end
		var26 = event.DistVector(var23, var24, var25) or var26
		var40 = var26
		var12 = event.GetRefAngle(var19, var20, var21, var3, var4, var5) or var12
		var37 = vm.f32(vm.sin(vm.f32(var12 - vm.f32(1.5707964))) * 3.0)
		var39 = vm.f32(vm.cos(vm.f32(var12 - vm.f32(1.5707964))) * 3.0)
		event.SwordEffectAddPoint(
			var3 - var37,
			var4,
			var5 - var39,
			vm.f32(var3 + var37) + var37,
			var4,
			vm.f32(var5 + var39) + var39
		)
		do
			local out1, out2, out3 = event.CopyVector(var23, var24, var25)
			var37 = out1 or var37
			var38 = out2 or var38
			var39 = out3 or var39
		end
		do
			local out1, out2, out3 = event.NormalVector(var37, var38, var39)
			var37 = out1 or var37
			var38 = out2 or var38
			var39 = out3 or var39
		end
		do
			local out1, out2, out3 = event.ScaleVector(var37, var38, var39, 3.0)
			var37 = out1 or var37
			var38 = out2 or var38
			var39 = out3 or var39
		end
		do
			local out1, out2, out3, out4, out5 =
				event.ChkIntersectionPoint_13(0, var19, var20, var21, var3 + var37, var4 + var38, var5 + var39, 0)
			var31 = out1 or var31
			var32 = out2 or var32
			var33 = out3 or var33
			var42 = out4 or var42
			var44 = out5 or var44
		end
		if var42 >= 0 and (var44 == 1 or var44 == 7) then
			event.EsmCreate("足水パシャ")
			event.EsmSetVect1(var31, var32, var33)
			if var43 <= 0 then
				event.SndSePlay(var2, 11)
				var43 = 10
			end
			if var13 == 0.0 then
				var13 = 1.0
				var23 = vm.f32(var23 * vm.f32(0.4))
				var24 = vm.f32(var24 * vm.f32(0.4))
				var25 = vm.f32(var25 * vm.f32(0.4))
				var16 = 0.0
				var18 = 0.0
				event.DeleteSwordEffect()
				print("----------------SE OFF-------------------\n")
			else
				var13 = 0.0
				print("----------------SE ON-------------------\n")
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				event.ChkIntersectionPoint_15(12, var19, var20, var21, var3 + var37, var4 + var38, var5 + var39, 1)
			var31 = out1 or var31
			var32 = out2 or var32
			var33 = out3 or var33
			var34 = out4 or var34
			var35 = out5 or var35
			var36 = out6 or var36
			var42 = out7 or var42
		end
		if var42 < 0 then
			if var4 >= 380.0 and var24 > 0.0 then
				do
					local out1, out2, out3 = event.CopyVector(var3, var4, var5)
					var31 = out1 or var31
					var32 = out2 or var32
					var33 = out3 or var33
				end
				do
					local out1, out2, out3 = event.CopyVector(var23, -var24, var25)
					var34 = out1 or var34
					var35 = out2 or var35
					var36 = out3 or var36
				end
				do
					local out1, out2, out3 = event.NormalVector(var34, var35, var36)
					var34 = out1 or var34
					var35 = out2 or var35
					var36 = out3 or var36
				end
				var42 = 1
			end
		end
		while var42 >= 0 do
			var17 = 0.0
			if var26 > 8.0 then
				helper_79d90c82()
			end
			if var13 ~= 1.0 and var43 <= 0 then
				event.SndSePlay(var2, 6)
				var43 = 10
			end
			do
				local out1, out2, out3 = event.CopyVector(-var23, -var24, -var25)
				var23 = out1 or var23
				var24 = out2 or var24
				var25 = out3 or var25
			end
			do
				local out1, out2, out3 = event.NormalVector(var23, var24, var25)
				var23 = out1 or var23
				var24 = out2 or var24
				var25 = out3 or var25
			end
			do
				local out1, out2, out3 = event.ScaleVector(var23, var24, var25, 3.0)
				var23 = out1 or var23
				var24 = out2 or var24
				var25 = out3 or var25
			end
			do
				local out1, out2, out3 = event.AddVector(var31, var32, var33, var23, var24, var25)
				var31 = out1 or var31
				var32 = out2 or var32
				var33 = out3 or var33
			end
			do
				local out1, out2, out3 = event.SubVector(var19, var20, var21, var31, var32, var33)
				var19 = out1 or var19
				var20 = out2 or var20
				var21 = out3 or var21
			end
			var41 = event.DistVector(var19, var20, var21) or var41
			var41 = vm.f32(var40 - var41)
			if var41 <= 0.0 then
				break
			else
				var40 = var41
				do
					local out1, out2, out3 = event.CopyVector(-var23, -var24, -var25)
					var23 = out1 or var23
					var24 = out2 or var24
					var25 = out3 or var25
				end
				if var24 < 0.0 and var35 > 0.0 then
					var23 = vm.f32(var16 * 2.0)
					var24 = 0.0
					var25 = vm.f32(var18 * 2.0)
					var16 = vm.f32(var16 * vm.f32(0.2))
					var18 = vm.f32(var18 * vm.f32(0.2))
				else
					if
						var23 < 0.0 and var34 > 0.0
						or var23 > 0.0 and var34 < 0.0
						or var25 < 0.0 and var36 > 0.0
						or var25 > 0.0 and var36 < 0.0
					then
						var16 = 0.0
						var18 = 0.0
					end
					var23 = 0.0
					var24 = 0.0
					var25 = 0.0
				end
				if var13 == 0.0 then
					var23 = vm.f32(vm.f32(vm.f32(var34 * var26) * vm.f32(0.9)) + var23)
					var24 = vm.f32(vm.f32(vm.f32(var35 * var26) * vm.f32(0.58)) + var24)
					var25 = vm.f32(vm.f32(vm.f32(var36 * var26) * vm.f32(0.9)) + var25)
				else
					print("MIZU______1--------------------------------------------------------------------\n")
					var23 = vm.f32(vm.f32(vm.f32(var34 * var26) * vm.f32(0.8)) + var23)
					var24 = vm.f32(vm.f32(vm.f32(var35 * var26) * vm.f32(0.4)) + var24)
					var25 = vm.f32(vm.f32(vm.f32(var36 * var26) * vm.f32(0.8)) + var25)
				end
				do
					local out1, out2, out3 = event.CopyVector(var31, var32, var33)
					var19 = out1 or var19
					var20 = out2 or var20
					var21 = out3 or var21
				end
				do
					local out1, out2, out3 = event.CopyVector(var23, var24, var25)
					var37 = out1 or var37
					var38 = out2 or var38
					var39 = out3 or var39
				end
				do
					local out1, out2, out3 = event.NormalVector(var37, var38, var39)
					var37 = out1 or var37
					var38 = out2 or var38
					var39 = out3 or var39
				end
				do
					local out1, out2, out3 = event.ScaleVector(var37, var38, var39, 3.0)
					var37 = out1 or var37
					var38 = out2 or var38
					var39 = out3 or var39
				end
				do
					local out1, out2, out3 = event.ScaleVector(var34, var35, var36, var41)
					var34 = out1 or var34
					var35 = out2 or var35
					var36 = out3 or var36
				end
				do
					local out1, out2, out3 = event.CopyVector(var31, var32, var33)
					var3 = out1 or var3
					var4 = out2 or var4
					var5 = out3 or var5
				end
				do
					local out1, out2, out3 = event.AddVector(var3, var4, var5, var34, var35, var36)
					var3 = out1 or var3
					var4 = out2 or var4
					var5 = out3 or var5
				end
				do
					local out1, out2, out3, out4, out5, out6, out7, out8 = event.ChkIntersectionPoint_16(
						12,
						var19,
						var20,
						var21,
						var3 + var37,
						var4 + var38,
						var5 + var39,
						1
					)
					var31 = out1 or var31
					var32 = out2 or var32
					var33 = out3 or var33
					var34 = out4 or var34
					var35 = out5 or var35
					var36 = out6 or var36
					var42 = out7 or var42
					var44 = out8 or var44
				end
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7, out8 =
				event.ChkIntersectionPoint_16(12, var3, var4, var5, var3, var4 - 3.0, var5, 1)
			var31 = out1 or var31
			var32 = out2 or var32
			var33 = out3 or var33
			var34 = out4 or var34
			var35 = out5 or var35
			var36 = out6 or var36
			var42 = out7 or var42
			var44 = out8 or var44
		end
		if var42 >= 0 then
			var17 = 0.0
			var4 = vm.f32(var32 + 3.0)
			var41 = event.DistVector(var23, 0.0, var25) or var41
			if var41 < vm.f32(2.6) or var24 >= -1.0 and var24 <= 0.0 then
				var24 = 0.0
				var15 = 1
			else
				if var13 == 0.0 then
					var23 = vm.f32(var23 * vm.f32(0.9))
					var24 = -vm.f32(var24 * vm.f32(0.58))
					var25 = vm.f32(var25 * vm.f32(0.9))
					var23 = vm.f32(var23 + vm.f32(var16 * 2.0))
					var25 = vm.f32(var25 + vm.f32(var18 * 2.0))
					var16 = vm.f32(var16 * vm.f32(0.2))
					var18 = vm.f32(var18 * vm.f32(0.2))
				else
					print("MIZU______2--------------------------------------------------------------------\n")
					var23 = vm.f32(var23 * vm.f32(0.8))
					var24 = -vm.f32(var24 * vm.f32(0.4))
					var25 = vm.f32(var25 * vm.f32(0.8))
					var16 = 0.0
					var18 = 0.0
				end
				if var26 > 8.0 then
					helper_79d90c82()
				end
				if var13 ~= 1.0 and var43 <= 0 then
					event.SndSePlay(var2, 5)
					var43 = 10
				end
			end
			var41 = event.DistVector(var16, 0.0, var18) or var41
			if var24 == 0.0 and var26 < vm.f32(1.6) and var41 < vm.f32(0.4) then
				if var44 == 6 then
					var30 = 1
					break
				end
				var44 = event.AmgGetAttrStatus(var3, var4, var5) or var44
				if not (var44 == 1) then
					break
				end
				var30 = 1
				break
			end
		end
		if var4 < -500.0 then
			var30 = 1
			break
		elseif var47 >= 480 then
			var30 = 1
			break
		else
			var45 = event.SphidaGetPinCol() or var45
			var46 = event.SphidaGetBallCol() or var46
			x = vm.f32(pos_x - var3)
			y = vm.f32(pos_y - var4)
			z = vm.f32(pos_z - var5)
			var48 = event.DistVector(x, y, z) or var48
			if var46 ~= var45 then
				var52 = event.LinePointDist(var19, var20, var21, var3, var4, var5, pos_x, pos_y, pos_z) or var52
				if var52 >= 0.0 and var52 <= 30.0 then
					var22 = 1
					break
				end
				if var48 ~= 0.0 then
					if var48 <= 120.0 then
						do
							local out1, out2, out3 = event.ScaleVector(x, y, z, vm.fdiv(vm.f32(0.6), var48))
							x = out1 or x
							y = out2 or y
							z = out3 or z
						end
						do
							local out1, out2, out3 = event.AddVector(var3, var4, var5, x, y, z)
							var3 = out1 or var3
							var4 = out2 or var4
							var5 = out3 or var5
						end
						do
							local out1, out2, out3 = event.AddVector(var23, var24, var25, x, y, z)
							var23 = out1 or var23
							var24 = out2 or var24
							var25 = out3 or var25
						end
					end
				else
					var22 = 1
					break
				end
			elseif var48 ~= 0.0 then
				if var48 <= 60.0 then
					do
						local out1, out2, out3 = event.ScaleVector(x, y, z, vm.fdiv(1.0, var48))
						x = out1 or x
						y = out2 or y
						z = out3 or z
					end
					do
						local out1, out2, out3 = event.SubVector(var3, var4, var5, x, y, z)
						var3 = out1 or var3
						var4 = out2 or var4
						var5 = out3 or var5
					end
					do
						local out1, out2, out3 = event.SubVector(var23, var24, var25, x, y, z)
						var23 = out1 or var23
						var24 = out2 or var24
						var25 = out3 or var25
					end
				end
			end
			event.SetCharaPos(8, var3, var4, var5)
			event.SetCharaPos(9, var3, var4, var5)
			do
				local out1, out2, out3 = event.CopyVector(var3, var4, var5)
				var19 = out1 or var19
				var20 = out2 or var20
				var21 = out3 or var21
			end
			if var4 <= -50.0 then
				event.SetFcameraFollowFlag(0)
				if var30 >= 30 then
					if var30 >= 50 then
						break
					end
				else
					event.SetCameraRef(var3, var4, var5)
				end
				var30 = var30 + 1
			elseif var47 >= 20 then
				event.CtrlcMoveRange(20.0, 30.0, 60.0, 200.0)
				event.SetCameraSpeed(8.0)
				event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
				event.SetFcameraFollow(
					vm.f32(var3 + var23) + var23,
					vm.f32(var4 + var24) + var24,
					vm.f32(var5 + var25) + var25
				)
				do
					local out1, out2, out3 = event.GetCameraPos()
					pos_x_2 = out1 or pos_x_2
					pos_y_2 = out2 or pos_y_2
					pos_z_2 = out3 or pos_z_2
				end
				yaw = event.GetRefAngle(
					vm.f32(var3 + var23) + var23,
					vm.f32(var4 + var24) + var24,
					vm.f32(var5 + var25) + var25,
					pos_x_2,
					pos_y_2,
					pos_z_2
				) or yaw
				event.CtrlcSetRotate(yaw)
				event.CtrlcMoveCamera(8)
				event.CtrlcStep()
			end
			event.SphidaSetBallPos(var3, var4, var5)
			vm.wait(15)
			if var43 > 0 then
				var43 = var43 - 1
			end
			var47 = var47 + 1
		end
	end
	event.SetCharaPos(8, var3, var4, var5)
	event.SetCharaPos(9, var3, var4, var5)
	event.SphidaSetStatusFlag(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var30 == 0 then
		event.SphidaSetBallPos(var3, var4, var5)
		count = event.SphidaGetParCount() or count
		if var22 == 1 then
			event.CharaActive(0, 0)
			event.CharaActive(0, 8)
			event.CharaActive(0, 9)
			event.CharaActive(1, 12)
			event.SetCharaPos(12, pos_x, pos_y, pos_z)
			event.SetMotion(12, "発動", 6)
			event.SndSePlay(var2, 17)
			var47 = 0
			while var47 < 2 do
				event.SetCameraCtrl(0)
				event.SetFcameraFollowFlag(1)
				event.SetFcameraFollowA(pos_x, pos_y, pos_z)
				event.SetCameraSpeed(12.0)
				event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
				event.SetFcameraHeight(0.0)
				event.SetFcameraDist(100.0)
				event.FcameraStep(1)
				var47 = var47 + 1
				vm.wait(16)
			end
			event.CharaActive(0, 10)
			do
				local out1, out2, out3 = event.SphidaGetPinPos()
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			var47 = 0
			while var47 < 100 do
				event.SetCameraCtrl(0)
				event.SetFcameraFollowFlag(1)
				event.SetFcameraFollowA(pos_x, pos_y, pos_z)
				event.SetCameraSpeed(12.0)
				event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
				event.SetFcameraHeight(0.0)
				event.SetFcameraDist(100.0)
				event.FcameraStep(1)
				var47 = var47 + 1
				vm.wait(17)
			end
			event.CharaActive(0, 11)
			var45 = event.DngGetStageId() or var45
			var46 = event.DngGetFloorId() or var46
			var42 = event.GetFloorInfo(var45, var46, 4) or var42
			do
				local out1, out2 = event.SphidaGetPrize(var42)
				var43 = out1 or var43
				var44 = out2 or var44
			end
			var42 = vm.i32(var42 + 1)
			event.SetFloorInfo(var45, var46, 4, var42)
			if var0 == 0 then
				event.PostTreasureBox(pos_x, pos_y - 30.0, pos_z, var12, var43)
			end
			helper_888ab2a3(54)
			helper_888ab2a3(30)
			event.DeleteChara(8)
			event.DeleteChara(9)
			event.DeleteChara(10)
			event.DeleteChara(11)
			event.SphidaSetPlayFlag(0)
			var2 = event.SndLoadSound_3(8, "snd2/sp/sp_000.sound.json") or var2
			event.StopBgm(0)
			event.SndSePlay(var2, 0)
			event.CharaActive(1, 0)
			event.SetFcameraFollowFlag(0)
			event.SetCameraCtrl(0)
			event.CmrsInit()
			event.CmrsSyncObj(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
			event.ObjsSetMotion(0, "カップインポーズ", 6)
			event.ObjsNormalDrive(0)
			event.ObjsNextMotion(0, "カップインポーズL", 4)
			event.ObjsResetDaPosition(0)
			var43 = event.GetLanguage() or var43
			if var43 == 0 then
				event.SpriteInit(0)
				event.SpriteSetType(0, 0)
				event.SpriteSetTexture(0, "sphida_bar", tex_bank)
				event.SpriteSetUvsize(0, 258, 0, 254, 54)
				event.SpriteSetPos(0, 256, 208)
				event.SpriteSetPutsize(0, 254, 54)
				event.SpriteSetColor(0, 128, 128, 128, 0)
				event.SpriteSetScale(0, 5.0, 5.0)
				event.SpriteSetDraw(0, 1)
			else
				event.SpriteInit(0)
				event.SpriteSetType(0, 0)
				event.SpriteSetTexture(0, "sphida_bar", tex_bank)
				event.SpriteSetUvsize(0, 206, 0, 306, 54)
				event.SpriteSetPos(0, 256, 208)
				event.SpriteSetPutsize(0, 254, 54)
				event.SpriteSetColor(0, 128, 128, 128, 0)
				event.SpriteSetScale(0, 5.0, 5.0)
				event.SpriteSetDraw(0, 1)
			end
			event.EohSyncSprite(1, 0)
			event.ObjsInit(1)
			event.ObjsSyncObj(1, 1)
			event.ObjsSetScale(1, 1.0, 1.0, 0.0, 60)
			event.ObjsSetColor(1, 128, 128, 128, 128, 60)
			helper_0958ca60(0)
			helper_888ab2a3(90)
			vm.wait(22)
			event.PlayBgm(0)
			if var0 == 1 then
				count = vm.i32(count + 2)
				event.SpriteInit(0)
				event.SpriteSetType(0, 0)
				event.SpriteSetTexture(0, "omake_sfida", tex_bank)
				event.SpriteSetUvsize(0, 182, 38, 80, 34)
				event.SpriteSetPos(0, 256, 192)
				event.SpriteSetPutsize(0, 80, 34)
				event.SpriteSetColor(0, 128, 128, 128, 128)
				event.SpriteSetDraw(0, 1)
				event.SpriteInit(1)
				event.SpriteSetType(1, 0)
				event.SpriteSetTexture(1, "omake_sfida", tex_bank)
				event.SpriteSetUvsize(1, 280, 96, 28, 32)
				event.SpriteSetPos(1, 174, 224)
				event.SpriteSetPutsize(1, 28, 32)
				event.SpriteSetColor(1, 128, 128, 128, 128)
				event.SpriteSetDraw(1, 1)
				event.SpriteInit(2)
				event.SpriteSetType(2, 0)
				event.SpriteSetTexture(2, "omake_sfida", tex_bank)
				event.SpriteSetUvsize(2, 126, 0, 114, 38)
				event.SpriteSetPos(2, 296, 224)
				event.SpriteSetPutsize(2, 114, 38)
				event.SpriteSetColor(2, 128, 128, 128, 128)
				event.SpriteSetDraw(2, 1)
				event.SpriteInit(3)
				event.SpriteSetType(3, 0)
				event.SpriteSetTexture(3, "omake_sfida", tex_bank)
				event.SpriteSetUvsize(3, vm.i32(vm.imod(count, 10) * 28), 96, 28, 32)
				event.SpriteSetPos(3, 228, 224)
				event.SpriteSetPutsize(3, 28, 32)
				event.SpriteSetColor(3, 128, 128, 128, 128)
				event.SpriteSetDraw(3, 1)
				if vm.idiv(count, 10) > 0 then
					event.SpriteInit(4)
					event.SpriteSetType(4, 0)
					event.SpriteSetTexture(4, "omake_sfida", tex_bank)
					event.SpriteSetUvsize(4, vm.i32(vm.idiv(count, 10) * 28), 96, 28, 32)
					event.SpriteSetPos(4, 204, 224)
					event.SpriteSetPutsize(4, 28, 32)
					event.SpriteSetColor(4, 128, 128, 128, 128)
					event.SpriteSetDraw(4, 1)
				end
				while true do
					if helper_581cb30c(0) ~= 0 then
						break
					else
						vm.wait(23)
					end
				end
				var0 = event.SphidaGetNowHole() or var0
				if var0 == 8 then
					event.SphidaSetScore(-1, count)
					helper_eedf6c6c()
				end
				event.SetFadeOut(30)
				helper_888ab2a3(30)
				event.SpriteSetDraw(0, 0)
				event.SpriteSetDraw(1, 0)
				event.SpriteSetDraw(2, 0)
			end
			event.CmrsReleaseObj()
			event.SpriteSetDraw(0, 0)
		elseif count >= 2 then
			event.SetMesWindowMode(0, 5)
			event.SetMesQuestionGyou(0, 0)
			var58 = helper_c190f878(0, 2002, 8, 256, 208, 2, 0)
			vm.wait(27)
			if var58 == 0 then
				do
					local out1, out2, out3, out4 = event.GetPartsFuncPos(var3, var4, var5, 100.0, "point")
					var42 = out1 or var42
					var9 = out2 or var9
					var10 = out3 or var10
					var11 = out4 or var11
				end
				if var42 == 0 then
					do
						local out1, out2, out3 = event.GetPartsOrigin(var3, var4, var5, 100.0)
						var9 = out1 or var9
						var10 = out2 or var10
						var11 = out3 or var11
					end
				end
				do
					local out1, out2, out3 = event.SphidaGetPinPos()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				var26 = event.DistVector2(var9, var10, var11, pos_x, pos_y, pos_z) or var26
				if var26 < 40.0 then
					var12 = event.GetRand(6.2831855) or var12
					var12 = vm.f32(var12 - vm.f32(3.1415927))
					var9 = vm.f32(var9 + vm.f32(vm.sin(var12) * 50.0))
					var11 = vm.f32(var11 + vm.f32(vm.cos(var12) * 50.0))
				else
					do
						local out1, out2, out3, out4 = event.GetNearTboxPos(var9, var10, var11)
						var31 = out1 or var31
						var32 = out2 or var32
						var33 = out3 or var33
						var42 = out4 or var42
					end
					var47 = 0
					while var42 >= 0 do
						do
							local out1, out2, out3 = event.CopyVector(var9, var10, var11)
							var19 = out1 or var19
							var20 = out2 or var20
							var21 = out3 or var21
						end
						do
							local out1, out2, out3 = event.SubVector(var19, var20, var21, var31, var32, var33)
							var19 = out1 or var19
							var20 = out2 or var20
							var21 = out3 or var21
						end
						do
							local out1, out2, out3 = event.NormalVector(var19, var20, var21)
							var19 = out1 or var19
							var20 = out2 or var20
							var21 = out3 or var21
						end
						do
							local out1, out2, out3 = event.ScaleVector(var19, var20, var21, 32.0)
							var19 = out1 or var19
							var20 = out2 or var20
							var21 = out3 or var21
						end
						do
							local out1, out2, out3 = event.CopyVector(var31, var32, var33)
							var9 = out1 or var9
							var10 = out2 or var10
							var11 = out3 or var11
						end
						do
							local out1, out2, out3 = event.AddVector(var9, var10, var11, var19, var20, var21)
							var9 = out1 or var9
							var10 = out2 or var10
							var11 = out3 or var11
						end
						do
							local out1, out2, out3, out4 = event.GetNearTboxPos(var9, var10, var11)
							var31 = out1 or var31
							var32 = out2 or var32
							var33 = out3 or var33
							var42 = out4 or var42
						end
						var47 = var47 + 1
						if var47 > 6 then
							break
						end
					end
				end
				var7 = event.GetRefAngle(var9, var10, var11, var3, var4, var5) or var7
				event.SetCharaPos(0, var9, var10, var11)
				event.SetCharaRot(0, 0.0, var7, 0.0)
				event.SetCameraRef(var9, var10 + 30.0, var11)
				var7 = vm.f32(var7 - vm.f32(3.1415927))
				var7 = event.AngleLimit(var7) or var7
				var9 = vm.f32(vm.f32(vm.sin(var7) * 100.0) + var9)
				var10 = vm.f32(var10 + 30.0)
				var11 = vm.f32(vm.f32(vm.cos(var7) * 100.0) + var11)
				event.SetCameraPos(var9, var10, var11)
				event.ResetCamera(0)
			end
		end
	else
		event.SndSePlay(var2, 18)
		event.SetFcameraFollowFlag(0)
		event.SetCameraCtrl(0)
		event.CmrsInit()
		event.CmrsSyncObj(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
		event.ObjsSetMotion(0, "だめだめ", 6)
		event.ObjsNormalDrive(0)
		event.ObjsNextMotion(0, "立ち", 4)
		event.ObjsResetDaPosition(0)
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "sphida_bar", tex_bank)
		event.SpriteSetUvsize(0, 334, 54, 178, 34)
		event.SpriteSetPos(0, 256, -25)
		event.SpriteSetPutsize(0, 160, 50)
		event.SpriteSetColor(0, 128, 128, 128, 128)
		event.SpriteSetDraw(0, 1)
		event.EohSyncSprite(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.ObjsJump(1, 256.0, 208.0, 0.0, 1.2, 16)
		event.ObjsJump(1, 256.0, 208.0, 0.0, 2.0, 12)
		event.ObjsJump(1, 256.0, 208.0, 0.0, 1.5, 8)
		helper_0958ca60(0)
		helper_888ab2a3(20)
		event.SpriteSetDraw(0, 0)
		event.SphidaSetBallPos(var9, var10, var11)
		event.SetCharaPos(8, var9, var10, var11)
		event.SetCharaPos(9, var9, var10, var11)
		event.CmrsReleaseObj()
	end
	if var22 == 1 then
		helper_f90045b0(-1)
	else
		helper_f90045b0(var2)
	end
	helper_166cb93a(var22)
end

--- The Sphida event run when the menu button is pressed near the ball.
function script.sphida_near_ball()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	event.Initialize()
	helper_ce85b54c()
	event.SetMesWindowMode(0, 5)
	event.SetMesQuestionGyou(0, 0)
	var0 = helper_c190f878(0, 2004, 8, 0, 0, 2, 1)
	if var0 == 0 then
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.SphidaSetBallPos(var1, var2 + 3.0, var3)
		event.SetCharaPos(8, var1, var2 + 3.0, var3)
		event.SetCharaPos(9, var1, var2 + 3.0, var3)
		helper_f90045b0(-1)
		event.SetCrossfade(15)
	end
	vm.wait(2)
	event.Finish()
end

--- The Sphida event run when the menu button is pressed near the ball with fewer than two shots of par left.
function script.sphida_near_ball_last()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	event.Initialize()
	helper_ce85b54c()
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "スフィアを足元へ移動できるのは\nこれが最後になります。")
	helper_9e7d1511(0, -1, 8, 0, 0)
	event.SetMesWindowMode(0, 5)
	event.SetMesQuestionGyou(0, 0)
	event.MesMake_2(0, "スフィアを足元へ移動しますか？")
	var0 = helper_c190f878(0, -1, 8, 0, 0, 2, 1)
	if var0 == 0 then
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.SphidaSetBallPos(var1, var2 + 3.0, var3)
		event.SetCharaPos(8, var1, var2 + 3.0, var3)
		event.SetCharaPos(9, var1, var2 + 3.0, var3)
		event.SphidaSetLastChallenge(1)
		event.SetCrossfade(15)
	end
	vm.wait(3)
	event.Finish()
end

--- The Sphida event run when the menu button is pressed away from the ball on a bonus course.
function script.sphida_omake_away()
	local var0: any = 0
	local get_now_horl: s32 = 0
	event.Initialize()
	helper_ce85b54c()
	event.SetMesWindowMode(0, 5)
	event.SetMesQuestionGyou(0, 0)
	get_now_horl = event.SphidaGetNowHole() or get_now_horl
	if get_now_horl == 8 then
		event.MesMake_2(0, "最終ホールですが、\nこのホールをあきらめますか？")
		var0 = helper_c190f878(0, -1, 8, 0, 0, 2, 1)
		if var0 == 0 then
			helper_eedf6c6c()
			event.SetFadeOut(30)
			helper_888ab2a3(30)
			helper_7b560508()
			helper_c44453a9()
			return
		end
	else
		event.MesMake_2(0, "このホールをあきらめて\n次のコースに挑戦しますか？")
		var0 = helper_c190f878(0, -1, 8, 0, 0, 2, 1)
		if var0 == 0 then
			event.SetFadeOut(30)
			helper_888ab2a3(30)
			helper_7982ab52()
		end
	end
	vm.wait(7)
	event.Finish()
end

--- Event 6000, which map data, a script or the engine runs by number.
function script.event_6000()
	event.Initialize()
	helper_e91d3484()
	event.SetFadeOut(0)
	vm.wait(1)
	vm.wait(2)
	event.BgmLoadCancel()
	event.DngSetFloorId(0)
	event.LoadDungeonMapFile("d05f01", "mstage4", 64)
	event.AddItem(305, 1)
	event.AddItem(306, 1)
	helper_f680702c(2, 4)
	event.SphidaSetNowHole(4)
	event.SetCharaPos(0, 1600.0, 0.0, 5600.0)
	event.SetCharaRot(0, 0.0, 3.14, 0.0)
	event.SetCameraRef(1600.0, 30.0, 5600.0)
	event.SetCameraPos(1600.0, 40.0, 5700.0)
	event.SetFadeIn(30)
	helper_888ab2a3(30)
	event.GotoMenu(28)
	vm.wait(4)
	event.ResetCamera(0)
	event.Finish()
end

--- Event 6001, which map data, a script or the engine runs by number.
function script.event_6001()
	event.Initialize()
	helper_e91d3484()
	event.SetFadeOut(0)
	vm.wait(1)
	vm.wait(2)
	event.BgmLoadCancel()
	event.DngSetFloorId(0)
	event.LoadDungeonMapFile("d05f02", "mstage5", 64)
	event.AddItem(305, 1)
	event.AddItem(306, 1)
	helper_f680702c(2, 5)
	event.SphidaSetNowHole(5)
	event.SetCharaPos(0, 2800.0, 0.0, 800.0)
	event.SetCharaRot(0, 0.0, -1.57, 0.0)
	event.SetCameraRef(2800.0, 30.0, 800.0)
	event.SetCameraPos(2900.0, 40.0, 800.0)
	event.SetFadeIn(30)
	helper_888ab2a3(30)
	event.GotoMenu(28)
	vm.wait(4)
	event.ResetCamera(0)
	event.Finish()
end

return script
