--!strict
--- Pump room cutscene floor script for the arrival, elephant landing and ambush events.

local vm = require("@lib/vm")
local channel_pump_room = require("@lib/event/channel_pump_room")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local wait = require("@lib/event/wait")

--- Blocks the floor exit while the party is busy, or asks whether to move to the next floor and loads it.
local function edit_analyze_changed()
	local flag: s32 = 0
	local previous_window_mode: s32 = 0
	local has_party_member: s32 = 0
	local active_chr_no: s32 = 0
	local answer: any = 0
	local stage_id: s32 = 0
	local floor: s32 = 0
	local next_floor: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	event.reset_action_character_motion(0)
	flag = event.get_save_flag(7) or flag
	if flag == 0 then
		event.initialize_event()
		event.set_dungeon_pause_flags(1, 1)
		has_party_member = event.set_party_member(2) or has_party_member
		if has_party_member ~= 0 then
			previous_window_mode = event.get_message_window_frame(0) or previous_window_mode
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.open_message_window_2(0, "今はそれどころじゃない！！")
			message.show_and_wait(0, -1, 5, 0, 0)
			event.set_message_window_mode(0, previous_window_mode)
			vm.wait(2)
			event.set_dungeon_pause_flags(1, 0)
			event.finish_event()
			return
		else
			event.set_character_motion(0, "立ち")
			previous_window_mode = event.get_message_window_frame(0) or previous_window_mode
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			flag = event.get_save_flag(104) or flag
			if flag == 1 then
				event.open_message_window_2(0, "扉は開きそうにない。\nいったん上に戻ろう！")
			else
				event.open_message_window_2(0, "今はそれどころじゃない！！")
			end
			message.show_and_wait(0, -1, 5, 0, 0)
			event.set_message_window_mode(0, previous_window_mode)
			vm.wait(4)
			event.set_dungeon_pause_flags(1, 0)
			event.finish_event()
			return
		end
	end
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "ライドポッドから降りないと先へ進めそうにない。")
		message.show_and_wait(0, -1, 8, 256, 208)
		event.finish_event()
		return
	end
	if active_chr_no == 3 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		message.show_and_wait(0, 21, 8, 256, 208)
		event.finish_event()
		return
	end
	event.set_message_window_mode(0, 5)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "次のフロアへ進みますか？")
	answer = message.ask_choice(0, -1, 8, 256, 208, 2, 1)
	if answer == 0 then
		event.set_save_control_bits(1, 0)
		stage_id = event.get_dungeon_stage_id() or stage_id
		floor = event.get_dungeon_floor() or floor
		next_floor = event.get_dungeon_next_floor(floor, 0) or next_floor
		event.set_dungeon_floor(next_floor)
		event.set_dungeon_floor_info(stage_id, floor, 5, 2)
		event.set_dungeon_floor_info(stage_id, next_floor, 5, 1)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		flag = event.get_save_flag(8) or flag
		if flag == 0 then
			event.stop_music(0)
			event.set_save_flag(8, 1)
			event.skip_next_music_load()
			event.go_to_georama_edit(12, 540)
			vm.wait(9)
			return
		end
		event.skip_next_music_load()
		event.go_to_dungeon(0, 5, 1000)
		vm.wait(10)
	end
	event.finish_event()
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing for this map.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Suppresses the default square-button event.
function script.key_open() end

--- Event 300, which map data, a script or the engine runs by number.
script[300] = edit_analyze_changed

script.edit_analyze_changed = edit_analyze_changed

--- Loads the monster and plays the pump room arrival cutscene before returning to the main script.
function script.cutscene_arrival()
	event.load_dungeon_monster(614, 1)
	channel_pump_room.play_pump_room_intro_event()
	event.load_sound_effect_file_3(4, "snd2/event/ev_200_000.sound.json")
	event.load_event_script("s06/s06.stb", -1)
end
script[500] = script.cutscene_arrival

--- Loads the exit room script.
function script.enter_room_c()
	event.initialize_event()
	event.load_event_script("s06/s06c.stb", 500)
	vm.wait(1)
end
script[501] = script.enter_room_c

--- Plays the elephant landing cutscene before returning to the main script.
function script.cutscene_elephant_landing()
	event.load_dungeon_monster(601, 1)
	channel_pump_room.play_elephant_cutscene_with_landing()
	event.load_event_script("s06/s06.stb", -1)
end
script[510] = script.cutscene_elephant_landing

--- Plays the elephant ambush cutscene before returning to the main script.
function script.cutscene_elephant_ambush()
	event.load_dungeon_monster(601, 1)
	channel_pump_room.play_elephant_ambush_event()
	event.load_event_script("s06/s06.stb", -1)
end
script[520] = script.cutscene_elephant_ambush

--- Runs the defeat sequence, or loads the Polcurse escape cutscene when the party falls while riding the Ridepod before the elephant is beaten.
function script.on_party_defeated()
	local active_chr_no: s32 = 0
	local flag: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 then
			flag = event.get_save_flag(7) or flag
			if flag == 0 then
				event.set_save_flag(6, 1)
				resume_step = 1
				vm.wait(1)
				event.load_event_script("s06/s06.stb", 503)
			else
				resume_step = 2
				dungeon.run_defeat_sequence_silent(0)
			end
		else
			resume_step = 3
			dungeon.run_defeat_sequence_silent(0)
		end
		return
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step <= 1 then
				dungeon.skip_defeat_sequence_silent(0)
			end
			if resume_step <= 2 then
				dungeon.skip_defeat_sequence_silent(0)
			end
			return 0
		end
		return nil
	end)
end
script[1200] = script.on_party_defeated

return script
