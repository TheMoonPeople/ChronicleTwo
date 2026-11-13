--!strict
--- Shows a blue glow that follows the owner and fades in or out on command.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Follows the owner's orb joint and fades the glow in or out according to the shared state value.
function script.on_start()
	local orb_x: f32 = 0
	local orb_y: f32 = 0
	local orb_z: f32 = 0
	local scale: f32 = 0
	local owner_id: s32 = 0
	local is_visible: s32 = 0
	local fade_command: s32 = 0
	local fade_frames: s32 = 0
	scale = 0.0
	effect.set_script_value_int(2, 0)
	effect.set_effect_character_motion("ループ")
	owner_id = effect.get_owner_character() or owner_id
	while true do
		if fade_frames > 15 then
			effect.set_script_value_int(2, 0)
		end
		is_visible = effect.get_script_value(0) or is_visible
		scale = effect.get_script_value_float(1) or scale
		fade_command = effect.get_script_value(2) or fade_command
		if is_visible ~= 0 then
			effect.set_effect_character_visible(1, 0)
		else
			effect.set_effect_character_visible(0, 0)
		end
		if fade_command == 0 then
			fade_frames = 0
		end
		if fade_command == 2 then
			effect.set_effect_character_visible(0, 1, 3.0)
			fade_frames = vm.i32(fade_frames + 1)
		end
		if fade_command == 1 then
			effect.set_effect_character_visible(0, 1, -3.0)
			fade_frames = vm.i32(fade_frames + 1)
		end
		do
			local out1, out2, out3 = effect.get_scene_character_frame_position(owner_id, "tama")
			orb_x = out1 or orb_x
			orb_y = out2 or orb_y
			orb_z = out3 or orb_z
		end
		effect.set_effect_character_position(orb_x, orb_y, orb_z)
		effect.set_effect_character_scale(scale, scale, scale)
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect has no finish handling.
function script.on_finish() end

return script
