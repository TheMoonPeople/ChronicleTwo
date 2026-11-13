--!strict
--- Shows an electric shock that follows a character.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script loads; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Plays the shock animation on the owner character for a fixed time, then fades it out.
function script.on_start()
	local attach_x: f32 = 0
	local attach_y: f32 = 0
	local attach_z: f32 = 0
	local frame: s32 = 0
	local owner_id: s32 = 0
	owner_id = effect.get_owner_character() or owner_id
	effect.set_effect_character_motion("ループ", -1, 6)
	effect.set_effect_character_visible(1, 1)
	effect.set_effect_character_scale(2.0, 2.0, 2.0)
	frame = 0
	while frame < 30 do
		do
			local out1, out2, out3 = effect.get_scene_character_frame_position(owner_id, "marioa_null")
			attach_x = out1 or attach_x
			attach_y = out2 or attach_y
			attach_z = out3 or attach_z
		end
		effect.set_effect_character_position(attach_x, attach_y - 15.0, attach_z)
		vm.wait()
		frame = frame + 1
	end
	effect.set_effect_character_visible(0, 1, -0.2)
	while frame < 30 do
		do
			local out1, out2, out3 = effect.get_scene_character_frame_position(owner_id, "marioa_null")
			attach_x = out1 or attach_x
			attach_y = out2 or attach_y
			attach_z = out3 or attach_z
		end
		effect.set_effect_character_position(attach_x, attach_y - 15.0, attach_z)
		vm.wait()
		frame = vm.i32(frame + 1)
	end
	effect.set_effect_character_visible(0, 0)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Empty finish handler; the effect needs no cleanup.
function script.on_finish() end

return script
