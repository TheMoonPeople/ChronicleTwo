--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_b82885c0()
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local block: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		vm.wait(2)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		event.set_character_position(0, 0.0, -500.0, 0.0)
		block = event.load_event_image_4(5, "textures/event/e800/d07domari/d07domari02_1.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "d07domari02", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 312)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(6, 0)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.set_camera_sequence_position(71.12, 56.2, 96.2)
		event.set_camera_sequence_look_at(64.46, 54.73, 103.13)
		event.move_camera_sequence_eased(71.12, 56.2, 96.2, 73.0, 54.73, 105.94, 180, 2, 0.4)
		event.set_object_sequence_position(0, -36.58, 0.0, 153.99)
		event.set_object_sequence_rotation(0, 0.0, 2.92, 0.0)
		event.set_object_sequence_position(1, 30.72, 0.0, 154.46)
		event.set_object_sequence_rotation(1, 0.0, -2.88, 0.0)
		event.set_object_sequence_motion(0, "立ち", 0)
		event.set_object_sequence_motion(1, "立ち", 0)
		event.set_object_sequence_color(6, 128, 128, 128, 128, 60)
		wait_frames(150)
		event.fade_out_screen(30)
		wait_frames(30)
	end)
	vm.entry(5)
	event.cancel_drama_scene_skip()
	event.clear_camera_sequence()
	event.set_character_active(1, 0)
	event.set_character_position(0, var2, var3, var4)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
	event.reset_follow_camera(1, 0.0, 20.0)
	event.fade_in_screen(30)
	event.finish_event()
end

return helper_b82885c0
