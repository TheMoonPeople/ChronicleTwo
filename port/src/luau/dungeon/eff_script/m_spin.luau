--!strict
-- dungeon/eff_script/m_spin.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local value: f32 = 0
	local var7: s32 = 0
	local value_2: s32 = 0
	local user_id: s32 = 0
	value = 0.0
	value_2 = 0
	user_id = effect.get_owner_character() or user_id
	effect.get_script_value(0)
	value_2 = effect.get_script_value(1) or value_2
	value = effect.get_script_value_float(2) or value
	effect.set_effect_character_position(pos_x, pos_y, pos_z)
	effect.set_effect_character_scale(value, value, value)
	effect.set_effect_character_motion("攻撃2loop")
	effect.set_effect_character_visible(1, 1, 0.1)
	var7 = 0
	while var7 < value_2 do
		do
			local out1, out2, out3 = effect.get_scene_character_position(user_id)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		effect.set_effect_character_position(pos_x, pos_y, pos_z)
		vm.wait()
		var7 = var7 + 1
	end
	effect.set_effect_character_visible(0, 1, -0.1)
	var7 = 0
	while var7 < 15 do
		vm.wait()
		var7 = var7 + 1
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
