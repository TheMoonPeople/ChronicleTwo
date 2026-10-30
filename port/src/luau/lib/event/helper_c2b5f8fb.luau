--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_05ce8bed = require("@lib/event/helper_05ce8bed")
local interpolate = require("@lib/event/interpolate")

--- Helper function.
local function helper_c2b5f8fb(arg0: s32, arg1: f32)
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local rot_y: f32 = 0
	do
		local _, out2, _ = event.get_character_rotation(arg0)
		var5 = out2 or var5
	end
	var6 = vm.f32(arg1 - var5)
	if var6 < vm.f32(-3.1415927) then
		var6 = vm.f32(var6 + vm.f32(6.2831855))
	end
	if vm.f32(3.1415927) < var6 then
		var6 = vm.f32(var6 - vm.f32(6.2831855))
	end
	if -0.5 < var6 and var6 < 0.5 then
	else
		event.set_character_motion(arg0, "歩き")
	end
	var7 = 0.0
	var8 = vm.f32(helper_05ce8bed(var6) * 8.0)
	while var7 < var8 do
		rot_y = interpolate(0.0, var6, var7, var8)
		rot_y = vm.f32(rot_y + var5)
		event.set_character_rotation(arg0, 0.0, rot_y, 0.0)
		var7 = vm.f32(var7 + 1.0)
		vm.wait(1)
	end
	event.get_character_rotation(arg0, 0.0, arg1, 0.0)
	event.set_character_motion(arg0, "立ち")
end

return helper_c2b5f8fb
