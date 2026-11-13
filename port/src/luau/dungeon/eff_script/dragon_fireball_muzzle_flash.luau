--!strict
--- Muzzle flash of the dragon's fireball.

local vm = require("@lib/vm")

local script = {}

--- Does nothing when the effect script is loaded.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing because this effect needs no initialisation.
function script.init() end

--- Plays the launch motion at the muzzle and fades out when it finishes.
function script.on_start()
	local muzzle_x: f32 = 0
	local muzzle_y: f32 = 0
	local muzzle_z: f32 = 0
	local muzzle_rotation_x: f32 = 0
	local muzzle_rotation_y: f32 = 0
	local muzzle_rotation_z: f32 = 0
	local is_motion_finished: s32 = 0
	effect.get_owner_character()
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		muzzle_x = out1 or muzzle_x
		muzzle_y = out2 or muzzle_y
		muzzle_z = out3 or muzzle_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		muzzle_rotation_x = out1 or muzzle_rotation_x
		muzzle_rotation_y = out2 or muzzle_rotation_y
		muzzle_rotation_z = out3 or muzzle_rotation_z
	end
	effect.set_effect_character_position(muzzle_x, muzzle_y, muzzle_z)
	effect.rotate_effect_character_toward(muzzle_rotation_x, muzzle_rotation_y, muzzle_rotation_z)
	effect.set_effect_character_motion("発射")
	effect.set_effect_character_visible(1, 1, 0.1)
	is_motion_finished = 0
	while is_motion_finished == 0 do
		vm.wait()
		is_motion_finished = effect.is_effect_character_motion_finished() or is_motion_finished
	end
	effect.set_effect_character_visible(0, 0)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
