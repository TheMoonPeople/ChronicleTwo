--!strict
--- Shows a ripple spreading out from a footstep in shallow water.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no initialisation.
function script.init() end

--- Places the ripple model at the footstep with a random yaw, then grows it with decaying speed and fades it out.
function script.on_start()
	local footstep_x: f32 = 0
	local footstep_y: f32 = 0
	local footstep_z: f32 = 0
	local scale_x: f32 = 0
	local scale_y: f32 = 0
	local scale_z: f32 = 0
	local growth_x: f32 = 0
	local growth_y: f32 = 0
	local growth_z: f32 = 0
	local random_yaw: f32 = 0
	local frame: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		footstep_x = out1 or footstep_x
		footstep_y = out2 or footstep_y
		footstep_z = out3 or footstep_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		scale_x = out1 or scale_x
		scale_y = out2 or scale_y
		scale_z = out3 or scale_z
	end
	effect.set_effect_character_position(footstep_x, footstep_y, footstep_z)
	effect.set_effect_character_scale(scale_x, scale_y, scale_z)
	random_yaw = effect.get_random_number(6.2831855) or random_yaw
	random_yaw = vm.f32(random_yaw - vm.f32(3.1415927))
	random_yaw = effect.wrap_angle(random_yaw) or random_yaw
	effect.rotate_effect_character_toward(0.0, random_yaw, 0.0)
	do
		local out1, out2, out3 = effect.copy_vector(0.06, 0.06, 0.06)
		growth_x = out1 or growth_x
		growth_y = out2 or growth_y
		growth_z = out3 or growth_z
	end
	effect.set_effect_character_visible(1, 1, 0.04)
	frame = 0
	while frame < 55 do
		effect.set_effect_character_scale(scale_x, scale_y, scale_z)
		do
			local out1, out2, out3 = effect.add_vectors(scale_x, scale_y, scale_z, growth_x, growth_y, growth_z)
			scale_x = out1 or scale_x
			scale_y = out2 or scale_y
			scale_z = out3 or scale_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(growth_x, growth_y, growth_z, 0.96)
			growth_x = out1 or growth_x
			growth_y = out2 or growth_y
			growth_z = out3 or growth_z
		end
		if frame == 30 then
			effect.set_effect_character_visible(0, 1, 0.04)
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
