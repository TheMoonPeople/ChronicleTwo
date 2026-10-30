--!strict
-- map/d/d02/d02_sfida_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_17b6d01b = require("@lib/event/helper_17b6d01b")
local helper_1a7fd8eb = require("@lib/event/helper_1a7fd8eb")
local helper_39ab7f1f = require("@lib/event/helper_39ab7f1f")
local helper_3cf99f2c = require("@lib/event/helper_3cf99f2c")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_49c6448e = require("@lib/event/helper_49c6448e")
local helper_55646435 = require("@lib/event/helper_55646435")
local helper_581cb30c = require("@lib/event/helper_581cb30c")
local helper_6a55557d = require("@lib/event/helper_6a55557d")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_7982ab52 = require("@lib/event/helper_7982ab52")
local helper_79d90c82 = require("@lib/event/helper_79d90c82")
local helper_7b560508 = require("@lib/event/helper_7b560508")
local helper_86f3f24c = require("@lib/event/helper_86f3f24c")
local helper_b1b0c1a6 = require("@lib/event/helper_b1b0c1a6")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_c24a11db = require("@lib/event/helper_c24a11db")
local helper_c3f198dd = require("@lib/event/helper_c3f198dd")
local helper_c44453a9 = require("@lib/event/helper_c44453a9")
local helper_ce85b54c = require("@lib/event/helper_ce85b54c")
local helper_dff48a5c = require("@lib/event/helper_dff48a5c")
local helper_e91d3484 = require("@lib/event/helper_e91d3484")
local helper_f7fba8ce = require("@lib/event/helper_f7fba8ce")
local helper_f90045b0 = require("@lib/event/helper_f90045b0")
local open_message = require("@lib/event/open_message")
local wait_frames = require("@lib/event/wait_frames")
local wait_message_answer = require("@lib/event/wait_message_answer")
local wait_objects = require("@lib/event/wait_objects")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local argc: s32 = 0
	event.initialize_event()
	vm.wait(1)
	event.add_inventory_item(305, 1)
	event.add_inventory_item(306, 1)
	argc = event.get_owned_item_count(10) or argc
	if argc <= 0 then
		event.add_inventory_item(10, 1)
	end
	argc = event.get_owned_item_count(302) or argc
	if argc <= 0 then
		event.add_inventory_item(302, 1)
	end
	event.set_save_flag(220, 1)
	event.set_save_flag(317, 1)
	event.clear_event_battle_monsters(-1)
	event.finish_event()
end

