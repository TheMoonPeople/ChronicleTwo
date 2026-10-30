--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2c717f26 = require("@lib/event/helper_2c717f26")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_e509fa5e(arg0: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: any = 0
	event.initialize_event()
	do
		local out1, out2, out3 = event.get_character_position(0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	do
		local out1, out2, out3 = event.get_character_position(arg0)
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	do
		local out1, out2, out3 = event.subtract_vectors(var4, var5, var6, var1, var2, var3)
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	var7 = event.get_arc_tangent(var4, var6) or var7
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
	print("angle=", vm.float(var7), "----------\n")
	var8 = vm.ftoi(vm.f32(var7 / vm.f32(0.19634955)))
	var8 = helper_2c717f26(var8)
	print("frame=", var8, "-------------\n")
	event.rotate_object_sequence(0, 0.0, var7, 0.0, var8)
	wait_frames(var8)
	event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
end

return helper_e509fa5e
