--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_fc1eb830(arg0: s32)
	local block: s32 = 0
	event.set_character_motion(0, "立ち")
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	if arg0 == 0 then
		event.start_background_file_loads_1("textures/event/etc/heki401.json")
	end
	if arg0 == 1 then
		event.start_background_file_loads_1("textures/event/etc/heki402.json")
	end
	if arg0 == 2 then
		event.start_background_file_loads_1("textures/event/etc/heki403.json")
	end
	if arg0 == 3 then
		event.start_background_file_loads_1("textures/event/etc/heki404.json")
	end
	if arg0 == 4 then
		event.start_background_file_loads_1("textures/event/etc/heki405.json")
	end
	if arg0 == 5 then
		event.start_background_file_loads_1("textures/event/etc/heki406.json")
	end
	if arg0 == 6 then
		event.start_background_file_loads_1("textures/event/etc/heki407.json")
	end
	if arg0 == 7 then
		event.start_background_file_loads_1("textures/event/etc/heki408.json")
	end
	helper_479dc9e9()
	if arg0 == 0 then
		block = event.load_event_image_4(5, "textures/event/etc/heki401.json", 0) or block
		event.set_event_sprite_texture(0, "heki401", block)
	end
	if arg0 == 1 then
		block = event.load_event_image_4(5, "textures/event/etc/heki402.json", 0) or block
		event.set_event_sprite_texture(0, "heki402", block)
	end
	if arg0 == 2 then
		block = event.load_event_image_4(5, "textures/event/etc/heki403.json", 0) or block
		event.set_event_sprite_texture(0, "heki403", block)
	end
	if arg0 == 3 then
		block = event.load_event_image_4(5, "textures/event/etc/heki404.json", 0) or block
		event.set_event_sprite_texture(0, "heki404", block)
	end
	if arg0 == 4 then
		block = event.load_event_image_4(5, "textures/event/etc/heki405.json", 0) or block
		event.set_event_sprite_texture(0, "heki405", block)
	end
	if arg0 == 5 then
		block = event.load_event_image_4(5, "textures/event/etc/heki406.json", 0) or block
		event.set_event_sprite_texture(0, "heki406", block)
	end
	if arg0 == 6 then
		block = event.load_event_image_4(5, "textures/event/etc/heki407.json", 0) or block
		event.set_event_sprite_texture(0, "heki407", block)
	end
	if arg0 == 7 then
		block = event.load_event_image_4(5, "textures/event/etc/heki408.json", 0) or block
		event.set_event_sprite_texture(0, "heki408", block)
	end
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 416)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_event_sprite_draw_pass(0, 1)
	event.set_object_sequence_color(0, 128.0, 128.0, 128.0, 128.0, 4)
	wait_frames(4)
	helper_c956b4a2(64)
	event.set_object_sequence_color(0, 128.0, 128.0, 128.0, 0.0, 4)
	wait_frames(4)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
end

return helper_fc1eb830
