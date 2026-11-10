--!strict
-- Shared event helper used by 11 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ebb0be6 = require("@lib/event/helper_1ebb0be6")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_562b5326 = require("@lib/event/helper_562b5326")
local helper_5c12934f = require("@lib/event/helper_5c12934f")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_84fa6e6c = require("@lib/event/helper_84fa6e6c")
local helper_87cf4648 = require("@lib/event/helper_87cf4648")
local helper_9594e622 = require("@lib/event/helper_9594e622")
local helper_9a2a4514 = require("@lib/event/helper_9a2a4514")
local helper_b3cde08e = require("@lib/event/helper_b3cde08e")
local helper_e1007dd8 = require("@lib/event/helper_e1007dd8")
local helper_e6c23a00 = require("@lib/event/helper_e6c23a00")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_002aadf3(arg0: s32, count: s32)
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local count_2: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local var14: s32 = 0
	local stage_id: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.set_dungeon_pause_flags(535, 1)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(1)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
			var5 = out4 or var5
		end
		event.set_event_world_coordinate(var2, var3, var4, var5)
		at = 1
		vm.wait(1)
		if arg0 >= 0 then
			event.start_background_file_loads_3(arg0, 1, "effect/itemget.gltf")
		else
			event.start_background_file_loads_1("effect/itemget.gltf")
		end
		event.set_nearest_treasure_box_lid_open(0.0)
		event.set_nearest_treasure_box_state(2)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 29.0, 57.0)
		event.set_camera_sequence_look_at(0.0, 10.0, 0.0)
		event.move_camera_sequence(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
		at = 2
		wait_frames(15)
		at = 3
		helper_84fa6e6c(0)
		at = 4
		wait_frames(5)
		at = 5
		helper_479dc9e9()
		event.load_character(5, "effect/itemget.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(1, 12)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(1, "ゲット", 6)
		at = 6
		wait_frames(5)
		at = 7
		var6 = helper_562b5326(var6)
		if arg0 >= 0 then
			event.load_item_model(5, arg0, "info", 13, 1)
			event.set_character_active(1, 13)
			event.attach_object_handle_to_character(0, 13)
			var7 = helper_e6c23a00(13, arg0, var7)
			event.set_object_handle_scale(0, var7, var7, var7)
			event.set_character_visible(13, 1, 1, 0.1)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.set_object_sequence_position(0, 0.0, -2.5, 0.0)
			event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
			event.delay_object_sequence_position_track(0, 4)
			event.jump_object_sequence(0, 0.0, 17.0, 0.0, -0.3, 20)
			event.jump_object_sequence(0, 0.0, 17.0, 0.0, -0.4, 8)
			event.jump_object_sequence(0, 0.0, 17.0, 0.0, -0.2, 5)
		end
		at = 8
		var6 = helper_1ebb0be6(var6)
		at = 9
		wait_camera()
		if arg0 >= 0 then
			argc = 0
			argc_2 = 0
			count_2 = event.get_item_limit_status(arg0, count) or count_2
			if count_2 >= 1 then
				event.add_inventory_item(arg0, count_2)
				at = 10
				helper_9594e622(arg0, count_2)
			else
				event.set_message_window_mode(0, 4)
				event.set_message_draw_speed(0, 1)
				event.set_message_item_name(0, 1, arg0)
				event.open_message_window_2(0, "Has obtenido [アイテム１],\npero no te queda espacio libre.")
				at = 11
				helper_75684dd8(0, -1, 8, 0, 0)
				event.set_message_draw_speed(0, 0)
			end
			argc = event.get_item_limit_status() or argc
			argc_2 = event.get_overflow_item_count() or argc_2
			print("CHECK_GET_ITEM_LIMIT = ", argc, "\n")
			print("CHECK_ITEM_OVER      = ", argc_2, "\n")
			if argc_2 >= 1 then
				event.fade_out_screen(10)
				at = 12
				wait_frames(10)
				event.open_event_menu(17)
				at = 13
				vm.wait(13)
			end
		else
			event.set_message_window_mode(0, 4)
			event.set_message_draw_speed(0, 1)
			at = 14
			helper_75684dd8(0, 2240, 8, 0, 0)
			event.set_message_draw_speed(0, 0)
		end
		event.set_character_active(1, 0)
		event.delete_character(12)
		event.delete_character(13)
		event.set_nearest_treasure_box_lid_open(1.0)
		event.start_crossfade(10)
		event.set_event_world_coordinate(0.0, 0.0, 0.0, 0.0)
		do
			local out1, out2, out3 = event.get_previous_camera_next_position()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		event.set_camera_position(position_x, position_y, position_z)
		do
			local out1, out2, out3 = event.get_previous_camera_next_look_at()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		event.set_camera_look_at(position_x, position_y, position_z)
		event.reset_follow_camera(0)
		var14 = event.is_trial_version() or var14
		stage_id = event.get_dungeon_stage_id() or stage_id
		if arg0 == 306 and (stage_id == 0 or var14 == 1) then
			event.set_message_window_mode(0, 4)
			at = 15
			helper_75684dd8(0, 2250, 8, 0, 0)
		end
		event.set_dungeon_pause_flags(535, 0)
		event.finish_event()
		return
	end, function(received: { any })
		if at <= 15 then
			if at == 7 then
				var6 = received[2] :: number
			end
			if at == 8 then
				var6 = received[2] :: number
			end
			if at <= 1 then
				wait_frames_skipping(15)
			end
			if at <= 2 then
				helper_87cf4648(0)
			end
			if at <= 3 then
				wait_frames_skipping(5)
			end
			if at <= 4 then
				helper_344d6cd8()
			end
			if at <= 5 then
				wait_frames_skipping(5)
			end
			if at <= 6 then
				var6 = helper_e1007dd8(var6)
			end
			if at <= 7 then
				var7 = helper_b3cde08e(13, arg0, var7)
				var6 = helper_9a2a4514(var6)
			end
			if at <= 8 then
				helper_344d6cd8()
			end
			if at <= 9 then
				argc = 0
				argc_2 = 0
				helper_5c12934f(arg0, count_2)
			end
			if at <= 10 then
				helper_ee1c51d0(0, -1, 8, 0, 0)
			end
			if at <= 11 then
				print("CHECK_GET_ITEM_LIMIT = ", argc, "\n")
				print("CHECK_ITEM_OVER      = ", argc_2, "\n")
				wait_frames_skipping(10)
			end
			if at <= 13 then
				helper_ee1c51d0(0, 2240, 8, 0, 0)
			end
			if at <= 14 then
				helper_ee1c51d0(0, 2250, 8, 0, 0)
			end
			return 0
		end
		return nil
	end)
end

return helper_002aadf3