--- The dungeon system event run when the player steps into a random circle.
function script.random_circle()
	local active_chr_no: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var11: s32 = 0
	local weight: f32 = 0
	local var14: f32 = 0
	local now_party_chara_id: s32 = 0
	local circle_id: s32 = 0
	local var18: s32 = 0
	local var19: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local pos_x_4: f32 = 0
	local pos_y_4: f32 = 0
	local pos_z_4: f32 = 0
	local var26: f32 = 0
	local var27: s32 = 0
	local angle: f32 = 0
	local var29: s32 = 0
	local var30: s32 = 0
	local bright_rate: f32 = 0
	local var32: s32 = 0
	local result: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(513, 1)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		helper_ce85b54c()
		if active_chr_no == 2 then
			helper_75684dd8(0, 22, 8, 0, 0)
		else
			helper_75684dd8(0, 23, 8, 0, 0)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		do
			local out1, out2, out3 = event.get_random_circle_position(-1)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		yaw = event.get_direction_angle(pos_x, pos_y, pos_z, var1, var2, var3) or yaw
		var1 = vm.f32(vm.f32(vm.sin(yaw) * 25.0) + pos_x)
		var2 = pos_y
		var3 = vm.f32(vm.f32(vm.cos(yaw) * 25.0) + pos_z)
		event.set_character_position(0, var1, var2, var3)
		event.set_dungeon_pause_flags(513, 0)
		event.finish_event()
		return
	end
	event.start_background_file_loads_1("snd2/sp/sp_011.sound.json")
	vm.wait(3)
	helper_ce85b54c()
	do
		local out1, out2, out3 = event.get_random_circle_position(-1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	event.set_camera_control_enabled(0)
	event.set_follow_camera_following(1)
	event.set_follow_camera_target_alternate(pos_x_2, pos_y_2 + 30.0, pos_z_2)
	event.set_camera_speed(8.0)
	event.set_follow_camera_offset(0.0, 0.0, 0.0)
	event.set_follow_camera_height(0.0)
	event.set_follow_camera_distance(80.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	helper_479dc9e9()
	var11 = event.load_sound_effect_file_3(8, "snd2/sp/sp_011.sound.json") or var11
	event.change_directory("event/dng/")
	event.start_background_file_loads_2("ring.gltf", "randomcoin.gltf")
	vm.wait(5)
	helper_479dc9e9()
	weight = event.get_random_circle_motion_frame() or weight
	event.deactivate_random_circle(-1)
	event.load_character(5, "ring.gltf", "info", 12)
	event.set_character_active(1, 12)
	event.set_character_position(12, pos_x_2, pos_y_2, pos_z_2)
	event.set_character_motion(12, "ループ", 6)
	event.update_character_motion(12)
	event.set_character_motion_frame(12, weight)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.queue_object_sequence_next_motion(4, "消滅", 6)
	event.load_character(5, "randomcoin.gltf", "info", 13)
	event.set_character_active(1, 13)
	event.set_character_position(13, pos_x_2, pos_y_2 - 30.0, pos_z_2)
	var14 = event.get_random_number(6.2831855) or var14
	var14 = vm.f32(var14 - vm.f32(3.1415927))
	var14 = event.wrap_angle(var14) or var14
	event.set_character_rotation(13, 0.0, var14, 0.0)
	event.change_directory("")
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	event.attach_object_handle_to_character(5, 13)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_scale(5, 0.0, 0.0, 0.0)
	event.set_object_sequence_scale(5, 1.0, 1.0, 1.0, 40)
	event.move_object_sequence_eased(5, pos_x_2, pos_y_2 + 40.0, pos_z_2, 30, 2, 0.5)
	var18 = 0
	var19 = vm.f32(0.6)
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			var14 = out2 or var14
		end
		var14 = vm.f32(var14 + var19)
		var14 = event.wrap_angle(var14) or var14
		event.set_character_rotation(13, 0.0, var14, 0.0)
		if var18 == 10 then
			event.play_sound_effect(var11, 0)
		end
		if var18 == 30 then
			helper_55646435()
		end
		if (if var18 >= 30 then helper_581cb30c(0) else 0) ~= 0 or var18 > 300 then
			event.stop_sound_effect(var11, 0)
			event.play_sound_effect(var11, 3)
			vm.wait(7)
			break
		else
			var18 = var18 + 1
			vm.wait(8)
		end
	end
	helper_3cf99f2c()
	event.attach_object_handle_to_character(5, 13)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	do
		local out1, out2, out3 = event.get_camera_position()
		pos_x_3 = out1 or pos_x_3
		pos_y_3 = out2 or pos_y_3
		pos_z_3 = out3 or pos_z_3
	end
	do
		local out1, out2, out3 = event.get_camera_look_at()
		pos_x_4 = out1 or pos_x_4
		pos_y_4 = out2 or pos_y_4
		pos_z_4 = out3 or pos_z_4
	end
	var26 = event.get_direction_angle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	var27 = 0
	var27 = vm.float_bits(event.get_random_number(10)) or var27
	var27 = vm.i32(var27 + 4)
	var18 = 0
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			var14 = out2 or var14
		end
		var14 = vm.f32(var14 + var19)
		var14 = event.wrap_angle(var14) or var14
		event.set_character_rotation(13, 0.0, var14, 0.0)
		vm.wait(9)
		if var18 >= var27 then
			if var19 > vm.f32(0.08) then
				var19 = vm.f32(var19 * vm.f32(0.9))
			end
			angle = var26
			angle = event.wrap_angle(angle) or angle
			if var14 < angle and helper_f7fba8ce(var14, angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, angle, 0.0)
				circle_id = 0
				break
			end
			angle = vm.f32(var26 - vm.f32(3.1415927))
			angle = event.wrap_angle(angle) or angle
			if var14 < angle and helper_f7fba8ce(var14, angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, angle, 0.0)
				circle_id = 1
				break
			end
		end
		var18 = vm.i32(var18 + 1)
	end
	var26 = event.get_direction_angle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	do
		local _, out2, _ = event.get_character_rotation(13)
		var14 = out2 or var14
	end
	if helper_f7fba8ce(var14, var26, 1.0) == 0 then
		circle_id = 0
	else
		circle_id = 1
	end
	var26 = var14
	wait_frames(20)
	var29 = vm.float_bits(event.get_random_number(10)) or var29
	if now_party_chara_id == 24 then
		var30 = 100
	else
		var30 = 6
	end
	if var29 < var30 then
		var29 = vm.float_bits(event.get_random_number(10)) or var29
		if circle_id == 0 then
			if now_party_chara_id == 24 then
				var30 = 0
			else
				var30 = 2
			end
		elseif now_party_chara_id == 24 then
			var30 = 100
		else
			var30 = 4
		end
		if var29 < var30 then
			var26 = vm.f32(var26 + vm.f32(3.14))
			var26 = event.wrap_angle(var26) or var26
			event.rotate_object_sequence(5, 0.0, var26, 0.0, 8)
			if circle_id == 0 then
				circle_id = 1
			else
				circle_id = 0
			end
			wait_frames(10)
		else
			var29 = vm.float_bits(event.get_random_number(10)) or var29
			if var29 < 1 then
				var26 = vm.f32(var26 + vm.f32(3.14))
				var26 = event.wrap_angle(var26) or var26
				event.rotate_object_sequence(5, 0.0, var26, 0.0, 6)
				var26 = vm.f32(var26 + vm.f32(1.57))
				var26 = event.wrap_angle(var26) or var26
				event.rotate_object_sequence(5, 0.0, var26, 0.0, 3)
				var26 = vm.f32(var26 + vm.f32(1.57))
				var26 = event.wrap_angle(var26) or var26
				event.rotate_object_sequence(5, 0.0, var26, 0.0, 3)
				wait_frames(20)
			end
		end
	end
	var26 = event.get_direction_angle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	do
		local _, out2, _ = event.get_character_rotation(13)
		var14 = out2 or var14
	end
	if helper_f7fba8ce(var14, var26, 1.0) == 0 then
		circle_id = 0
	else
		circle_id = 1
	end
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	bright_rate = 1.0
	var18 = 0
	var32 = event.get_random_circle_effect(circle_id) or var32
	if circle_id == 0 then
		event.play_sound_effect(var11, 1)
		while var18 < 30 do
			event.set_dungeon_brightness_rate(bright_rate)
			bright_rate = vm.f32(bright_rate + vm.f32(0.03))
			var18 = var18 + 1
			vm.wait(13)
		end
		helper_75684dd8(0, 2310, 8, 0, 0)
		result = event.apply_random_circle_effect(var32) or result
		if var32 == 1 then
			helper_75684dd8(0, 2311, 8, 0, 0)
		end
		if var32 == 2 then
			helper_75684dd8(0, 2312, 8, 0, 0)
		end
		if var32 == 3 then
			helper_75684dd8(0, 2313, 8, 0, 0)
		end
		if var32 == 4 then
			event.place_treasure_box(pos_x_2, pos_y_2, pos_z_2, var26, 294)
			helper_75684dd8(0, 2314, 8, 0, 0)
		end
	else
		event.play_sound_effect(var11, 2)
		while var18 < 30 do
			event.set_dungeon_brightness_rate(bright_rate)
			bright_rate = vm.f32(bright_rate - vm.f32(0.03))
			var18 = var18 + 1
			vm.wait(19)
		end
		helper_75684dd8(0, 2320, 8, 0, 0)
		result = event.apply_random_circle_effect(var32) or result
		if var32 == 5 then
			if active_chr_no == 0 or active_chr_no == 2 then
				helper_75684dd8(0, 2321, 8, 0, 0)
			end
			if active_chr_no == 1 or active_chr_no == 3 then
				helper_75684dd8(0, 2322, 8, 0, 0)
			end
		end
		if var32 == 6 then
			if active_chr_no == 0 then
				helper_75684dd8(0, 2323, 8, 0, 0)
			end
			if active_chr_no == 1 or active_chr_no == 3 then
				helper_75684dd8(0, 2324, 8, 0, 0)
			end
			if active_chr_no == 2 then
				helper_75684dd8(0, 2325, 8, 0, 0)
			end
		end
		if var32 == 8 then
			helper_75684dd8(0, 2328, 8, 0, 0)
		end
		if var32 == 9 then
			helper_75684dd8(0, 2326, 8, 0, 0)
		end
		if var32 == 10 then
			helper_75684dd8(0, 2329, 8, 0, 0)
		end
		if var32 == 11 then
			helper_75684dd8(0, 2327, 8, 0, 0)
		end
		if var32 == 12 then
			helper_75684dd8(0, 2330, 8, 0, 0)
		end
	end
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_brightness_rate(1.0)
	if var32 == 1 then
		event.spawn_pull_items(pos_x_2, pos_y_2, pos_z_2, 1, 10, result / 10.0)
	end
	event.set_dungeon_pause_flags(513, 0)
	event.set_camera_control_enabled(1)
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
	event.delete_character(12)
	event.delete_character(13)
	event.start_crossfade(15)
	event.finish_event()
end

--- The dungeon system event run when the player uses the geostone.
function script.geostone()
	local active_chr_no: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var17: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local argc: s32 = 0
	local stage_id: s32 = 0
	local var23: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(513, 1)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		helper_ce85b54c()
		if active_chr_no == 2 then
			helper_75684dd8(0, 22, 8, 0, 0)
		else
			helper_75684dd8(0, 23, 8, 0, 0)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.set_dungeon_pause_flags(513, 0)
		event.finish_event()
		return
	end
	event.set_dungeon_pause_flags(16, 1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_save_flag(31, 1)
	event.set_character_motion(0, "立ち")
	do
		local out1, out2, out3 = event.get_character_position(0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	if active_chr_no == 0 then
		event.start_background_file_loads_3(
			"dungeon/chara/c01_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(3)
		helper_479dc9e9()
		event.load_character_motion_pack(5, "dungeon/chara/c01_gio.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.start_background_file_loads_3(
			"dungeon/chara/c02_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(5)
		helper_479dc9e9()
		event.load_character_motion_pack(5, "dungeon/chara/c02_gio.gltf", "info", 0)
	end
	var4 = event.load_sound_effect_file_3(8, "snd2/sp/sp_012.sound.json") or var4
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	do
		local out1, out2, out3 = event.get_camera_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.get_character_position(0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	event.copy_vector(var8, var9, var10)
	event.stop_geostone_animation()
	event.attach_object_handle_to_geostone(1)
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	pos_y_2 = vm.f32(var9 + 18.0)
	event.set_object_handle_position(1, pos_x_2, pos_y_2, pos_z_2)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	var17 = event.get_direction_angle(pos_x_2, pos_y_2, pos_z_2, pos_x, pos_y, pos_z) or var17
	var17 = event.wrap_angle(var17) or var17
	if active_chr_no == 0 then
		var17 = vm.f32(var17 + vm.f32(2.9))
	end
	if active_chr_no == 1 then
		var17 = vm.f32(var17 + vm.f32(2.4))
	end
	var17 = event.wrap_angle(var17) or var17
	var8 = vm.f32(vm.f32(vm.sin(var17) * 14.0) + pos_x_2)
	var10 = vm.f32(vm.f32(vm.cos(var17) * 14.0) + pos_z_2)
	event.set_character_position(0, var8, var9, var10)
	var17 = vm.f32(var17 - vm.f32(3.1415927))
	var17 = event.wrap_angle(var17) or var17
	event.set_character_rotation(0, 0.0, var17, 0.0)
	event.reset_object_handle_dynamic_animation(0)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 12)
	event.set_character_active(0, 12)
	if active_chr_no == 0 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(var8, var9 + 18.0, var10)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 6.0, 0.0)
		event.set_follow_camera_height(-14.0)
		event.set_follow_camera_distance(54.0)
		event.set_character_position(12, var8, var9 + 36.0, var10)
	end
	if active_chr_no == 1 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(var8, var9 + 18.0, var10)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_height(-5.0)
		event.set_follow_camera_distance(34.0)
		pos_x_3 = vm.f32(vm.f32(vm.sin(var17) * 8.0) + var8)
		pos_y_3 = vm.f32(var9 + 18.0)
		pos_z_3 = vm.f32(vm.f32(vm.cos(var17) * 8.0) + var10)
		event.set_character_position(12, pos_x_3, pos_y_3, pos_z_3)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.start_crossfade(30)
	event.set_object_sequence_motion(0, "取る", 6)
	event.queue_object_sequence_next_motion(0, "取るL", 4)
	wait_frames(16)
	event.play_sound_effect(var4, 0)
	wait_frames(2)
	event.set_object_handle_position(1, 0.0, 0.0, 0.0)
	event.attach_geostone_to_character_frame(0, "item")
	wait_frames(10)
	do
		local out1, out2, out3 = event.get_camera_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var17 = event.get_direction_angle(var8, var9, var10, pos_x, pos_y, pos_z) or var17
	event.set_character_rotation(12, 0.0, var17, 0.0)
	event.set_character_active(1, 12)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_motion(4, "発動", 6, 1.2)
	event.wait_object_sequence_motion_end(4)
	event.reset_object_sequence_motion(4)
	event.set_object_sequence_motion(4, "発動", 5)
	wait_frames(20)
	event.play_sound_effect(var4, 1)
	wait_objects(0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	argc = event.get_system_sound_id() or argc
	event.play_sound_effect(argc, 18)
	helper_75684dd8(0, 2400, 8, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	stage_id = event.get_dungeon_stage_id() or stage_id
	var23 = event.get_dungeon_floor() or var23
	event.set_dungeon_floor_info(stage_id, var23, 5, 256)
	event.start_crossfade(10)
	if active_chr_no == 1 then
		event.set_character_motion(0, "取る戻り", 6)
		vm.wait(13)
	end
	event.set_dungeon_pause_flags(529, 0)
	event.set_character_motion(0, "立ち", 4)
	event.set_character_position(0, var1, var2, var3)
	event.reset_object_handle_dynamic_animation(0)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.detach_geostone_from_character_frame()
	event.set_geostone_placed(0)
	event.set_object_handle_scale(1, 1.0, 1.0, 1.0)
	event.delete_character_extension_packs(0)
	event.delete_character(12)
	event.set_camera_control_enabled(1)
	event.finish_event()
end

--- The dungeon system event run on the first examination of a random stone.
function script.random_stone_guide()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.set_dungeon_pause_flags(513, 1)
	event.set_save_flag(50, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	helper_75684dd8(0, 2600, 8, 0, 0)
	vm.wait(2)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(513, 0)
	event.finish_event()
end

--- Event 2510, which map data, a script or the engine runs by number.
function script.event_2510()
	local var0: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(515, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	open_message(0, 2610, 8, 0, 0)
	wait_frames(30)
	do
		local _: any
		_, var0 = wait_message_answer(0, 0, var0)
	end
	close_message(0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- The dungeon system event run the first time the player levels up.
function script.level_up_guide()
	local var0: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(515, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	open_message(0, 2620, 8, 0, 0)
	wait_frames(30)
	do
		local _: any
		_, var0 = wait_message_answer(0, 0, var0)
	end
	close_message(0)
	helper_75684dd8(0, 2621, 8, 0, 0)
	helper_75684dd8(0, 2622, 8, 0, 0)
	helper_75684dd8(0, 2623, 8, 0, 0)
	event.open_message_window_2(0, "Voir Aide (Menu principal) pour infos")
	helper_75684dd8(0, -1, 8, 0, 0)
	vm.wait(7)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- The dungeon system event run the first time the ridepod's wheels are used.
function script.robo_bike_guide()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.set_dungeon_pause_flags(513, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		"[(!)]Conduire le Tout-terrain\n   Acc[UNI00e9]l[UNI00e8]re avec (L)↑ - Ralentis avec (L)↓.\n   Tourne avec (L) ← ou →.\n   Virages serr[UNI00e9]s : [l1] + (L) ← ou →."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	vm.wait(2)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(513, 0)
	event.finish_event()
end

--- The dungeon system event run the first time the magic sword counter fills.
function script.magic_sword_guide()
	event.initialize_event()
	event.set_dungeon_pause_flags(515, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "[(!)]Tu ma[UNI00ee]trises d[UNI00e9]sormais la Lame Absomagie.")
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"La Lame Absomagie permet d'absorber\nl'[UNI00e9]nergie des attaques [UNI00e9]l[UNI00e9]mentales\n(ex : feu) en parant. Pour renvoyer\nl'[UNI00e9]nergie, il suffit d'attaquer."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Tu peux sans cesse accumuler de\nl'[UNI00e9]nergie d'un m[UNI00ea]me type [UNI00e9]l[UNI00e9]mental.\nMais si tu absorbes un autre type\nd'[UNI00e9]nergie, ton arme se d[UNI00e9]chargera."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"La quantit[UNI00e9] maximale d'[UNI00e9]nergie\n[UNI00e9]l[UNI00e9]mentale absorb[UNI00e9]e par une arme\nd[UNI00e9]pend de la solidit[UNI00e9] de celle-ci."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Pour rel[UNI00e2]cher l'[UNI00e9]nergie [UNI00e9]l[UNI00e9]mentale\naccumul[UNI00e9]e, appuie sur [l1] tout en\nparant avec [r1]."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	vm.wait(6)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- The Sphida event run when the player stands at the ball and presses the action button.
function script.sphida_shot()
	local var0: s32 = 0
	local tex_bank: s32 = 0
	local var2: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local level: s32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: s32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var30: s32 = 0
	local var31: f32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	local var38: f32 = 0
	local var39: f32 = 0
	local var40: f32 = 0
	local var41: f32 = 0
	local var42: s32 = 0
	local var43: s32 = 0
	local var44: s32 = 0
	local var45: s32 = 0
	local var46: s32 = 0
	local var47: s32 = 0
	local var48: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var52: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local yaw: f32 = 0
	local count: s32 = 0
	local var58: any = 0
	vm.wait(1)
	event.initialize_event()
	helper_ce85b54c()
	event.set_character_motion(0, "立ち")
	if helper_17b6d01b() ~= 0 then
		event.finish_event()
		return
	end
	var0 = event.is_sphida_bonus_course() or var0
	if var0 == 0 then
		event.show_dungeon_status_bar(0, 0.1)
	end
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_4(
		"dungeon/sphida/c01_golf.gltf",
		"dungeon/chara/c01b_miss.gltf",
		"dungeon/sphida/gool_end.gltf",
		"dungeon/sphida/mizu_eff.gltf"
	)
	vm.wait(3)
	helper_479dc9e9()
	event.load_character_motion_pack(5, "dungeon/sphida/c01_golf.gltf", "info", 0)
	event.load_character_motion_pack(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	tex_bank = event.get_sphida_texture_bank() or tex_bank
	event.load_character(5, "dungeon/sphida/gool_end.gltf", "info", 12)
	event.set_character_active(0, 12)
	var2 = event.load_sound_effect_file_3(5, "snd2/mon/en_900.sound.json") or var2
	event.create_sword_afterimage(5, 64, 16)
	event.set_sword_afterimage_color(128, 128, 128, 80, 128, 128, 128, 80)
	event.initialize_effect_manager(5, 1)
	event.load_effect_base_pack("足水パシャ", "dungeon/sphida/mizu_eff.gltf")
	event.create_effect_work_buffer(5)
	event.attach_object_handle_to_character(0, 2)
	event.set_object_handle_visible(0, 0)
	event.start_crossfade(15)
	event.reset_sphida_power_gauge()
	do
		local out1, out2, out3 = event.get_sphida_ball_position()
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	var3, var4, var5, var7 = helper_49c6448e(var3, var4, var5, var7)
	helper_1a7fd8eb(var7)
	event.set_sphida_status_panel_visible(1)
	var12 = 12.5
	event.set_sphida_carry_angle(vm.f32(var12 * vm.f32(3.1415927)) / 180.0)
	var13, var14, level = helper_39ab7f1f(var13, var14, level)
	event.set_sphida_power_gauge_safe_level(level)
	do
		local out1, out2, out3 = event.zero_vector()
		var16 = out1 or var16
		var17 = out2 or var17
		var18 = out3 or var18
	end
	while true do
		event.set_sphida_minimap_scroll_enabled(1)
		event.set_sphida_minimap_shot_line_visible(1)
		local t0: s32
		t0, var7, var12 = helper_86f3f24c(var7, var12, tex_bank)
		if t0 ~= 0 then
			event.set_sphida_minimap_scroll_enabled(0)
			event.set_sphida_minimap_shot_line_visible(0)
			event.set_sphida_ball_position(var9, var10, var11)
			event.set_character_position(8, var9, var10, var11)
			event.set_character_position(9, var9, var10, var11)
			helper_6a55557d(0)
			return
		end
		event.set_sphida_minimap_scroll_enabled(0)
		event.set_sphida_minimap_shot_line_visible(0)
		local t1: s32
		t1, var13, var7, var17, var16, level = helper_b1b0c1a6(var13, tex_bank, var7, var17, var16, var2, level)
		if t1 == 0 then
			break
		else
			vm.wait(8)
		end
	end
	do
		local out1, out2, out3 = event.copy_vector(var3, var4, var5)
		var19 = out1 or var19
		var20 = out2 or var20
		var21 = out3 or var21
	end
	var22 = 0
	if level ~= 1 and level ~= -1 and level ~= 4 then
		event.set_event_sprite_type(0, 1)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_event_sprite_size(0, 10.8, 11.6)
		event.set_event_sprite_position(0, var3, var4 + 30.0, var5)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		if level == 0 then
			event.set_event_sprite_texture_rect(0, 78, 198, 54, 58)
		end
		if level == 2 or level == -2 then
			event.set_event_sprite_texture_rect(0, 186, 190, 70, 66)
		end
		if level == 3 or level == -3 then
			event.set_event_sprite_texture_rect(0, 132, 198, 54, 58)
		end
		event.attach_object_handle_to_sprite(18, 0)
		event.clear_object_sequence(18)
		event.set_object_sequence_object(18, 18)
		event.set_object_sequence_color(18, 128, 128, 128, 128, 4)
		event.delay_object_sequence_color_track(18, 20)
		event.set_object_sequence_color(18, 128, 128, 128, 0, 6)
		wait_frames(10)
	end
	if var13 <= vm.f32(0.3) then
		event.set_character_motion(0, "小ショット", 2)
		wait_frames(25)
		if level ~= 4 then
			event.play_sound_effect(var2, 3)
		end
	elseif var13 <= vm.f32(0.6) then
		event.set_character_motion(0, "中ショット", 2)
		wait_frames(34)
		event.play_sound_effect(var2, 2)
	else
		event.set_character_motion(0, "大ショット", 2)
		wait_frames(39)
		if level == 0 then
			event.play_sound_effect(var2, 12)
		else
			event.play_sound_effect(var2, 1)
		end
	end
	if level == 4 then
		wait_frames(50)
		helper_f90045b0(var2)
		event.set_sphida_ball_position(var9, var10, var11)
		event.set_character_position(8, var9, var10, var11)
		event.set_character_position(9, var9, var10, var11)
		helper_6a55557d(0)
		return
	end
	if level == 0 then
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_draw_pass(1, 1)
		event.set_event_sprite_position(1, 256, 278)
		event.set_event_sprite_texture_rect(1, 246, 104, 266, 42)
		event.set_event_sprite_size(1, 266, 42)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_scale(1, 10, 10, 10)
		event.attach_object_handle_to_sprite(19, 1)
		event.clear_object_sequence(19)
		event.set_object_sequence_object(19, 19)
		event.jump_object_sequence(19, 256, 138, 0, 3.6, 20)
		event.set_object_sequence_scale(19, 1, 1, 1, 18)
		event.set_object_sequence_color(19, 128, 128, 128, 128, 12)
		event.delay_object_sequence_color_track(19, 30)
		event.set_object_sequence_color(19, 128, 128, 128, 0, 6)
	end
	var13 = helper_dff48a5c(var13)
	var12 = vm.f32(vm.f32(var12 * vm.f32(3.1415927)) / 180.0)
	var13 = vm.f32(var13 - vm.f32(var13 * var12))
	var23 = vm.f32(vm.sin(var7) * vm.f32(var13 * vm.cos(var12)))
	var24 = vm.f32(var13 * vm.sin(var12))
	var25 = vm.f32(vm.cos(var7) * vm.f32(var13 * vm.cos(var12)))
	var17 = vm.f32(vm.f32(var17 * vm.f32(3.1415927)) / 2.0)
	var18 = vm.f32(vm.f32(vm.f32(-var25 * var14) * var16) * vm.f32(0.4))
	var16 = vm.f32(vm.f32(vm.f32(-var23 * var14) * var16) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var30 = 0
	level = 0
	var43 = 0
	do
		local out1, out2, out3, out4, out5 =
			event.get_segment_collision_13(0, var3, var4 + 5.0, var5, var3, var4, var5, 0)
		var31 = out1 or var31
		var32 = out2 or var32
		var33 = out3 or var33
		var42 = out4 or var42
		var44 = out5 or var44
	end
	if var42 >= 0 and (var44 == 1 or var44 == 7) then
		print("----------------START_MIZU-------------------\n")
		var13 = 1.0
	else
		print("----------------START_SOTO-------------------\n")
		var13 = 0.0
	end
	var47 = 0
	while true do
		if var4 >= 180.0 then
			var23 = vm.f32(var23 * vm.f32(0.999))
			var24 = vm.f32(var24 + vm.f32(vm.f32(-0.0098) * (var47 + 1)))
			var25 = vm.f32(var25 * vm.f32(0.999))
		else
			var42 = event.get_segment_collision_9(12, var3, var4, var5, var3, vm.f32(var4 - 3.0) - vm.f32(0.01), var5, 0)
				or var42
			if level == 1 and var42 >= 0 then
				var23 = vm.f32(var23 * vm.f32(0.94))
				var24 = vm.f32(var24 + vm.f32(vm.f32(-0.00045) * (var47 + 1)))
				var25 = vm.f32(var25 * vm.f32(0.94))
				var23 = vm.f32(var23 + var16)
				var25 = vm.f32(var25 + var18)
				var16 = vm.f32(var16 * vm.f32(0.8))
				var18 = vm.f32(var18 * vm.f32(0.8))
			else
				var23 = vm.f32(var23 * vm.f32(0.999))
				var24 = vm.f32(var24 + vm.f32(vm.f32(-0.0045) * (var47 + 1)))
				var25 = vm.f32(var25 * vm.f32(0.999))
			end
		end
		do
			local out1, out2, out3 = event.add_vectors(var3, var4, var5, var23, var24, var25)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		if var17 ~= 0.0 then
			var12 = event.get_direction_angle(var19, var20, var21, var3, var4, var5) or var12
			var12 = vm.f32(var12 + var17)
			var12 = event.wrap_angle(var12) or var12
			var23 = vm.f32(var23 + vm.f32(vm.f32(vm.sin(var12) / 10.0) * var14))
			var25 = vm.f32(var25 + vm.f32(vm.f32(vm.cos(var12) / 10.0) * var14))
		end
		var41 = event.get_vector_length(var16, 0.0, var18) or var41
		if var41 > vm.f32(0.01) then
			var26 = event.get_vector_length(var16, 0.0, var18) or var26
			var12 = event.get_direction_angle(var19, var20, var21, var19 + var16, var20, var21 + var18) or var12
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				var6 = out1 or var6
				var7 = out2 or var7
				var8 = out3 or var8
			end
			event.set_character_rotation(8, var6, var12, var8)
			event.offset_character_rotation(8, var26 * 12.0, 0.0, 0.0)
			event.set_character_rotation(9, var6, var12, var8)
			event.offset_character_rotation(9, var26 * 12.0, 0.0, 0.0)
		else
			var26 = event.get_vector_length(var23, 0.0, var25) or var26
			var12 = event.get_direction_angle(var19, var20, var21, var3, var4, var5) or var12
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				var6 = out1 or var6
				var7 = out2 or var7
				var8 = out3 or var8
			end
			event.set_character_rotation(8, var6, var12, var8)
			event.offset_character_rotation(8, var26 / 10.0, 0.0, 0.0)
			event.set_character_rotation(9, var6, var12, var8)
			event.offset_character_rotation(9, var26 / 10.0, 0.0, 0.0)
		end
		var26 = event.get_vector_length(var23, var24, var25) or var26
		var40 = var26
		var12 = event.get_direction_angle(var19, var20, var21, var3, var4, var5) or var12
		var37 = vm.f32(vm.sin(vm.f32(var12 - vm.f32(1.5707964))) * 3.0)
		var39 = vm.f32(vm.cos(vm.f32(var12 - vm.f32(1.5707964))) * 3.0)
		event.add_sword_afterimage_point(
			var3 - var37,
			var4,
			var5 - var39,
			vm.f32(var3 + var37) + var37,
			var4,
			vm.f32(var5 + var39) + var39
		)
		do
			local out1, out2, out3 = event.copy_vector(var23, var24, var25)
			var37 = out1 or var37
			var38 = out2 or var38
			var39 = out3 or var39
		end
		do
			local out1, out2, out3 = event.normalize_vector(var37, var38, var39)
			var37 = out1 or var37
			var38 = out2 or var38
			var39 = out3 or var39
		end
		do
			local out1, out2, out3 = event.scale_vector(var37, var38, var39, 3.0)
			var37 = out1 or var37
			var38 = out2 or var38
			var39 = out3 or var39
		end
		do
			local out1, out2, out3, out4, out5 =
				event.get_segment_collision_13(0, var19, var20, var21, var3 + var37, var4 + var38, var5 + var39, 0)
			var31 = out1 or var31
			var32 = out2 or var32
			var33 = out3 or var33
			var42 = out4 or var42
			var44 = out5 or var44
		end
		if var42 >= 0 and (var44 == 1 or var44 == 7) then
			event.create_effect("足水パシャ")
			event.set_effect_first_vector(var31, var32, var33)
			if var43 <= 0 then
				event.play_sound_effect(var2, 11)
				var43 = 10
			end
			if var13 == 0.0 then
				var13 = 1.0
				var23 = vm.f32(var23 * vm.f32(0.4))
				var24 = vm.f32(var24 * vm.f32(0.4))
				var25 = vm.f32(var25 * vm.f32(0.4))
				var16 = 0.0
				var18 = 0.0
				event.delete_sword_afterimage()
				print("----------------SE OFF-------------------\n")
			else
				var13 = 0.0
				print("----------------SE ON-------------------\n")
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				event.get_segment_collision_15(12, var19, var20, var21, var3 + var37, var4 + var38, var5 + var39, 1)
			var31 = out1 or var31
			var32 = out2 or var32
			var33 = out3 or var33
			var34 = out4 or var34
			var35 = out5 or var35
			var36 = out6 or var36
			var42 = out7 or var42
		end
		if var42 < 0 then
			if var4 >= 380.0 and var24 > 0.0 then
				do
					local out1, out2, out3 = event.copy_vector(var3, var4, var5)
					var31 = out1 or var31
					var32 = out2 or var32
					var33 = out3 or var33
				end
				do
					local out1, out2, out3 = event.copy_vector(var23, -var24, var25)
					var34 = out1 or var34
					var35 = out2 or var35
					var36 = out3 or var36
				end
				do
					local out1, out2, out3 = event.normalize_vector(var34, var35, var36)
					var34 = out1 or var34
					var35 = out2 or var35
					var36 = out3 or var36
				end
				var42 = 1
			end
		end
		while var42 >= 0 do
			var17 = 0.0
			if var26 > 8.0 then
				helper_79d90c82()
			end
			if var13 ~= 1.0 and var43 <= 0 then
				event.play_sound_effect(var2, 6)
				var43 = 10
			end
			do
				local out1, out2, out3 = event.copy_vector(-var23, -var24, -var25)
				var23 = out1 or var23
				var24 = out2 or var24
				var25 = out3 or var25
			end
			do
				local out1, out2, out3 = event.normalize_vector(var23, var24, var25)
				var23 = out1 or var23
				var24 = out2 or var24
				var25 = out3 or var25
			end
			do
				local out1, out2, out3 = event.scale_vector(var23, var24, var25, 3.0)
				var23 = out1 or var23
				var24 = out2 or var24
				var25 = out3 or var25
			end
			do
				local out1, out2, out3 = event.add_vectors(var31, var32, var33, var23, var24, var25)
				var31 = out1 or var31
				var32 = out2 or var32
				var33 = out3 or var33
			end
			do
				local out1, out2, out3 = event.subtract_vectors(var19, var20, var21, var31, var32, var33)
				var19 = out1 or var19
				var20 = out2 or var20
				var21 = out3 or var21
			end
			var41 = event.get_vector_length(var19, var20, var21) or var41
			var41 = vm.f32(var40 - var41)
			if var41 <= 0.0 then
				break
			else
				var40 = var41
				do
					local out1, out2, out3 = event.copy_vector(-var23, -var24, -var25)
					var23 = out1 or var23
					var24 = out2 or var24
					var25 = out3 or var25
				end
				if var24 < 0.0 and var35 > 0.0 then
					var23 = vm.f32(var16 * 2.0)
					var24 = 0.0
					var25 = vm.f32(var18 * 2.0)
					var16 = vm.f32(var16 * vm.f32(0.2))
					var18 = vm.f32(var18 * vm.f32(0.2))
				else
					if
						var23 < 0.0 and var34 > 0.0
						or var23 > 0.0 and var34 < 0.0
						or var25 < 0.0 and var36 > 0.0
						or var25 > 0.0 and var36 < 0.0
					then
						var16 = 0.0
						var18 = 0.0
					end
					var23 = 0.0
					var24 = 0.0
					var25 = 0.0
				end
				if var13 == 0.0 then
					var23 = vm.f32(vm.f32(vm.f32(var34 * var26) * vm.f32(0.9)) + var23)
					var24 = vm.f32(vm.f32(vm.f32(var35 * var26) * vm.f32(0.58)) + var24)
					var25 = vm.f32(vm.f32(vm.f32(var36 * var26) * vm.f32(0.9)) + var25)
				else
					print("MIZU______1--------------------------------------------------------------------\n")
					var23 = vm.f32(vm.f32(vm.f32(var34 * var26) * vm.f32(0.8)) + var23)
					var24 = vm.f32(vm.f32(vm.f32(var35 * var26) * vm.f32(0.4)) + var24)
					var25 = vm.f32(vm.f32(vm.f32(var36 * var26) * vm.f32(0.8)) + var25)
				end
				do
					local out1, out2, out3 = event.copy_vector(var31, var32, var33)
					var19 = out1 or var19
					var20 = out2 or var20
					var21 = out3 or var21
				end
				do
					local out1, out2, out3 = event.copy_vector(var23, var24, var25)
					var37 = out1 or var37
					var38 = out2 or var38
					var39 = out3 or var39
				end
				do
					local out1, out2, out3 = event.normalize_vector(var37, var38, var39)
					var37 = out1 or var37
					var38 = out2 or var38
					var39 = out3 or var39
				end
				do
					local out1, out2, out3 = event.scale_vector(var37, var38, var39, 3.0)
					var37 = out1 or var37
					var38 = out2 or var38
					var39 = out3 or var39
				end
				do
					local out1, out2, out3 = event.scale_vector(var34, var35, var36, var41)
					var34 = out1 or var34
					var35 = out2 or var35
					var36 = out3 or var36
				end
				do
					local out1, out2, out3 = event.copy_vector(var31, var32, var33)
					var3 = out1 or var3
					var4 = out2 or var4
					var5 = out3 or var5
				end
				do
					local out1, out2, out3 = event.add_vectors(var3, var4, var5, var34, var35, var36)
					var3 = out1 or var3
					var4 = out2 or var4
					var5 = out3 or var5
				end
				do
					local out1, out2, out3, out4, out5, out6, out7, out8 = event.get_segment_collision_16(
						12,
						var19,
						var20,
						var21,
						var3 + var37,
						var4 + var38,
						var5 + var39,
						1
					)
					var31 = out1 or var31
					var32 = out2 or var32
					var33 = out3 or var33
					var34 = out4 or var34
					var35 = out5 or var35
					var36 = out6 or var36
					var42 = out7 or var42
					var44 = out8 or var44
				end
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7, out8 =
				event.get_segment_collision_16(12, var3, var4, var5, var3, var4 - 3.0, var5, 1)
			var31 = out1 or var31
			var32 = out2 or var32
			var33 = out3 or var33
			var34 = out4 or var34
			var35 = out5 or var35
			var36 = out6 or var36
			var42 = out7 or var42
			var44 = out8 or var44
		end
		if var42 >= 0 then
			var17 = 0.0
			var4 = vm.f32(var32 + 3.0)
			var41 = event.get_vector_length(var23, 0.0, var25) or var41
			if var41 < vm.f32(2.6) or var24 >= -1.0 and var24 <= 0.0 then
				var24 = 0.0
				level = 1
			else
				if var13 == 0.0 then
					var23 = vm.f32(var23 * vm.f32(0.9))
					var24 = -vm.f32(var24 * vm.f32(0.58))
					var25 = vm.f32(var25 * vm.f32(0.9))
					var23 = vm.f32(var23 + vm.f32(var16 * 2.0))
					var25 = vm.f32(var25 + vm.f32(var18 * 2.0))
					var16 = vm.f32(var16 * vm.f32(0.2))
					var18 = vm.f32(var18 * vm.f32(0.2))
				else
					print("MIZU______2--------------------------------------------------------------------\n")
					var23 = vm.f32(var23 * vm.f32(0.8))
					var24 = -vm.f32(var24 * vm.f32(0.4))
					var25 = vm.f32(var25 * vm.f32(0.8))
					var16 = 0.0
					var18 = 0.0
				end
				if var26 > 8.0 then
					helper_79d90c82()
				end
				if var13 ~= 1.0 and var43 <= 0 then
					event.play_sound_effect(var2, 5)
					var43 = 10
				end
			end
			var41 = event.get_vector_length(var16, 0.0, var18) or var41
			if var24 == 0.0 and var26 < vm.f32(1.6) and var41 < vm.f32(0.4) then
				if var44 == 6 then
					var30 = 1
					break
				end
				var44 = event.get_automap_attribute_status(var3, var4, var5) or var44
				if not (var44 == 1) then
					break
				end
				var30 = 1
				break
			end
		end
		if var4 < -500.0 then
			var30 = 1
			break
		elseif var47 >= 480 then
			var30 = 1
			break
		else
			var45 = event.get_sphida_pin_color() or var45
			var46 = event.get_sphida_ball_color() or var46
			x = vm.f32(pos_x - var3)
			y = vm.f32(pos_y - var4)
			z = vm.f32(pos_z - var5)
			var48 = event.get_vector_length(x, y, z) or var48
			if var46 ~= var45 then
				var52 = event.get_point_to_segment_distance(var19, var20, var21, var3, var4, var5, pos_x, pos_y, pos_z) or var52
				if var52 >= 0.0 and var52 <= 30.0 then
					var22 = 1
					break
				end
				if var48 ~= 0.0 then
					if var48 <= 120.0 then
						do
							local out1, out2, out3 = event.scale_vector(x, y, z, vm.fdiv(vm.f32(0.6), var48))
							x = out1 or x
							y = out2 or y
							z = out3 or z
						end
						do
							local out1, out2, out3 = event.add_vectors(var3, var4, var5, x, y, z)
							var3 = out1 or var3
							var4 = out2 or var4
							var5 = out3 or var5
						end
						do
							local out1, out2, out3 = event.add_vectors(var23, var24, var25, x, y, z)
							var23 = out1 or var23
							var24 = out2 or var24
							var25 = out3 or var25
						end
					end
				else
					var22 = 1
					break
				end
			elseif var48 ~= 0.0 then
				if var48 <= 60.0 then
					do
						local out1, out2, out3 = event.scale_vector(x, y, z, vm.fdiv(1.0, var48))
						x = out1 or x
						y = out2 or y
						z = out3 or z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(var3, var4, var5, x, y, z)
						var3 = out1 or var3
						var4 = out2 or var4
						var5 = out3 or var5
					end
					do
						local out1, out2, out3 = event.subtract_vectors(var23, var24, var25, x, y, z)
						var23 = out1 or var23
						var24 = out2 or var24
						var25 = out3 or var25
					end
				end
			end
			event.set_character_position(8, var3, var4, var5)
			event.set_character_position(9, var3, var4, var5)
			do
				local out1, out2, out3 = event.copy_vector(var3, var4, var5)
				var19 = out1 or var19
				var20 = out2 or var20
				var21 = out3 or var21
			end
			if var4 <= -50.0 then
				event.set_follow_camera_following(0)
				if var30 >= 30 then
					if var30 >= 50 then
						break
					end
				else
					event.set_camera_look_at(var3, var4, var5)
				end
				var30 = var30 + 1
			elseif var47 >= 20 then
				event.set_camera_control_range(20.0, 30.0, 60.0, 200.0)
				event.set_camera_speed(8.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_target(
					vm.f32(var3 + var23) + var23,
					vm.f32(var4 + var24) + var24,
					vm.f32(var5 + var25) + var25
				)
				do
					local out1, out2, out3 = event.get_camera_position()
					pos_x_2 = out1 or pos_x_2
					pos_y_2 = out2 or pos_y_2
					pos_z_2 = out3 or pos_z_2
				end
				yaw = event.get_direction_angle(
					vm.f32(var3 + var23) + var23,
					vm.f32(var4 + var24) + var24,
					vm.f32(var5 + var25) + var25,
					pos_x_2,
					pos_y_2,
					pos_z_2
				) or yaw
				event.set_camera_control_rotation(yaw)
				event.move_camera_control_with_pad(8)
				event.step_camera_control()
			end
			event.set_sphida_ball_position(var3, var4, var5)
			vm.wait(15)
			if var43 > 0 then
				var43 = var43 - 1
			end
			var47 = var47 + 1
		end
	end
	event.set_character_position(8, var3, var4, var5)
	event.set_character_position(9, var3, var4, var5)
	event.set_sphida_status_panel_visible(0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	if var30 == 0 then
		event.set_sphida_ball_position(var3, var4, var5)
		count = event.get_sphida_par() or count
		if var22 == 1 then
			event.set_character_active(0, 0)
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
			event.set_character_active(1, 12)
			event.set_character_position(12, pos_x, pos_y, pos_z)
			event.set_character_motion(12, "発動", 6)
			event.play_sound_effect(var2, 17)
			var47 = 0
			while var47 < 2 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pos_x, pos_y, pos_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				var47 = var47 + 1
				vm.wait(16)
			end
			event.set_character_active(0, 10)
			do
				local out1, out2, out3 = event.get_sphida_pin_position()
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			var47 = 0
			while var47 < 100 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pos_x, pos_y, pos_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				var47 = var47 + 1
				vm.wait(17)
			end
			event.set_character_active(0, 11)
			var45 = event.get_dungeon_stage_id() or var45
			var46 = event.get_dungeon_floor() or var46
			var42 = event.get_dungeon_floor_info(var45, var46, 4) or var42
			do
				local out1, out2 = event.get_sphida_prize(var42)
				var43 = out1 or var43
				var44 = out2 or var44
			end
			var42 = vm.i32(var42 + 1)
			event.set_dungeon_floor_info(var45, var46, 4, var42)
			if var0 == 0 then
				event.place_treasure_box(pos_x, pos_y - 30.0, pos_z, var12, var43)
			end
			wait_frames(54)
			wait_frames(30)
			event.delete_character(8)
			event.delete_character(9)
			event.delete_character(10)
			event.delete_character(11)
			event.set_sphida_playing(0)
			var2 = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or var2
			event.stop_music(0)
			event.play_sound_effect(var2, 0)
			event.set_character_active(1, 0)
			event.set_follow_camera_following(0)
			event.set_camera_control_enabled(0)
			event.clear_camera_sequence()
			event.set_camera_sequence_follow_object(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
			event.set_object_sequence_motion(0, "カップインポーズ", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "カップインポーズL", 4)
			event.reset_object_sequence_dynamic_animation(0)
			var43 = event.get_language() or var43
			if var43 == 0 then
				event.reset_event_sprite(0)
				event.set_event_sprite_type(0, 0)
				event.set_event_sprite_texture(0, "sphida_bar", tex_bank)
				event.set_event_sprite_texture_rect(0, 258, 0, 254, 54)
				event.set_event_sprite_position(0, 256, 208)
				event.set_event_sprite_size(0, 254, 54)
				event.set_event_sprite_color(0, 128, 128, 128, 0)
				event.set_event_sprite_scale(0, 5.0, 5.0)
				event.set_event_sprite_draw_pass(0, 1)
			else
				event.reset_event_sprite(0)
				event.set_event_sprite_type(0, 0)
				event.set_event_sprite_texture(0, "sphida_bar", tex_bank)
				event.set_event_sprite_texture_rect(0, 206, 0, 306, 54)
				event.set_event_sprite_position(0, 256, 208)
				event.set_event_sprite_size(0, 254, 54)
				event.set_event_sprite_color(0, 128, 128, 128, 0)
				event.set_event_sprite_scale(0, 5.0, 5.0)
				event.set_event_sprite_draw_pass(0, 1)
			end
			event.attach_object_handle_to_sprite(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.set_object_sequence_scale(1, 1.0, 1.0, 0.0, 60)
			event.set_object_sequence_color(1, 128, 128, 128, 128, 60)
			wait_objects(0)
			wait_frames(90)
			vm.wait(22)
			event.play_music(0)
			if var0 == 1 then
				count = vm.i32(count + 2)
				event.reset_event_sprite(0)
				event.set_event_sprite_type(0, 0)
				event.set_event_sprite_texture(0, "omake_sfida", tex_bank)
				event.set_event_sprite_position(0, 256, 192)
				if var43 == 3 then
					event.set_event_sprite_texture_rect(0, 162, 38, 100, 34)
					event.set_event_sprite_size(0, 100, 34)
				elseif var43 == 5 then
					event.set_event_sprite_texture_rect(0, 182, 38, 160, 34)
					event.set_event_sprite_size(0, 160, 34)
				else
					event.set_event_sprite_texture_rect(0, 182, 38, 80, 34)
					event.set_event_sprite_size(0, 80, 34)
				end
				event.set_event_sprite_color(0, 128, 128, 128, 128)
				event.set_event_sprite_draw_pass(0, 1)
				event.reset_event_sprite(1)
				event.set_event_sprite_type(1, 0)
				event.set_event_sprite_texture(1, "omake_sfida", tex_bank)
				event.set_event_sprite_texture_rect(1, 280, 96, 28, 32)
				event.set_event_sprite_position(1, 174, 224)
				event.set_event_sprite_size(1, 28, 32)
				event.set_event_sprite_color(1, 128, 128, 128, 128)
				event.set_event_sprite_draw_pass(1, 1)
				event.reset_event_sprite(2)
				event.set_event_sprite_type(2, 0)
				event.set_event_sprite_texture(2, "omake_sfida", tex_bank)
				event.set_event_sprite_texture_rect(2, 136, 0, 104, 38)
				event.set_event_sprite_position(2, 296, 224)
				event.set_event_sprite_size(2, 104, 38)
				event.set_event_sprite_color(2, 128, 128, 128, 128)
				event.set_event_sprite_draw_pass(2, 1)
				event.reset_event_sprite(3)
				event.set_event_sprite_type(3, 0)
				event.set_event_sprite_texture(3, "omake_sfida", tex_bank)
				event.set_event_sprite_texture_rect(3, vm.i32(vm.imod(count, 10) * 28), 96, 28, 32)
				event.set_event_sprite_position(3, 228, 224)
				event.set_event_sprite_size(3, 28, 32)
				event.set_event_sprite_color(3, 128, 128, 128, 128)
				event.set_event_sprite_draw_pass(3, 1)
				if vm.idiv(count, 10) > 0 then
					event.reset_event_sprite(4)
					event.set_event_sprite_type(4, 0)
					event.set_event_sprite_texture(4, "omake_sfida", tex_bank)
					event.set_event_sprite_texture_rect(4, vm.i32(vm.idiv(count, 10) * 28), 96, 28, 32)
					event.set_event_sprite_position(4, 204, 224)
					event.set_event_sprite_size(4, 28, 32)
					event.set_event_sprite_color(4, 128, 128, 128, 128)
					event.set_event_sprite_draw_pass(4, 1)
				end
				while true do
					if helper_581cb30c(0) ~= 0 then
						break
					else
						vm.wait(23)
					end
				end
				var0 = event.get_sphida_saved_hole() or var0
				if var0 == 8 then
					event.set_sphida_hole_score(-1, count)
					helper_c24a11db()
				end
				event.fade_out_screen(30)
				wait_frames(30)
				event.set_event_sprite_draw_pass(0, 0)
				event.set_event_sprite_draw_pass(1, 0)
				event.set_event_sprite_draw_pass(2, 0)
			end
			event.release_camera_sequence_follow_object()
			event.set_event_sprite_draw_pass(0, 0)
		elseif count >= 2 then
			event.set_message_window_mode(0, 5)
			event.set_message_selection_top_line(0, 0)
			var58 = helper_bac0e30d(0, 2002, 8, 256, 208, 2, 0)
			vm.wait(27)
			if var58 == 0 then
				do
					local out1, out2, out3, out4 = event.get_nearest_map_parts_function_point_position(var3, var4, var5, 100.0, "point")
					var42 = out1 or var42
					var9 = out2 or var9
					var10 = out3 or var10
					var11 = out4 or var11
				end
				if var42 == 0 then
					do
						local out1, out2, out3 = event.get_nearest_map_parts_position(var3, var4, var5, 100.0)
						var9 = out1 or var9
						var10 = out2 or var10
						var11 = out3 or var11
					end
				end
				do
					local out1, out2, out3 = event.get_sphida_pin_position()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				var26 = event.get_distance_between(var9, var10, var11, pos_x, pos_y, pos_z) or var26
				if var26 < 40.0 then
					var12 = event.get_random_number(6.2831855) or var12
					var12 = vm.f32(var12 - vm.f32(3.1415927))
					var9 = vm.f32(var9 + vm.f32(vm.sin(var12) * 50.0))
					var11 = vm.f32(var11 + vm.f32(vm.cos(var12) * 50.0))
				else
					do
						local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(var9, var10, var11)
						var31 = out1 or var31
						var32 = out2 or var32
						var33 = out3 or var33
						var42 = out4 or var42
					end
					var47 = 0
					while var42 >= 0 do
						do
							local out1, out2, out3 = event.copy_vector(var9, var10, var11)
							var19 = out1 or var19
							var20 = out2 or var20
							var21 = out3 or var21
						end
						do
							local out1, out2, out3 = event.subtract_vectors(var19, var20, var21, var31, var32, var33)
							var19 = out1 or var19
							var20 = out2 or var20
							var21 = out3 or var21
						end
						var19 = vm.f32(var19 + 1.0)
						var21 = vm.f32(var21 + 1.0)
						do
							local out1, out2, out3 = event.normalize_vector(var19, var20, var21)
							var19 = out1 or var19
							var20 = out2 or var20
							var21 = out3 or var21
						end
						do
							local out1, out2, out3 = event.scale_vector(var19, var20, var21, 30.1)
							var19 = out1 or var19
							var20 = out2 or var20
							var21 = out3 or var21
						end
						do
							local out1, out2, out3 = event.copy_vector(var31, var32, var33)
							var9 = out1 or var9
							var10 = out2 or var10
							var11 = out3 or var11
						end
						do
							local out1, out2, out3 = event.add_vectors(var9, var10, var11, var19, var20, var21)
							var9 = out1 or var9
							var10 = out2 or var10
							var11 = out3 or var11
						end
						do
							local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(var9, var10, var11)
							var31 = out1 or var31
							var32 = out2 or var32
							var33 = out3 or var33
							var42 = out4 or var42
						end
						var47 = var47 + 1
						if var47 > 6 then
							break
						end
					end
				end
				var7 = event.get_direction_angle(var9, var10, var11, var3, var4, var5) or var7
				event.set_character_position(0, var9, var10, var11)
				event.set_character_rotation(0, 0.0, var7, 0.0)
				event.set_camera_look_at(var9, var10 + 30.0, var11)
				var7 = vm.f32(var7 - vm.f32(3.1415927))
				var7 = event.wrap_angle(var7) or var7
				var9 = vm.f32(vm.f32(vm.sin(var7) * 100.0) + var9)
				var10 = vm.f32(var10 + 30.0)
				var11 = vm.f32(vm.f32(vm.cos(var7) * 100.0) + var11)
				event.set_camera_position(var9, var10, var11)
				event.reset_follow_camera(0)
			end
		end
	else
		event.play_sound_effect(var2, 18)
		event.set_follow_camera_following(0)
		event.set_camera_control_enabled(0)
		event.clear_camera_sequence()
		event.set_camera_sequence_follow_object(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
		event.set_object_sequence_motion(0, "だめだめ", 6)
		event.set_object_sequence_normal_drive(0)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "sphida_bar", tex_bank)
		event.set_event_sprite_texture_rect(0, 334, 54, 178, 34)
		event.set_event_sprite_position(0, 256, -25)
		event.set_event_sprite_size(0, 160, 50)
		event.set_event_sprite_color(0, 128, 128, 128, 128)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(1, 0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.jump_object_sequence(1, 256.0, 208.0, 0.0, 1.2, 16)
		event.jump_object_sequence(1, 256.0, 208.0, 0.0, 2.0, 12)
		event.jump_object_sequence(1, 256.0, 208.0, 0.0, 1.5, 8)
		wait_objects(0)
		wait_frames(20)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_sphida_ball_position(var9, var10, var11)
		event.set_character_position(8, var9, var10, var11)
		event.set_character_position(9, var9, var10, var11)
		event.release_camera_sequence_follow_object()
	end
	if var22 == 1 then
		helper_f90045b0(-1)
	else
		helper_f90045b0(var2)
	end
	helper_6a55557d(var22)
end

--- The Sphida event run when the menu button is pressed near the ball.
function script.sphida_near_ball()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	event.initialize_event()
	helper_ce85b54c()
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	var0 = helper_bac0e30d(0, 2004, 8, 0, 0, 2, 1)
	if var0 == 0 then
		do
			local out1, out2, out3 = event.get_character_position(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.set_sphida_ball_position(var1, var2 + 3.0, var3)
		event.set_character_position(8, var1, var2 + 3.0, var3)
		event.set_character_position(9, var1, var2 + 3.0, var3)
		helper_f90045b0(-1)
		event.start_crossfade(15)
	end
	vm.wait(2)
	event.finish_event()
end

--- The Sphida event run when the menu button is pressed near the ball with fewer than two shots of par left.
function script.sphida_near_ball_last()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	event.initialize_event()
	helper_ce85b54c()
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "C'est la derni[UNI00e8]re fois que tu\npeux amener la sph[UNI00e8]re [UNI00e0] toi.")
	helper_75684dd8(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	event.open_message_window_2(0, "Amener la sph[UNI00e8]re jusqu'[UNI00e0] toi ?")
	var0 = helper_bac0e30d(0, -1, 8, 0, 0, 2, 1)
	if var0 == 0 then
		do
			local out1, out2, out3 = event.get_character_position(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.set_sphida_ball_position(var1, var2 + 3.0, var3)
		event.set_character_position(8, var1, var2 + 3.0, var3)
		event.set_character_position(9, var1, var2 + 3.0, var3)
		event.set_sphida_last_challenge(1)
		event.start_crossfade(15)
	end
	vm.wait(3)
	event.finish_event()
end

--- The Sphida event run when the menu button is pressed away from the ball on a bonus course.
function script.sphida_omake_away()
	local var0: any = 0
	local get_now_horl: s32 = 0
	event.initialize_event()
	helper_ce85b54c()
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	get_now_horl = event.get_sphida_saved_hole() or get_now_horl
	if get_now_horl == 8 then
		event.open_message_window_2(0, "C'est le dernier trou. Abandonner ?")
		var0 = helper_bac0e30d(0, -1, 8, 0, 0, 2, 1)
		if var0 == 0 then
			helper_c24a11db()
			event.fade_out_screen(30)
			wait_frames(30)
			helper_7b560508()
			helper_c44453a9()
			return
		end
	else
		event.open_message_window_2(0, "Abandonner ce trou et passer au\nparcours suivant ?")
		var0 = helper_bac0e30d(0, -1, 8, 0, 0, 2, 1)
		if var0 == 0 then
			event.fade_out_screen(30)
			wait_frames(30)
			helper_7982ab52()
		end
	end
	vm.wait(7)
	event.finish_event()
end

--- Event 6000, which map data, a script or the engine runs by number.
function script.event_6000()
	event.initialize_event()
	helper_e91d3484()
	event.fade_out_screen(0)
	vm.wait(1)
	vm.wait(2)
	event.skip_next_music_load()
	event.set_dungeon_floor(0)
	event.load_dungeon_map("d02f01", "mstage1", 64)
	event.add_inventory_item(305, 1)
	event.add_inventory_item(306, 1)
	helper_c3f198dd(2, 1)
	event.set_sphida_saved_hole(1)
	event.set_character_position(0, 640.0, 0.0, 1920.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_camera_look_at(640.0, 30.0, 1920.0)
	event.set_camera_position(640.0, 40.0, 2020.0)
	event.fade_in_screen(30)
	wait_frames(30)
	event.open_event_menu(28)
	vm.wait(4)
	event.reset_follow_camera(0)
	event.finish_event()
end

return script
