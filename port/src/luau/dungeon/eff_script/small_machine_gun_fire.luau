--!strict
--- Rapid-fire muzzle effect of the small machine gun that follows its shooter.

local vm = require("@lib/vm")

local script = {}

--- Does nothing when the effect script is loaded.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing because this effect needs no initialisation.
function script.init() end

--- Keeps the firing model on the shooter until the stop signal arrives.
function script.on_start()
	local shooter_x: f32 = 0
	local shooter_y: f32 = 0
	local shooter_z: f32 = 0
	local shooter_rotation_x: f32 = 0
	local shooter_rotation_y: f32 = 0
	local shooter_rotation_z: f32 = 0
	local stop_signal: s32 = 0
	local shooter_id: s32 = 0
	local frame: s32 = 0
	stop_signal = 0
	shooter_id = effect.get_script_value(1) or shooter_id
	effect.set_effect_character_motion("連射", -1, 4)
	frame = 0
	while frame < 300 do
		stop_signal = effect.get_script_value(0) or stop_signal
		if stop_signal ~= 0 then
			break
		else
			do
				local out1, out2, out3 = effect.get_scene_character_position(shooter_id)
				shooter_x = out1 or shooter_x
				shooter_y = out2 or shooter_y
				shooter_z = out3 or shooter_z
			end
			do
				local out1, out2, out3 = effect.get_scene_character_rotation_4(shooter_id)
				shooter_rotation_x = out1 or shooter_rotation_x
				shooter_rotation_y = out2 or shooter_rotation_y
				shooter_rotation_z = out3 or shooter_rotation_z
			end
			effect.set_effect_character_position(shooter_x, shooter_y, shooter_z)
			effect.rotate_effect_character_toward(shooter_rotation_x, shooter_rotation_y, shooter_rotation_z)
			vm.wait()
			frame = frame + 1
		end
	end
end

--- Stops the gun sound owned by the shooter.
function script.on_finish()
	effect.stop_owner_sound(4)
end

return script
