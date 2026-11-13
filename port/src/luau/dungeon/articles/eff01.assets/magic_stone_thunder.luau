--!strict
--- Shows the burst of a thunder magic stone and damages targets near the point where it is used.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no initialisation.
function script.init() end

--- Plays the thunder burst at the work position with a collision area, until a target is hit or thirty frames pass.
function script.on_start()
	local burst_x: f32 = 0
	local burst_y: f32 = 0
	local burst_z: f32 = 0
	local frame: s32 = 0
	local hit_count: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		burst_x = out1 or burst_x
		burst_y = out2 or burst_y
		burst_z = out3 or burst_z
	end
	effect.get_script_value(0)
	effect.set_effect_character_position(burst_x, burst_y, burst_z)
	effect.set_effect_character_motion("雷", -1, 6)
	effect.play_battle_sound(11, burst_x, burst_y, burst_z)
	hit_count = 0
	frame = 0
	effect.create_collision_primitive("魔石雷")
	effect.set_collision_primitive_shape(burst_x, burst_y, burst_z, 15.0)
	while frame < 114 do
		if hit_count <= 0 then
			hit_count = effect.get_collision_primitive_hit_count() or hit_count
			if hit_count > 0 or frame == 30 then
				hit_count = 1
				effect.delete_collision_primitive(-1)
			end
		end
		frame = frame + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no finish handling.
function script.on_finish() end

return script
