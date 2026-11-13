--!strict
--- Impact flash of the lightning-quick strike attack.

local vm = require("@lib/vm")

local script = {}

--- Does nothing when the effect script is loaded.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing because this effect needs no initialisation.
function script.init() end

--- Plays the hit motion and creates a collision sphere at the hit point.
function script.on_start()
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local scale: f32 = 0
	local is_motion_finished: s32 = 0
	scale = 0.0
	effect.get_random_number(6.2831855)
	effect.play_battle_sound(55)
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		hit_x = out1 or hit_x
		hit_y = out2 or hit_y
		hit_z = out3 or hit_z
	end
	effect.get_script_value(0)
	scale = effect.get_script_value_float(1) or scale
	if scale == 0.0 then
		scale = 1.0
	end
	effect.create_collision_primitive("電光石花")
	effect.set_collision_primitive_shape(hit_x, hit_y, hit_z, 24.0)
	effect.set_effect_character_position(hit_x, hit_y, hit_z)
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
--- Does nothing when the effect ends.
function script.on_finish() end

return script
