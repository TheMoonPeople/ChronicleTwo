--!strict
--- Holds the beam body in place, damaging characters it touches until told to stop.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Plays the beam loop motion with a damage sphere at the beam position until released, then plays the return motion.
function script.on_start()
	local beam_x: f32 = 0
	local beam_y: f32 = 0
	local beam_z: f32 = 0
	local scale: f32 = 0
	local is_stopped: s32 = 0
	local damage: s32 = 0
	local is_motion_finished: s32 = 0
	damage = 0
	is_stopped = 0
	scale = 0.0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		beam_x = out1 or beam_x
		beam_y = out2 or beam_y
		beam_z = out3 or beam_z
	end
	damage = effect.get_script_value(0) or damage
	scale = effect.get_script_value_float(1) or scale
	is_stopped = effect.get_script_value(2) or is_stopped
	effect.set_effect_character_scale(scale, scale, scale)
	effect.set_effect_character_motion("攻撃２ループ", 0)
	effect.create_collision_primitive("吹っ飛び強")
	effect.set_collision_primitive_damage(damage)
	while true do
		scale = effect.get_script_value_float(1) or scale
		effect.set_effect_character_scale(scale, scale, scale)
		do
			local out1, out2, out3 = effect.get_first_work_vector()
			beam_x = out1 or beam_x
			beam_y = out2 or beam_y
			beam_z = out3 or beam_z
		end
		effect.set_effect_character_position(beam_x, beam_y, beam_z)
		effect.set_collision_primitive_shape(beam_x, beam_y, beam_z, 45.0)
		is_stopped = effect.get_script_value(2) or is_stopped
		if is_stopped ~= 0 then
			break
		else
			vm.wait()
		end
	end
	effect.delete_collision_primitive(-1)
	effect.set_effect_character_motion("攻撃２戻り", 6)
	while true do
		vm.wait()
		do
			local out1, out2, out3 = effect.get_first_work_vector()
			beam_x = out1 or beam_x
			beam_y = out2 or beam_y
			beam_z = out3 or beam_z
		end
		effect.set_effect_character_position(beam_x, beam_y, beam_z)
		is_motion_finished = effect.is_effect_character_motion_finished() or is_motion_finished
		if is_motion_finished ~= 0 then
			break
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect has no finish handling.
function script.on_finish() end

return script
