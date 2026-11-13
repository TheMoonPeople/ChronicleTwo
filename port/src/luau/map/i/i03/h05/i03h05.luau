--!strict
--- Fishing Town race course script that shows the race title and starts the Gyorace sub-game and handles its end.

local vm = require("@lib/vm")
local wait = require("@lib/event/wait")

--- Shows the stage title for the race and starts the Gyorace sub-game.
local function start_race_sub_game()
	local block: s32 = 0
	local extra_mode: s32 = 0
	local heat_stage: s32 = 0
	event.initialize_event()
	event.stop_music(0)
	event.load_music(165)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	extra_mode = event.is_extra_mode() or extra_mode
	if extra_mode ~= 0 then
		block = event.load_event_image_4(5, "textures/event/e00/e70/matchrace.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "matchrace", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 384, 128)
		event.set_event_sprite_size(0, 384, 128)
		event.set_event_sprite_position(0, 256, 192)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(2, 0)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
	else
		heat_stage = event.get_gyorace_value(3) or heat_stage
		if heat_stage == 0 then
			block = event.load_event_image_4(5, "textures/event/e00/e70/yosen.json", 0) or block
		end
		if heat_stage == 1 then
			block = event.load_event_image_4(5, "textures/event/e00/e70/honsen.json", 0) or block
		end
		if heat_stage == 2 then
			block = event.load_event_image_4(5, "textures/event/e00/e70/kesshou.json", 0) or block
		end
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		if heat_stage == 0 then
			event.set_event_sprite_texture(0, "yosen", block)
		end
		if heat_stage == 1 then
			event.set_event_sprite_texture(0, "honsen", block)
		end
		if heat_stage == 2 then
			event.set_event_sprite_texture(0, "kesshou", block)
		end
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 256, 128)
		event.set_event_sprite_size(0, 256, 128)
		event.set_event_sprite_position(0, 256, 192)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(2, 0)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
	end
	event.play_music(0)
	event.set_camera_position(426.45, 204.62, 518.58)
	event.set_camera_look_at(-91.31, -38.79, 540.16)
	event.move_camera_sequence(426.45, 204.62, 518.58, 204.29, -38.79, 47.09, 160)
	event.fade_in_screen(30)
	wait.for_frame_count(30)
	event.set_event_sprite_draw_pass(0, 1)
	event.set_object_sequence_color(2, 128, 128, 128, 128, 30)
	wait.for_frame_count(100)
	event.fade_out_screen(30)
	wait.for_frame_count(30)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
	vm.wait(4)
	event.start_sub_game(2)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script loads and needs no setup.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the map's default entry behavior is suppressed.
function script.default_event() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = start_race_sub_game

--- Fades out the music and returns to the racing hall after the Gyorace ends.
function script.gyorace_end()
	event.initialize_event()
	vm.wait(1)
	vm.wait(2)
	event.fade_out_music(30)
	wait.for_frame_count(30)
	event.stop_music(0)
	event.skip_next_music_load()
	vm.wait(4)
	event.jump_to_map_3(-1, "i03h04", 502)
	vm.wait(5)
end

--- Fades out the music and returns to the racing hall after the extra mode Gyorace ends.
function script.gyorace_omake_end()
	event.initialize_event()
	vm.wait(1)
	vm.wait(2)
	event.fade_out_music(30)
	wait.for_frame_count(30)
	event.stop_music(0)
	event.skip_next_music_load()
	vm.wait(4)
	event.jump_to_map_3(-1, "i03h04", 503)
	vm.wait(5)
end

script.start_race_sub_game = start_race_sub_game
script[500] = script.start_race_sub_game

--- Event 1000, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine runs this instead of its default.
function script.on_talk() end
script[1000] = script.on_talk

return script
