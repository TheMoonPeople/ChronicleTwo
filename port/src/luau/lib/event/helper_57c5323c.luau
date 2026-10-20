--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5f45f52d = require("@lib/event/helper_5f45f52d")
local helper_c13358ec = require("@lib/event/helper_c13358ec")
local helper_ce4dcc49 = require("@lib/event/helper_ce4dcc49")

--- Helper function.
local function helper_57c5323c(arg0: s32, arg1: any, arg2: any)
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local var13: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local offset_x: f32 = 0
	local offset_y: f32 = 0
	local offset_z: f32 = 0
	local middle_x: f32 = 0
	local var21: f32 = 0
	local middle_z: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local angle: f32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local angle_2: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var27 = var10
			var28 = var15
			angle = vm.f32(var28 - var27)
			var30 = var13
			var31 = var16
			angle_2 = vm.f32(var31 - var30)
			var33 = 0.0
			var34 = vm.f32(helper_c13358ec(helper_ce4dcc49(angle), helper_ce4dcc49(angle_2)) * 8.0)
			var35 = helper_5f45f52d(0.0, angle, var33, var34)
			var35 = vm.f32(var35 + var27)
			var36 = helper_5f45f52d(0.0, angle_2, var33, var34)
			var36 = vm.f32(var36 + var30)
			var33 = vm.f32(var33 + 1.0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	do
		local out1, out2, out3 = event.GetCharaPos(arg0)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local _, out2, _ = event.GetCharaRot(arg0)
		var10 = out2 or var10
	end
	do
		local out1, out2, out3 = event.GetCharaPos(arg1)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local _, out2, _ = event.GetCharaRot(arg1)
		var13 = out2 or var13
	end
	var15 = event.GetRotLookPos(var6 - var3, var8 - var5) or var15
	var16 = event.GetRotLookPos(var3 - var6, var5 - var8) or var16
	if arg2 ~= 0 then
		do
			local out1, out2, out3, out4, out5, out6 = event.SetTalkCamera(var3, var4, var5, var6, var7, var8, var15)
			offset_x = out1 or offset_x
			offset_y = out2 or offset_y
			offset_z = out3 or offset_z
			middle_x = out4 or middle_x
			var21 = out5 or var21
			middle_z = out6 or middle_z
		end
		event.SetCameraPos(offset_x, offset_y, offset_z)
		event.SetCameraRef(middle_x, var21, middle_z)
		event.SetCrossfade(10)
	end
	var27 = var10
	var28 = var15
	angle = vm.f32(var28 - var27)
	angle = event.AngleLimit(angle) or angle
	var30 = var13
	var31 = var16
	angle_2 = vm.f32(var31 - var30)
	angle_2 = event.AngleLimit(angle_2) or angle_2
	if -0.5 < angle and angle < 0.5 then
		event.SetMotion(arg0, "立ち")
	else
		event.SetMotion(arg0, "歩き")
	end
	if -0.5 < angle_2 and angle_2 < 0.5 then
	else
		event.SetMotion(arg1, "歩き")
	end
	var33 = 0.0
	var34 = vm.f32(helper_c13358ec(helper_ce4dcc49(angle), helper_ce4dcc49(angle_2)) * 8.0)
	while var33 < var34 do
		var35 = helper_5f45f52d(0.0, angle, var33, var34)
		var35 = vm.f32(var35 + var27)
		event.SetCharaRot(arg0, 0.0, var35, 0.0)
		var36 = helper_5f45f52d(0.0, angle_2, var33, var34)
		var36 = vm.f32(var36 + var30)
		event.SetCharaRot(arg1, 0.0, var36, 0.0)
		var33 = vm.f32(var33 + 1.0)
		if vm.wait() then
			return skip(2)
		end
	end
	event.SetCharaRot(arg0, 0.0, var15, 0.0)
	event.SetMotion(arg0, "立ち")
	event.SetCharaRot(arg1, 0.0, var16, 0.0)
	event.SetMotion(arg1, "会話")
end

return helper_57c5323c
