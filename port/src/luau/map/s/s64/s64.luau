--!strict
--- Event script for a short map that plays Andrea's conversation with the sun and then loads the dungeon floor.

local vm = require("@lib/vm")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

--- Does nothing; the map needs no setup before it is entered.
local function initialize_map() end

--- Plays the e720 flashback in which Sun runs up to Andrea, who looks down, and the two talk.
local function play_andrea_and_sun_conversation()
	vm.section(function()
		event.initialize_event()
		event.set_save_flag(720, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.get_playable_character()
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(113)
		event.play_music(0)
		event.load_map_sounds(7826)
		event.load_sound_effect_file_2(7826)
		event.set_character_active(0, 0)
		event.change_directory("event/e700/e720/")
		event.load_message_file(0, 5, "e720.txt")
		event.load_character(5, "e720_andrea.gltf", "info", 8)
		event.set_character_active(8)
		event.attach_object_handle_to_character(0, 8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "e720_sun.gltf", "info", 9)
		event.set_character_active(0, 9)
		event.attach_object_handle_to_character(1, 9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.change_directory("")
		event.load_character(5, "event/e700/e704/kaisou_waku.gltf", "info", 10)
		event.set_character_active(1, 10)
		event.set_object_handle_position(0, -376.0, 1200.0, -5629.0)
		event.set_object_handle_rotation(0, 0.0, -0.7, 0.0)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "しんけん顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -289.13, 1200.0, -5873.42)
		event.set_object_handle_rotation(1, 0.0, -0.34, 0.0)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(111.08, 1313.31, -6132.84)
		event.set_camera_sequence_look_at(-92.67, 1295.5, -5923.09)
		event.keep_character_in_front_of_camera_sequence(10, 610.7, -1)
		event.fade_in_screen(30)
		wait.for_frame_count(60)
		event.set_camera_sequence_position(-372.38, 1220.59, -5584.9)
		event.set_camera_sequence_look_at(-366.29, 1224.63, -5643.89)
		event.set_character_active(1, 9)
		event.move_object_sequence(1, -353.29, 1200.0, -5656.51, 60)
		event.set_object_sequence_motion(1, "走り", 4)
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "立ち")
		event.delay_object_sequence_rotation_track(1, 50)
		event.rotate_object_sequence(1, 0.0, -0.94, 0.0, 10)
		object.wait_until_done(1)
		wait.for_frame_count(4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "あわて目パチ")
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "口だけ会話", 6, 0.6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		message.show_voiced(7200010)
		object.wait_until_done(1)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "しんけん顔")
		event.set_object_handle_texture_animation(0, 1, "目あき～目とじ")
		event.set_object_sequence_motion(0, "うつむく", 2)
		event.queue_object_sequence_next_motion(0, "うつむくＬ", 4)
		event.set_mouth_texture_animations(0, "しんけん口パク")
		message.show_voiced(7200020)
		object.wait_until_done(0)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "あわて目～こまり目")
		event.delay_object_sequence_texture_animation_track(1, 30)
		event.set_object_sequence_texture_animation(1, 1) -- retail: argument 2 is "こまり目パチ", whose address the handler only tests for zero
		event.set_mouth_motions(1, "口だけ会話", 0, "立ち", 0)
		message.show_voiced(7200030)
		object.wait_until_done(1)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "しんけん顔")
		event.set_object_handle_texture_animation(0, 1, "目とじ～おこり目あき")
		event.set_object_sequence_motion(0, "うつむく戻り", 2)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.delay_object_sequence_texture_animation_track(0, 30)
		event.set_object_sequence_texture_animation(0, 1) -- retail: argument 2 is "おこり目パチ", whose address the handler only tests for zero
		event.set_mouth_texture_animations(0, "しんけん口パク")
		message.show_voiced(7200040)
		object.wait_until_done(0)
		event.set_mouth_texture_animations(0, "しんけん口パク")
		message.show_voiced(7200050)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "しんけん顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目あき～おこり目とじ")
		event.set_mouth_texture_animations(0, "しんけん口パク")
		message.show_voiced(7200055)
		event.set_mouth_texture_animations(0, "しんけん口パク")
		message.show_voiced(7200060)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "目あき～目とじ")
		event.set_object_sequence_motion(1, "じたんだ", 0)
		message.show_voiced(7200070)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.set_character_active(1, 0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.load_message_file(0, -1)
	event.finish_event()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

script.initialize_map = initialize_map
script[99] = script.initialize_map

--- Resets the follow camera and fades the screen in on entering the map.
function script.default_event()
	initialize_map()
	event.reset_follow_camera(1)
	event.fade_in_screen(30)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the engine runs this instead of its default.
function script.key_open() end

--- Plays the conversation between Andrea and the sun and then loads the dungeon map and its event script.
function script.cutscene_andrea_and_sun_conversation()
	play_andrea_and_sun_conversation()
	event.skip_next_music_load()
	event.load_dungeon_map("d06b01")
	event.load_event_script("d06b01/d06b01.stb", 510)
end
script[500] = script.cutscene_andrea_and_sun_conversation

return script
