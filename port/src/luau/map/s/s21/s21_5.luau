--!strict
-- map/s/s21/s21_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2a1e9b48 = require("@lib/event/helper_2a1e9b48")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_7c4fb470 = require("@lib/event/helper_7c4fb470")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_cd710052 = require("@lib/event/helper_cd710052")
local helper_e787350a = require("@lib/event/helper_e787350a")
local wait_frames = require("@lib/event/wait_frames")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local argc: s32 = 0
	local flag: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(7689)
	argc = event.get_owned_item_count(374) or argc
	flag = event.get_save_flag(708) or flag
	if argc >= 1 or flag == 1 then
		event.set_function_point_enabled("", "item", 0)
	else
		event.attach_object_handle_to_map_part_2(0, "p06s21")
		event.set_object_handle_visible(0, 1)
	end
	event.set_dungeon_pause_flags(8192, 1)
	event.set_character_change_unmasked(2, 0)
	event.set_character_change_unmasked(3, 0)
	event.set_save_control_bits(1, 1)
	event.set_character_visible(1, 0)
	event.set_character_visible(2, 0)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	event_99()
	flag = event.get_save_flag(704) or flag
	if flag == 0 then
		helper_7c4fb470()
		helper_9dafbc83(0.0, vm.f32(0.8), -200.0, vm.f32(3.14))
		event.set_camera_look_at(0.0, 30.8, -200.0)
		event.set_camera_position(0.0, 40.8, -80.0)
		event.reset_follow_camera(0)
		event.fade_in_screen(30)
		event.finish_event()
	else
		helper_9dafbc83(0.0, vm.f32(8.4), 685.0, vm.f32(3.14))
		event.set_camera_look_at(0.0, 38.4, 685.0)
		event.set_camera_position(0.0, 48.4, 565.0)
		event.reset_follow_camera(0)
		event.fade_in_screen(30)
		event.finish_event()
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	if helper_cd710052() ~= 0 then
		event.set_character_visible(1, 1)
		event.set_character_visible(2, 1)
		event.set_dungeon_pause_flags(8192, 0)
		event.reset_action_character_motion(0)
		event.set_character_change_unmasked(2, 1)
		event.set_character_change_unmasked(3, 1)
		event.set_save_control_bits(1, 0)
		event.load_event_script("d06/d06.stb", 1000)
	end
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local active_chr_no: s32 = 0
	local stage_id: s32 = 0
	local var2: s32 = 0
	local argc: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		if active_chr_no == 2 then
			helper_75684dd8(0, 22, 5, 256, 208)
		else
			helper_75684dd8(0, 23, 5, 256, 208)
		end
		event.finish_event()
		return
	end
	stage_id = event.get_dungeon_stage_id() or stage_id
	var2 = event.get_dungeon_floor() or var2
	argc = event.get_dungeon_next_floor(var2, 0) or argc
	event.set_dungeon_floor(argc)
	event.set_dungeon_floor_info(stage_id, var2, 5, 2)
	event.set_dungeon_floor_info(stage_id, argc, 5, 1)
	wait_frames(6)
	do
		local out1, out2, out3 = event.get_triggered_event_data_4(10)
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.delay_object_sequence_motion_track(0, 10)
	event.set_object_sequence_motion(0, "立ち")
	event.turn_object_sequence_toward(0, var4, var5, var6, 10)
	wait_frames(16)
	event.attach_object_handle_to_map_part_2(1, "p06s21")
	event.set_object_handle_visible(1, 0)
	event.add_inventory_item(374)
	helper_e787350a(374, 1)
	event.set_dungeon_floor_info(6, 11, 5, 2)
	event.set_function_point_enabled("", "item", 0)
	helper_a87eb945(1)
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	helper_2a1e9b48(0)
end

--- Event 17040, which map data, a script or the engine runs by number.
script.event_17040 = helper_7c4fb470

return script
