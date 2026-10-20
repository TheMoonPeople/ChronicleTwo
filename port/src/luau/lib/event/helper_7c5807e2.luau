--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_cd6c26b6 = require("@lib/event/helper_cd6c26b6")

--- Helper function.
local function helper_7c5807e2(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		arg1 = vm.f32(arg1 + 3.0)
		var7 = 0.0
		var8 = 0.0
		var9 = helper_cd6c26b6(
			arg0,
			arg1,
			arg2,
			vm.f32(vm.f32(arg3 + var8) + vm.f32(1.5707964)),
			vm.f32(vm.f32(arg3 + var7) + vm.f32(1.5707964))
		)
		arg3 = vm.f32(arg3 + var7)
		var9 = helper_cd6c26b6(
			arg0,
			arg1,
			arg2,
			vm.f32(vm.f32(arg3 - var8) + vm.f32(1.5707964)),
			vm.f32(vm.f32(arg3 - var7) + vm.f32(1.5707964))
		)
		arg3 = vm.f32(arg3 - var7)
		var8 = var7
		var7 = vm.f32(var7 + vm.f32(0.3926991))
		return arg0, arg1, arg2, arg3
	end
	if vm.skipping() then
		return skip(1)
	end
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		arg0 = out1 or arg0
		arg1 = out2 or arg1
		arg2 = out3 or arg2
	end
	event.SphidaSetBallPos(arg0, arg1 + 3.0, arg2)
	event.SetCharaPos(8, arg0, arg1 + 3.0, arg2)
	event.SetCharaPos(9, arg0, arg1 + 3.0, arg2)
	arg1 = vm.f32(arg1 + 3.0)
	do
		local out1, out2, out3 = event.SphidaGetPinPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	arg3 = event.GetRefAngle(arg0, arg1, arg2, pos_x, pos_y, pos_z) or arg3
	var7 = 0.0
	var8 = 0.0
	while var7 <= vm.f32(3.1415927) do
		var9 = helper_cd6c26b6(
			arg0,
			arg1,
			arg2,
			vm.f32(vm.f32(arg3 + var8) + vm.f32(1.5707964)),
			vm.f32(vm.f32(arg3 + var7) + vm.f32(1.5707964))
		)
		if var9 == 1 then
			arg3 = vm.f32(arg3 + var7)
			break
		else
			var9 = helper_cd6c26b6(
				arg0,
				arg1,
				arg2,
				vm.f32(vm.f32(arg3 - var8) + vm.f32(1.5707964)),
				vm.f32(vm.f32(arg3 - var7) + vm.f32(1.5707964))
			)
			if var9 == 1 then
				arg3 = vm.f32(arg3 - var7)
				break
			else
				var8 = var7
				var7 = vm.f32(var7 + vm.f32(0.3926991))
			end
		end
	end
	event.SetCharaRot(0, 0.0, arg3, 0.0)
	event.SetMotion(0, "かまえ", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	return arg0, arg1, arg2, arg3
end

return helper_7c5807e2
