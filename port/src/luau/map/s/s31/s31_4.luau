--!strict
--- Moon Flower Palace train stop with arrival, departure and boarding handling.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local menu = require("@lib/event/menu")
local moon_flower_palace_stop_s31 = require("@lib/event/moon_flower_palace_stop_s31")
local object = require("@lib/event/object")
local town_prompt = require("@lib/event/italian/town_prompt")
local train = require("@lib/event/train")
local wait = require("@lib/event/wait")

--- Resets the train car parts when the map starts.
local function reset_map()
	print("map_init-------------------------\n")
	object.reset_train_car_parts()
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

script.reset_map = reset_map
script[99] = script.reset_map

--- Places the player by how the map was entered.
function script.default_event()
	local memory_card_load_state: s32 = 0
	local previous_map_number: s32 = 0
	local previous_map_type: s32 = 0
	local boarding_stop: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		reset_map()
		print("start_event--------------------------------------------\n")
		memory_card_load_state = event.take_memory_card_load_state() or memory_card_load_state
		if memory_card_load_state == 1 then
			moon_flower_palace_stop_s31.load_stage_character()
			character.place_standing_and_reset_cloth(vm.f32(94.2), vm.f32(34.8), vm.f32(2842.4), 0.0)
			event.reset_follow_camera(1, 0.0, 20.0)
			event.fade_in_screen(30)
		else
			previous_map_number = event.get_previous_map() or previous_map_number
			previous_map_type = event.get_map_type(previous_map_number) or previous_map_type
			if previous_map_type ~= -1 then
				if previous_map_number == 77 then
					moon_flower_palace_stop_s31.load_stage_character()
					character.place_standing_and_reset_cloth(0.0, 80.0, 2560.0, 0.0)
					event.reset_follow_camera(1, 0.0, 20.0)
					event.fade_in_screen(30)
				else
					boarding_stop = event.get_save_counter(1) or boarding_stop
					if
						(previous_map_number == 18 or previous_map_number == 23 or previous_map_number == 120 or previous_map_number == 108)
						and boarding_stop == 8
					then
						moon_flower_palace_stop_s31.load_stage_character()
						resume_step = 1
						moon_flower_palace_stop_s31.exit_train()
						train.place_player_at_saved_platform()
						event.fade_in_screen(15)
						event.reset_follow_camera(1, 0.0)
					else
						resume_step = 2
						moon_flower_palace_stop_s31.arrive_by_train()
						moon_flower_palace_stop_s31.load_stage_character()
					end
				end
			end
			event.set_character_motion(0, "立ち")
		end
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				train.skip_place_player_at_saved_platform()
				wait.skip_long_pause()
			end
			cutscene.noop()
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = moon_flower_palace_stop_s31.play_sun_despair_scene

--- Asks to depart and jumps to s33.
function script.leave_for_s33()
	if moon_flower_palace_stop_s31.ask_to_depart() ~= 0 then
		event.jump_to_map_2(-1, "s33")
		vm.wait(2)
	end
end
script[200] = script.leave_for_s33

--- Asks whether to board and enters the train.
function script.board_train()
	local choice: s32 = 0
	local route_index: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		resume_step = 1
		choice = town_prompt.ask_enter_or_leave()
		if choice ~= 1 then
			return
		end
		event.set_save_counter(1, 8)
		route_index = event.get_triggered_event_data_2(3) or route_index
		if route_index <= 1 then
			resume_step = 2
			train.board_short_train()
			event.stop_music(0)
			resume_step = 3
			vm.wait(3)
			event.jump_to_map_2(-1, "s37")
			resume_step = 4
			vm.wait(4)
		else
			resume_step = 5
			train.board_train_via_gangway()
			event.stop_music(0)
			event.jump_to_map_2(100, "s38")
		end
		return
	end, function(received: { any })
		if resume_step <= 1 then
			if resume_step == 1 then
				choice = received[1] :: number
			end
			return 0
		end
		if resume_step <= 5 then
			if resume_step <= 4 then
				train.board_train_via_gangway_skipping()
			end
			return 0
		end
		return nil
	end)
end
script[250] = script.board_train

--- Event 400, which map data, a script or the engine runs by number.
script[400] = menu.open_with_fade

--- Event 499, which map data, a script or the engine runs by number.
script[499] = moon_flower_palace_stop_s31.arrive_by_train

--- Plays the arrival meeting scene.
function script.cutscene_arrival_meeting()
	object.reset_train_car_parts()
	moon_flower_palace_stop_s31.play_arrival_meeting_scene()
	moon_flower_palace_stop_s31.load_stage_character()
end
script[500] = script.cutscene_arrival_meeting

--- Plays the spikes rising scene and loads s35.
function script.cutscene_spikes_rising()
	moon_flower_palace_stop_s31.play_spikes_rising_scene()
	event.load_dungeon_map("s35")
	event.load_event_script("s35/s35.stb", 500)
	vm.wait(2)
end
script[510] = script.cutscene_spikes_rising

--- Plays the Sun despair scene and loads d06b01.
function script.cutscene_sun_despair()
	moon_flower_palace_stop_s31.play_sun_despair_scene()
	event.load_dungeon_map("d06b01")
	event.load_event_script("d06b01/d06b01.stb", 511)
	vm.wait(2)
end
script[520] = script.cutscene_sun_despair

--- Says the waiting-outside line when the triggering character is the one waiting.
function script.talk_to_waiting_character()
	local character_slot: s32 = 0
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	if character_slot == 8 then
		town_prompt.say_waiting_outside()
	end
end
script[1000] = script.talk_to_waiting_character

return script
