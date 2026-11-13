--!strict
--- Shows the hit burst of the lightning flint item and damages targets inside its collision area.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no initialisation.
function script.init() end

--- Plays the burst at the impact point, with a collision area around it, until its motion finishes.
function script.on_start()
	local impact_x: f32 = 0
	local impact_y: f32 = 0
	local impact_z: f32 = 0
	local scale: f32 = 0
	local is_motion_finished: s32 = 0
	scale = 0.0
	effect.get_random_number(6.2831855)
	effect.play_battle_sound(55)
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		impact_x = out1 or impact_x
		impact_y = out2 or impact_y
		impact_z = out3 or impact_z
	end
	effect.get_script_value(0)
	scale = effect.get_script_value_float(1) or scale
	if scale == 0.0 then
		scale = 1.0
	end
	effect.create_collision_primitive("電光石花")
	effect.set_collision_primitive_shape(impact_x, impact_y, impact_z, 24.0)
	effect.set_effect_character_position(impact_x, impact_y, impact_z)
	effect.set_effect_character_motion("ヒット", -1, 6)
	effect.set_effect_character_scale(scale, scale, scale)
	effect.set_effect_character_visible(1, 1, 0.1)
	is_motion_finished = 0
	while is_motion_finished == 0 do
		vm.wait()
		is_motion_finished = effect.is_effect_character_motion_finished() or is_motion_finished
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no finish handling.
function script.on_finish() end

return script
