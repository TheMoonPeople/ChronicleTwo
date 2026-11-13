--!strict
--- Event script for the Starlight Temple kitchen interior, with the Rao Chao cooking scene that turns a White Windflower into a dish.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local message = require("@lib/event/message")
local starlight_temple_interior_i08 = require("@lib/event/starlight_temple_interior_i08")
local starlight_temple_villagers = require("@lib/event/italian/starlight_temple_villagers")
local wait = require("@lib/event/wait")

--- Asks whether to hand over the White Windflower for cooking and returns 1 when the player agrees.
local function ask_give_windflower()
	local answer: s32 = 0
	local step: number = 0
	return vm.guard(function()
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(
			0,
			"Diamogli un Fiore Biancovento\ne preparer[UNI00e0] un piatto miracoloso!\n(Premi (#) per accedere al Menu)"
		)
		step = 1
		answer = message.ask_confirmation(0, -1, 5, 256, 208, answer)
		if answer == 1 then
			return 1
		else
			return 0
		end
	end, function(received: { any })
		if step <= 1 then
			if step == 1 then
				answer = received[2] :: number
			end
			return 1
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script[99] = cutscene.noop

--- Plays the Rao Chao meeting scene or enables the cooking point depending on story flags, then resets the camera.
function script.default_event()
	local meeting_flag: s32 = 0
	local cooking_flag: s32 = 0
	local story_flag_364: s32 = 0
	local windflower_count: s32 = 0
	cutscene.noop()
	meeting_flag = event.get_save_flag(320) or meeting_flag
	cooking_flag = event.get_save_flag(324) or cooking_flag
	story_flag_364 = event.get_save_flag(364) or story_flag_364
	starlight_temple_interior_i08.set_character_200_active(0)
	if story_flag_364 == 1 then
		if meeting_flag == 0 then
			starlight_temple_interior_i08.play_raochao_meeting_scene()
		else
			windflower_count = event.get_owned_item_count(363) or windflower_count
			if cooking_flag == 0 and windflower_count >= 1 then
				event.set_function_point_enabled("", "syumai", 1)
			end
		end
	end
	starlight_temple_interior_i08.set_character_200_active(1)
	event.reset_follow_camera(1, 0.0)
end

--- Plays the cooking scene when the square button is pressed.
function script.key_open()
	starlight_temple_interior_i08.set_character_200_active(0)
	starlight_temple_interior_i08.play_raochao_cooking_scene()
	starlight_temple_interior_i08.set_character_200_active(1)
end

--- Offers Rao Chao the White Windflower and, when it is used, plays the cooking scene and grants the dish.
function script.talk_to_raochao()
	local interaction_state: s32 = 0
	local used_item: s32 = 0
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		step = 1
		vm.wait(1)
		event.set_character_motion(0, "立ち")
		interaction_state = event.get_triggered_event_data_2(6) or interaction_state
		if interaction_state == 1 then
			step = 2
			if ask_give_windflower() ~= 0 then
				interaction_state = 2
			end
		end
		if interaction_state == 2 then
			event.open_use_item_menu(363)
			step = 3
			vm.wait(3)
			used_item = vmhost.used_item() or used_item
			if used_item == 363 then
				event.add_inventory_item(364)
				event.set_function_point_enabled("", "syumai", 0)
				event.fade_out_music(30)
				event.fade_out_screen(30)
				step = 4
				wait.frames(30)
				starlight_temple_interior_i08.set_character_200_active(0)
				step = 5
				starlight_temple_interior_i08.play_raochao_cooking_scene()
				starlight_temple_interior_i08.set_character_200_active(1)
			elseif used_item > 0 then
				step = 6
				character.shake_head_at_camera()
			end
		end
		return
	end, function(received: { any })
		if step <= 6 then
			if step == 2 then
				local _ = received[1] :: number
			end
			if step <= 1 then
				local _ = starlight_temple_interior_i08.run_with_fixed_arguments()
			end
			if step <= 2 then
				local _ = interaction_state == 1
				interaction_state = 2
			end
			if step <= 3 then
				wait.frames_skipping(30)
			end
			if step <= 4 then
				cutscene.skip_command(0)
				step = 5
				starlight_temple_interior_i08.play_raochao_cooking_scene()
				return vm.continue_with(function()
					starlight_temple_interior_i08.set_character_200_active(1)
					return
				end)
			end
			if step <= 5 then
				cutscene.skip_command(1)
				cutscene.do_nothing()
			end
			return 0
		end
		return nil
	end)
end
script[500] = script.talk_to_raochao

--- Event 1000, which map data, a script or the engine runs by number.
script[1000] = starlight_temple_villagers.talk_to_villager

--- Replays the meeting scene with Rao Chao.
function script.replay_raochao_meeting_scene()
	starlight_temple_interior_i08.set_character_200_active(0)
	starlight_temple_interior_i08.play_raochao_meeting_scene()
	starlight_temple_interior_i08.set_character_200_active(1)
end
script[13200] = script.replay_raochao_meeting_scene

--- Replays the cooking scene with Rao Chao.
function script.replay_raochao_cooking_scene()
	starlight_temple_interior_i08.set_character_200_active(0)
	starlight_temple_interior_i08.play_raochao_cooking_scene()
	starlight_temple_interior_i08.set_character_200_active(1)
end
script[13240] = script.replay_raochao_cooking_scene

return script
