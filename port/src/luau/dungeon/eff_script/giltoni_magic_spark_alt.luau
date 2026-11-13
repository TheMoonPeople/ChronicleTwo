--!strict
--- Shows the alternate small spinning spark model that grows then shrinks away.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Spins the spark model at the given position, growing it for three frames and shrinking it until it vanishes.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local scale: f32 = 0
	local spin_angle: f32 = 0
	local shrink_speed: f32 = 0
	local shrink_acceleration: f32 = 0
	local frame: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	scale = vm.f32(0.4)
	spin_angle = effect.get_random_number(6.2831855) or spin_angle
	spin_angle = vm.f32(spin_angle - vm.f32(3.1415927))
	effect.set_effect_character_visible(1, 1, 0.1)
	effect.set_effect_character_position(work_vect1_x, work_vect1_y, work_vect1_z)
	shrink_speed = vm.f32(0.3)
	shrink_acceleration = vm.f32(0.025)
	frame = 0
	while frame < 35 do
		spin_angle = effect.wrap_angle(spin_angle) or spin_angle
		effect.rotate_effect_character_toward(0.0, spin_angle, 0.0)
		spin_angle = vm.f32(spin_angle + vm.f32(0.06))
		if frame == 9 then
			effect.set_effect_character_visible(0, 1, 0.06)
		end
		effect.set_effect_character_scale(scale, scale, scale)
		if frame < 3 then
			scale = vm.f32(scale + vm.f32(0.6))
		else
			shrink_speed = vm.f32(shrink_speed - shrink_acceleration)
			scale = vm.f32(scale - shrink_speed)
			if scale < 0.0 then
				scale = 0.0
			end
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
