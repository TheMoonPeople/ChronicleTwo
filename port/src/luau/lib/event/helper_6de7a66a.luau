--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_28933606 = require("@lib/event/helper_28933606")
local helper_453b483e = require("@lib/event/helper_453b483e")
local helper_6018bc39 = require("@lib/event/helper_6018bc39")
local helper_63852c63 = require("@lib/event/helper_63852c63")
local helper_6d6976ae = require("@lib/event/helper_6d6976ae")
local helper_a3bafe46 = require("@lib/event/helper_a3bafe46")
local helper_aa09e49d = require("@lib/event/helper_aa09e49d")
local helper_b1338111 = require("@lib/event/helper_b1338111")
local helper_b5a602e1 = require("@lib/event/helper_b5a602e1")

--- Helper function.
local function helper_6de7a66a(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local count_2: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local var14: s32 = 0
	local stage_id: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_a3bafe46(15)
		end
		if at <= 3 then
			helper_aa09e49d(0)
		end
		if at <= 4 then
			helper_a3bafe46(5)
		end
		if at <= 5 then
			helper_6d6976ae()
		end
		if at <= 6 then
			helper_a3bafe46(5)
		end
		if at <= 7 then
			var6 = helper_63852c63(var6)
		end
		if at <= 8 then
			var7 = helper_b5a602e1(13, arg0, var7)
			var6 = helper_453b483e(var6)
		end
		if at <= 9 then
			helper_6018bc39()
		end
		if at <= 10 then
			argc = 0
			argc_2 = 0
			helper_28933606(arg0, count_2)
		end
		if at <= 11 then
			helper_b1338111(0, -1, 8, 0, 0)
		end
		if at <= 12 then
			print("CHECK_GET_ITEM_LIMIT = ", argc, "\n")
			print("CHECK_ITEM_OVER      = ", argc_2, "\n")
			helper_a3bafe46(10)
		end
		if at <= 14 then
			helper_b1338111(0, 2240, 8, 0, 0)
		end
		if at <= 15 then
			helper_b1338111(0, 2250, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.DngPause(535, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	do
		local out1, out2, out3, out4 = event.GetDunWorldCoord(1)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
		var5 = out4 or var5
	end
	event.SetWorldCoord(var2, var3, var4, var5)
	if vm.wait() then
		return skip(2)
	end
	if arg0 >= 0 then
		event.SetLoadbgFile(arg0, 1, "effect/itemget.gltf")
	else
		event.SetLoadbgFile("effect/itemget.gltf")
	end
	event.SetTbAngle(0.0)
	event.SetTbStatus(2)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 29.0, 57.0)
	event.CmrsSetRef(0.0, 10.0, 0.0)
	event.CmrsMove(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	helper_a3bafe46(15)
	if vm.skipping() then
		return skip(3)
	end
	helper_aa09e49d(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_a3bafe46(5)
	if vm.skipping() then
		return skip(5)
	end
	helper_6d6976ae()
	if vm.skipping() then
		return skip(6)
	end
	event.LoadChara(5, "effect/itemget.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(1, 12)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 0.0, 0.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "ゲット", 6)
	helper_a3bafe46(5)
	if vm.skipping() then
		return skip(7)
	end
	var6 = helper_63852c63(var6)
	if vm.skipping() then
		return skip(8)
	end
	if arg0 >= 0 then
		event.LoadItem(5, arg0, "info", 13, 1)
		event.CharaActive(1, 13)
		event.EohSyncChara(0, 13)
		var7 = helper_b5a602e1(13, arg0, var7)
		event.EohSetScale(0, var7, var7, var7)
		event.SetCharaShow(13, 1, 1, 0.1)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 0.0, -2.5, 0.0)
		event.ObjsSetRot(0, 0.0, 0.0, 0.0)
		event.ObjsPosDelay(0, 4)
		event.ObjsJump(0, 0.0, 17.0, 0.0, -0.3, 20)
		event.ObjsJump(0, 0.0, 17.0, 0.0, -0.4, 8)
		event.ObjsJump(0, 0.0, 17.0, 0.0, -0.2, 5)
	end
	var6 = helper_453b483e(var6)
	if vm.skipping() then
		return skip(9)
	end
	helper_6018bc39()
	if vm.skipping() then
		return skip(10)
	end
	if arg0 >= 0 then
		argc = 0
		argc_2 = 0
		count_2 = event.CheckGetItemLimit(arg0, arg1) or count_2
		if count_2 >= 1 then
			event.AddItem(arg0, count_2)
			helper_28933606(arg0, count_2)
			if vm.skipping() then
				return skip(11)
			end
		else
			event.SetMesWindowMode(0, 4)
			event.SetMesDrawspeed(0, 1)
			event.SetMesItem(0, 1, arg0)
			event.MesMake_2(
				0,
				"『[アイテム１]』を見つけたが、\nこれ以上このアイテムは持てなかった。"
			)
			helper_b1338111(0, -1, 8, 0, 0)
			if vm.skipping() then
				return skip(12)
			end
			event.SetMesDrawspeed(0, 0)
		end
		argc = event.CheckGetItemLimit() or argc
		argc_2 = event.CheckItemOver() or argc_2
		print("CHECK_GET_ITEM_LIMIT = ", argc, "\n")
		print("CHECK_ITEM_OVER      = ", argc_2, "\n")
		if argc_2 >= 1 then
			event.SetFadeOut(10)
			helper_a3bafe46(10)
			if vm.skipping() then
				return skip(13)
			end
			event.GotoMenu(17)
			if vm.wait() then
				return skip(14)
			end
		end
	else
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		helper_b1338111(0, 2240, 8, 0, 0)
		if vm.skipping() then
			return skip(15)
		end
		event.SetMesDrawspeed(0, 0)
	end
	event.CharaActive(1, 0)
	event.DeleteChara(12)
	event.DeleteChara(13)
	event.SetTbAngle(1.0)
	event.SetCrossfade(10)
	event.SetWorldCoord(0.0, 0.0, 0.0, 0.0)
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
	event.ResetCamera(0)
	var14 = event.GetTrialVersion() or var14
	stage_id = event.DngGetStageId() or stage_id
	if arg0 == 306 and (stage_id == 0 or var14 == 1) then
		event.SetMesWindowMode(0, 4)
		helper_b1338111(0, 2250, 8, 0, 0)
		if vm.skipping() then
			return skip(16)
		end
	end
	event.DngPause(535, 0)
	event.Finish()
end

return helper_6de7a66a
