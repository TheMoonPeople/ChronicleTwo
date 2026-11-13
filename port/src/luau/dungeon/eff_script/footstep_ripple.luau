--!strict
--- Spreads a ripple ring where a character steps in water.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Grows the ripple model at a random facing, fading it out near the end of 55 frames.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local scale_x: f32 = 0
	local scale_y: f32 = 0
	local scale_z: f32 = 0
	local scale_growth_x: f32 = 0
	local scale_growth_y: f32 = 0
	local scale_growth_z: f32 = 0
	local angle: f32 = 0
	local frame: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		scale_x = out1 or scale_x
		scale_y = out2 or scale_y
		scale_z = out3 or scale_z
	end
	effect.set_effect_character_position(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.set_effect_character_scale(scale_x, scale_y, scale_z)
	angle = effect.get_random_number(6.2831855) or angle
	angle = vm.f32(angle - vm.f32(3.1415927))
	angle = effect.wrap_angle(angle) or angle
	effect.rotate_effect_character_toward(0.0, angle, 0.0)
	do
		local out1, out2, out3 = effect.copy_vector(0.06, 0.06, 0.06)
		scale_growth_x = out1 or scale_growth_x
		scale_growth_y = out2 or scale_growth_y
		scale_growth_z = out3 or scale_growth_z
	end
	effect.set_effect_character_visible(1, 1, 0.04)
	frame = 0
	while frame < 55 do
		effect.set_effect_character_scale(scale_x, scale_y, scale_z)
		do
			local out1, out2, out3 = effect.add_vectors(scale_x, scale_y, scale_z, scale_growth_x, scale_growth_y, scale_growth_z)
			scale_x = out1 or scale_x
			scale_y = out2 or scale_y
			scale_z = out3 or scale_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(scale_growth_x, scale_growth_y, scale_growth_z, 0.96)
			scale_growth_x = out1 or scale_growth_x
			scale_growth_y = out2 or scale_growth_y
			scale_growth_z = out3 or scale_growth_z
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
--- Does nothing when the effect ends.
function script.on_finish() end

return script
