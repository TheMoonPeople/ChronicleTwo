--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_34ac0071 = require("@lib/event/helper_34ac0071")
local helper_41c448af = require("@lib/event/helper_41c448af")
local helper_474c5bc8 = require("@lib/event/helper_474c5bc8")

--- Helper function.
local function helper_d5df2b67()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local var9: f32 = 0
	local var10: s32 = 0
	local var11: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_34ac0071()
		end
		if at <= 2 then
			helper_41c448af(0)
		end
		if at <= 3 then
			helper_474c5bc8(30)
		end
	end
	event.ActchrSetDefMotion(0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetLoadbgFile("event/e700/e728/rasen_iwa.gltf", "snd2/sp/sp_049.sound.json")
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.EohGetRot(0)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	var9 = event.GetRefAngle(var0, var1, var2, pos_x, pos_y, pos_z) or var9
	var9 = vm.f32(var9 - vm.f32(3.1415927))
	var9 = event.AngleLimit(var9) or var9
	var10 = 0
	while var10 < 20 do
		event.CtrlcRotBack(var9)
		event.CtrlcMoveCamera(0)
		event.CtrlcStep()
		var10 = var10 + 1
		if vm.wait() then
			return skip(1)
		end
	end
	helper_34ac0071()
	if vm.skipping() then
		return skip(2)
	end
	var11 = event.SndLoadSound(8, "snd2/sp/sp_049.sound.json") or var11
	event.LoadChara(5, "event/e700/e728/rasen_iwa.gltf", "info", 8)
	event.CharaActive(1, 8)
	event.SetCharaPos(8, pos_x, pos_y + 20.0, pos_z)
	event.SetCharaRot(8, rot_x, rot_y, rot_z)
	event.SetMotion(8, "岩消える", 6, 0.6)
	event.SndSePlay(var11, 0)
	event.ObjsMove2(0, pos_x, pos_y - 260.0, pos_z, 60, 1, 1.0)
	event.ResetCamera(0)
	helper_41c448af(0)
	if vm.skipping() then
		return skip(3)
	end
	helper_474c5bc8(30)
	if vm.skipping() then
		return skip(4)
	end
	event.DeleteChara(8)
	event.Finish()
end

return helper_d5df2b67
