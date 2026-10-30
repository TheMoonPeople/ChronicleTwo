--!strict
-- dungeon/eff_script/buggy_shell_case.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local user_id: s32 = 0
	local index: s32 = 0
	local var8: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var12: f32 = 0
	local yaw: f32 = 0
	local var14: f32 = 0
	user_id = effect.get_owner_character() or user_id
	effect.create_effect_character_copies(2)
	effect.set_effect_character_position(250, 80, -1000)
	index = 0
	var8 = 0
	while true do
		if vm.imod(var8, 15) == 0 then
			do
				local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "dcol00")
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			do
				local out1, out2, out3 = effect.get_scene_character_frame_rotation(user_id, "dcol00")
				var12 = out1 or var12
				yaw = out2 or yaw
				var14 = out3 or var14
			end
			print("POS = ", vm.float(pos_x), ",", vm.float(pos_y), ",", vm.float(pos_z), "\n")
			print("ROT = ", vm.float(var12), ",", vm.float(yaw), ",", vm.float(var14), "\n")
			effect.set_character_copy_position(index, pos_x, pos_y + 30.0, pos_z)
			index = index + 1
			if index >= 2 then
				index = 0
			end
		end
		var8 = vm.i32(var8 + 1)
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
