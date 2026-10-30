--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7595bb3d = require("@lib/event/helper_7595bb3d")

--- Helper function.
local function helper_a3a848ae()
	vm.section(function()
		event.initialize_event()
		event.enable_drama_skip()
		event.set_message_window_mode(0, 7)
		event.clear_camera_sequence()
		vm.wait(1)
		event.set_camera_position(0.0, 0.0, 0.0)
		event.set_camera_look_at(1.0, 0.0, 0.0)
		event.set_character_active(0, 0)
		helper_7595bb3d()
	end)
	event.cancel_drama_scene_skip()
	event.set_character_active(1, 0)
	event.set_save_flag(56, 0)
end

return helper_a3a848ae
