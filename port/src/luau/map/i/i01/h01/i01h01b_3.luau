--!strict
--- Cutscenes in the Palm Brinks shop house where Starbre gives the camera, pays for the backpack and explains the Ride Pod.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local cutscene = require("@lib/event/cutscene")
local inventory = require("@lib/event/inventory")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local palm_brinks_house = require("@lib/event/german/palm_brinks_house")
local palm_brinks_shop_house = require("@lib/event/palm_brinks_shop_house")
local wait = require("@lib/event/wait")

--- Shows the player receiving the camera with its tutorial messages.
local function play_camera_receive_scene(se_id: s32, se_id_2: s32)
	event.set_camera_sequence_position(38.3, 34.99, -138.13)
	event.set_camera_sequence_look_at(16.02, 28.99, -153.84)
	event.set_character_active(1, 0)
	event.set_object_sequence_motion(0, "カメラゲット", 4)
	event.set_object_handle_visible(1, 0)
	event.set_object_sequence_rotation(1, 0.0, -2.23, 0.0)
	event.detach_character_from_frame(33)
	event.attach_character_to_frame(0, "ef00", 33)
	event.pause_music()
	event.play_sound_effect(se_id_2, 0)
	event.play_sound_effect(se_id, 7)
	event.set_object_sequence_position(2, -10.42, 26.48, -171.78)
	event.set_object_sequence_rotation(2, 0.0, 1.02, 0.0)
	event.set_object_sequence_motion(2, "発動", 6)
	event.set_object_handle_visible(2, 1)
	event.set_message_window_mode(0, 8)
	event.open_message_window_2(
		0,
		"[(!)]Du hast die Kamera.\n   R[UNI00fc]ste sie im Ggst.-Men[UNI00fc] aus.\n   Benutze sie mit (#)."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]In Verliesen kannst du die\n   Kamera nur als aktiven Aus-\n   r[UNI00fc]stungsgegenstand verwenden."
	)
	message.show(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 7)
	inventory.announce_received(355, 1)
	event.play_music(0)
end

--- Plays the whole camera gift cutscene and restores the camera afterwards.
local function play_camera_gift_scene()
	local sound_bank: s32 = 0
	local item_sound_bank: s32 = 0
	local projection: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local image_block: s32 = 0
	vm.section(function()
		event.set_save_flag(105, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(1222)
		sound_bank = event.load_sound_effect_file_2(1222) or sound_bank
		item_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or item_sound_bank
		event.load_character(4, "event/e100/e105/e105_steve.gltf", "info", 25)
		event.set_character_active(1, 25)
		event.set_character_position(25, 62.85, 11.43, -176.07)
		event.set_character_rotation(25, 0.0, -0.72, 0.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3 = event.get_camera_position()
			camera_x = out1 or camera_x
			camera_y = out2 or camera_y
			camera_z = out3 or camera_z
		end
		do
			local out1, out2, out3 = event.get_camera_look_at()
			look_at_x = out1 or look_at_x
			look_at_y = out2 or look_at_y
			look_at_z = out3 or look_at_z
		end
		projection = event.get_event_projection() or projection
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-13.56, 50.69, -99.84)
		event.set_camera_sequence_look_at(47.32, 59.3, -184.47)
		event.load_character_motion_pack(5, "event/e100/e105/e105_mints.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "event/e100/e105/e105_starbre.gltf", "info", 32)
		event.set_character_active(0, 24)
		event.set_character_active(1, 32)
		event.attach_object_handle_to_character(1, 32)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_item_model(5, 369, "info", 33)
		event.set_character_active(0, 33)
		event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 34)
		event.set_character_active(1, 34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_handle_visible(2, 0)
		image_block = event.load_event_image_4(5, "textures/event/e100/e105/e105a_2d.json", 0) or image_block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e105a_2d01", image_block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(3, 0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "e105a_2d02", image_block)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
		event.set_event_sprite_size(1, 512, 448)
		event.set_event_sprite_position(1, 256, 224)
		event.set_event_sprite_draw_pass(1, 0)
		event.attach_object_handle_to_sprite(4, 1)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_time_of_day(7)
		event.load_message_file(0, 5, "event/e100/e105/e105a_1.txt")
		event.stop_music(0)
		wait.frames(4)
		event.load_music(193)
		event.play_music(0)
		event.set_object_handle_footstep_sound(0, 3)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.enable_drama_skip()
		palm_brinks_shop_house.play_walk_in_scene(sound_bank)
		palm_brinks_shop_house.play_atlamillia_touch_scene(sound_bank)
		palm_brinks_shop_house.play_standing_conversation_scene(sound_bank)
		palm_brinks_shop_house.play_agreement_scene(sound_bank)
		palm_brinks_shop_house.play_camera_reveal_scene(sound_bank)
		play_camera_receive_scene(sound_bank, item_sound_bank)
		palm_brinks_shop_house.play_camera_followup_scene(sound_bank)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_event_image(0)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.set_save_flag(56, 0)
	event.stop_music(0)
	wait.frames(4)
	event.load_music(46)
	event.play_music(0)
	event.set_camera_position(camera_x, camera_y, camera_z)
	event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
	event.set_event_projection(projection)
	event.set_object_handle_footstep_sound(0, 0)
	event.fade_in_screen(30)
end

--- Plays the scene in which the player is paid 400 Gilda.
local function play_gilda_payment_scene(se_id: s32)
	event.set_camera_sequence_position(16.09, 22.59, -109.83)
	event.set_camera_sequence_look_at(50.2, 23.69, -140.94)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, 55.27, -1.12, -130.46)
	event.set_object_sequence_rotation(0, 0.0, -2.24, 0.0)
	event.set_object_sequence_motion(0, "スターブル見L", 4, -1.0, 1)
	event.set_object_sequence_motion(1, "立ち", 4)
	wait.frames(15)
	event.play_sound_effect(se_id, 3)
	event.set_object_sequence_motion(1, "お金をやる", 6)
	event.queue_object_sequence_next_motion(1, "お金をやるL")
	wait.frames(14)
	event.set_mouth_texture_animations(1, "わらい口パク")
	message.show_voiced(1050400)
	event.reset_mouth_texture_animations()
	event.play_sound_effect(se_id, 4)
	event.set_object_sequence_motion(0, "お金をもらう", 6)
	event.reset_object_sequence_dynamic_animation(0)
	event.queue_object_sequence_next_motion(0, "お金をもらうL")
	wait.frames(60)
	event.set_message_window_mode(0, 8)
	event.open_message_window_2(0, "Du hast 400 Gilda bekommen!")
	message.show(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 7)
	event.set_object_sequence_motion(1, "お金をやる戻り", 6)
	event.queue_object_sequence_next_motion(1, "立ち")
	object.wait_until_done(1)
end

--- Plays the scene that explains the Ride Pod with a tutorial message.
local function play_ride_pod_tutorial_scene(se_id: s32, se_id_2: s32)
	local saved_window_mode: s32 = 0
	event.mark_camera_sequence_fade_track()
	event.fade_out_camera_sequence(30, 0.0, 0.0, 0.0)
	camera.wait_until_done()
	event.set_camera_sequence_position(133.98, 56.46, -175.98)
	event.set_camera_sequence_look_at(64.38, 33.46, -162.4)
	event.set_object_sequence_position(0, 50.4, -0.02, -124.87)
	event.set_object_sequence_rotation(0, 0.0, -1.94, 0.0)
	event.set_object_sequence_motion(0, "右を見るL")
	event.set_object_sequence_position(1, 26.91, -0.02, -138.97)
	event.set_object_sequence_rotation(1, 0.0, 0.93, 0.0)
	event.set_object_sequence_motion(1, "左を見るL")
	event.set_character_position(25, 62.71, 11.43, -173.15)
	event.set_character_rotation(25, 0.0, -1.52, 0.0)
	event.set_character_active(1, 36)
	event.set_object_sequence_position(4, 74.43, 34.16, -174.29)
	event.set_object_sequence_rotation(4, 0.0, -1.64, 0.0)
	event.set_object_sequence_position(5, 75.19, 35.28, -173.96)
	event.set_object_sequence_rotation(5, 0.0, -1.52, 0.0)
	event.set_object_sequence_motion(5, "発動", 6)
	event.set_object_handle_visible(5, 1)
	wait.frames(30)
	event.play_sound_effect(se_id_2, 0)
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	camera.wait_until_done()
	wait.frames(15)
	event.play_sound_effect(se_id, 8)
	event.set_mouth_texture_animations(1, "わらい口パク")
	message.show_voiced(1050520)
	event.reset_mouth_texture_animations()
	saved_window_mode = event.get_message_window_frame(0) or saved_window_mode
	event.set_message_window_mode(0, 8)
	event.open_message_window_2(
		0,
		'[(!)] Du benutzt den Ridepod, indem du\n   ihn im Men[UNI00fc] unter "Charakter" w[UNI00e4]hlst.\n   Oder dr[UNI00fc]cke einfach (R3).'
	)
	message.show(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, saved_window_mode)
end

--- Plays the shop house scene selected by number and restores the camera afterwards.
local function play_shop_house_scene(scene_number: s32)
	local sound_bank: s32 = 0
	local item_sound_bank: s32 = 0
	local steve_x: f32 = 0
	local steve_y: f32 = 0
	local steve_z: f32 = 0
	local steve_rotation_x: f32 = 0
	local steve_rotation_y: f32 = 0
	local steve_rotation_z: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	vm.section(function()
		vm.entry(1)
		do
			local out1, out2, out3 = event.get_character_position(25)
			steve_x = out1 or steve_x
			steve_y = out2 or steve_y
			steve_z = out3 or steve_z
		end
		do
			local out1, out2, out3 = event.get_character_rotation(25)
			steve_rotation_x = out1 or steve_rotation_x
			steve_rotation_y = out2 or steve_rotation_y
			steve_rotation_z = out3 or steve_rotation_z
		end
		event.set_save_flag(105, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		sound_bank = event.load_sound_effect_file_2(1228) or sound_bank
		item_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or item_sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3 = event.get_camera_position()
			camera_x = out1 or camera_x
			camera_y = out2 or camera_y
			camera_z = out3 or camera_z
		end
		do
			local out1, out2, out3 = event.get_camera_look_at()
			look_at_x = out1 or look_at_x
			look_at_y = out2 or look_at_y
			look_at_z = out3 or look_at_z
		end
		event.clear_camera_sequence()
		event.load_character(5, "event/e100/e105/e105_starbre.gltf", "info", 33)
		event.set_character_active(1, 33)
		event.attach_object_handle_to_character(1, 33)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_character_motion_pack(5, "event/e100/e105/e105_mints.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_handle_sound_bank(0, sound_bank)
		event.load_character(5, "event/e100/e105/e105_back.gltf", "info", 35)
		event.set_character_active(1, 35)
		event.load_character(5, "event/e100/e105/back01.gltf", "info", 36)
		event.set_character_active(1, 36)
		event.attach_object_handle_to_character(4, 36)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 37)
		event.set_character_active(1, 37)
		event.attach_object_handle_to_character(5, 37)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_handle_visible(5, 0)
		event.load_message_file(0, 5, "event/e100/e105/e105c_1.txt")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "わらい顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.enable_drama_skip()
		if scene_number == 1 then
			event.reset_object_sequence_dynamic_animation(0)
			palm_brinks_shop_house.play_post_flashback_chat_scene(sound_bank)
		end
		if scene_number == 2 then
			event.reset_object_sequence_dynamic_animation(0)
			palm_brinks_shop_house.play_cheer_scene(sound_bank)
			event.reset_object_sequence_dynamic_animation(0)
			palm_brinks_shop_house.play_illustrated_chat_scene(sound_bank)
			event.reset_object_sequence_dynamic_animation(0)
			play_gilda_payment_scene(sound_bank)
		end
		if scene_number == 3 then
			event.reset_object_sequence_dynamic_animation(0)
			cutscene.noop()
		end
		if scene_number == 4 then
			event.reset_object_sequence_dynamic_animation(0)
			palm_brinks_shop_house.play_celebration_scene(sound_bank)
		end
		if scene_number == 5 then
			event.stop_music(0)
			event.reset_object_sequence_dynamic_animation(0)
			palm_brinks_shop_house.play_backpack_delivery_scene(sound_bank)
			event.reset_object_sequence_dynamic_animation(0)
			play_ride_pod_tutorial_scene(sound_bank, item_sound_bank)
			event.reset_object_sequence_dynamic_animation(0)
			palm_brinks_shop_house.play_closing_remark_scene(sound_bank)
		end
	end)
	vm.entry(10)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	wait.frames(30)
	if scene_number == 5 then
		event.play_music(0)
	end
	event.set_character_position(25, steve_x, steve_y, steve_z)
	event.set_character_rotation(25, steve_rotation_x, steve_rotation_y, steve_rotation_z)
	event.set_camera_position(camera_x, camera_y, camera_z)
	event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(37)
	event.reset_follow_camera(1, 0.0, 20.0)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
	event.set_character_active(1, 0)
	vm.wait(12)
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

--- Event 200, which map data, a script or the engine runs by number.
script[200] = palm_brinks_shop_house.exit_to_town

--- Plays the camera gift scene, gives the camera items and returns to the house script.
function script.start_camera_gift_event()
	palm_brinks_shop_house.hide_house_owner()
	event.set_save_flag(18, 1)
	event.set_save_flag(21, 1)
	play_camera_gift_scene()
	palm_brinks_shop_house.resume_exploration()
	event.set_character_position(0, 16.25, -0.02, -166.37)
	event.set_character_rotation(0, 0.0, 1.16, 0.0)
	event.set_character_motion(0, "立ち")
	event.set_villager_ai_enabled(0, 24)
	event.set_character_position(24, 38.77, -0.02, -147.68)
	event.set_character_rotation(24, 0.0, -2.04, 0.0)
	event.set_character_motion(24, "立ち")
	event.set_villager_ai_enabled(1, 24)
	event.set_save_data_value(0, 3)
	event.add_inventory_item(369, 1)
	event.add_inventory_item(355, 1)
	inventory.resolve_overflow_alt(1)
	vm.wait(3)
	event.load_event_script("i01h01/i01h01_1.stb", -1)
end
script[500] = script.start_camera_gift_event

--- Plays the flashback scene and returns to the house script.
function script.start_flashback_event()
	local resume_step: number = 0
	return vm.guard(function()
		event.fade_out_screen(10, 0.0, 0.0, 0.0)
		resume_step = 1
		wait.frames(10)
		palm_brinks_shop_house.hide_house_owner()
		resume_step = 2
		palm_brinks_shop_house.play_flashback_event()
		palm_brinks_shop_house.resume_exploration()
		event.set_character_position(0, 16.25, -0.02, -166.37)
		event.set_character_rotation(0, 0.0, 1.16, 0.0)
		event.set_character_motion(0, "立ち")
		event.set_villager_ai_enabled(0, 24)
		event.set_character_position(24, 38.77, -0.02, -147.68)
		event.set_character_rotation(24, 0.0, -2.04, 0.0)
		event.set_character_motion(24, "立ち")
		resume_step = 3
		vm.wait(3)
		event.set_villager_ai_enabled(1, 24)
		resume_step = 4
		vm.wait(4)
		event.load_event_script("i01h01/i01h01_1.stb", -1)
		return
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step <= 1 then
				cutscene.noop()
				resume_step = 2
				palm_brinks_shop_house.play_flashback_event()
				return vm.continue_with(function()
					palm_brinks_shop_house.resume_exploration()
					event.set_character_position(0, 16.25, -0.02, -166.37)
					event.set_character_rotation(0, 0.0, 1.16, 0.0)
					event.set_character_motion(0, "立ち")
					event.set_villager_ai_enabled(0, 24)
					event.set_character_position(24, 38.77, -0.02, -147.68)
					event.set_character_rotation(24, 0.0, -2.04, 0.0)
					event.set_character_motion(24, "立ち")
					resume_step = 3
					vm.wait(3)
					event.set_villager_ai_enabled(1, 24)
					resume_step = 4
					vm.wait(4)
					event.load_event_script("i01h01/i01h01_1.stb", -1)
					return
				end)
			end
			if resume_step <= 2 then
				cutscene.noop()
			end
			return 0
		end
		return nil
	end)
end
script[510] = script.start_flashback_event

--- Plays the backpack request scene that matches the quest progress and returns to the house script.
function script.handle_backpack_request()
	local backpack_status: s32 = 0
	local flag: s32 = 0
	local item_224_count: s32 = 0
	local item_245_count: s32 = 0
	local item_227_count: s32 = 0
	local backpack_invention_state: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.set_character_motion(0, "立ち")
		event.set_save_flag(21, 0)
		event.fade_out_screen(30, 0.0, 0.0, 0.0)
		resume_step = 1
		wait.frames(30)
		palm_brinks_shop_house.hide_house_owner()
		flag = event.get_save_flag(13) or flag
		if flag == 1 then
			resume_step = 2
			play_shop_house_scene(5)
			palm_brinks_shop_house.resume_exploration()
			event.set_character_position(0, 16.25, -0.02, -166.37)
			event.set_character_rotation(0, 0.0, 1.16, 0.0)
			event.set_character_motion(0, "立ち")
			event.set_villager_ai_enabled(0, 24)
			event.set_character_position(24, 38.77, -0.02, -147.68)
			event.set_character_rotation(24, 0.0, -2.04, 0.0)
			event.set_character_motion(24, "立ち")
			resume_step = 3
			vm.wait(3)
			event.set_villager_ai_enabled(1, 24)
			event.set_save_flag(20, 1)
			event.set_character_active(1, 26)
			event.attach_character_to_frame(25, "back", 26)
			event.remove_item(165, 1)
			resume_step = 4
			vm.wait(4)
			event.load_event_script("i01h01/i01h01_1.stb", -1)
			return
		else
			flag = event.get_save_flag(19) or flag
			if flag == 1 then
				item_224_count = event.get_item_count(224) or item_224_count
				item_245_count = event.get_item_count(245) or item_245_count
				item_227_count = event.get_item_count(227) or item_227_count
				if item_224_count >= 20 and item_245_count >= 1 and item_227_count >= 2 then
					backpack_status = event.get_item_count(165) or backpack_status
					print("backpack num =", backpack_status, "---------------\n")
					if backpack_status == 0 then
						resume_step = 5
						play_shop_house_scene(4)
						palm_brinks_shop_house.resume_exploration()
						event.set_character_position(0, 59.55, -1.12, -135.97)
						event.set_character_rotation(0, 0.0, -2.24, 0.0)
						event.set_character_motion(0, "立ち")
						event.set_villager_ai_enabled(0, 24)
						event.set_character_position(24, 38.77, -0.02, -147.68)
						event.set_character_rotation(24, 0.0, 0.72, 0.0)
						event.set_character_motion(24, "立ち")
						resume_step = 6
						vm.wait(6)
						event.set_villager_ai_enabled(1, 24)
						event.load_event_script("i01h01/i01h01_1.stb", -1)
						return
					end
				else
					event.fade_in_screen(0)
					event.set_villager_ai_enabled(0, 24)
					event.open_message_window_2(
						0,
						"Tr[UNI00f6]del nicht rum. Der Gegenst[UNI00e4]nde-\nladen ist direkt gegen[UNI00fc]ber.\nBeeil dich und geh dort hin."
					)
					resume_step = 7
					cutscene.talk(24, -1, 0, 0)
					event.set_villager_ai_enabled(1, 24)
					resume_step = 8
					vm.wait(8)
					event.load_event_script("i01h01/i01h01_1.stb", -1)
				end
			else
				backpack_status = event.has_invention_ideas(165) or backpack_status
				if backpack_status == 1 then
					backpack_invention_state = event.is_invention_created(165) or backpack_invention_state
					if backpack_invention_state ~= -1 then
						event.set_save_flag(19, 1)
						event.add_money(400)
						resume_step = 9
						play_shop_house_scene(2)
						palm_brinks_shop_house.resume_exploration()
						event.set_villager_ai_enabled(0, 24)
						event.set_character_position(24, 38.77, -0.02, -147.68)
						event.set_character_rotation(24, 0.0, 0.72, 0.0)
						event.set_character_motion(24, "立ち")
						resume_step = 10
						vm.wait(10)
						event.set_villager_ai_enabled(1, 24)
						event.load_event_script("i01h01/i01h01_1.stb", -1)
						return
					else
						resume_step = 11
						play_shop_house_scene(1)
						palm_brinks_shop_house.resume_exploration()
						event.set_character_position(0, 16.25, -0.02, -166.37)
						event.set_character_rotation(0, 0.0, 1.16, 0.0)
						event.set_character_motion(0, "立ち")
						event.set_villager_ai_enabled(0, 24)
						event.set_character_position(24, 38.77, -0.02, -147.68)
						event.set_character_rotation(24, 0.0, -2.04, 0.0)
						event.set_character_motion(24, "立ち")
						resume_step = 12
						vm.wait(12)
						event.set_villager_ai_enabled(1, 24)
						event.load_event_script("i01h01/i01h01_1.stb", -1)
						return
					end
				else
					resume_step = 13
					vm.wait(13)
					event.load_event_script("i01h01/i01h01c_1.stb", 500)
					return
				end
			end
		end
		event.fade_in_screen(15)
		event.open_message_window_2(0, "Max, du kannst nicht einfach\nblaumachen, verstanden?")
		resume_step = 14
		cutscene.talk(24, -1, 0, 0)
		resume_step = 15
		vm.wait(15)
		event.load_event_script("i01h01/i01h01_1.stb", -1)
		return
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step <= 1 then
				cutscene.noop()
				resume_step = 2
				play_shop_house_scene(5)
				return vm.continue_with(function()
					palm_brinks_shop_house.resume_exploration()
					event.set_character_position(0, 16.25, -0.02, -166.37)
					event.set_character_rotation(0, 0.0, 1.16, 0.0)
					event.set_character_motion(0, "立ち")
					event.set_villager_ai_enabled(0, 24)
					event.set_character_position(24, 38.77, -0.02, -147.68)
					event.set_character_rotation(24, 0.0, -2.04, 0.0)
					event.set_character_motion(24, "立ち")
					resume_step = 3
					vm.wait(3)
					event.set_villager_ai_enabled(1, 24)
					event.set_save_flag(20, 1)
					event.set_character_active(1, 26)
					event.attach_character_to_frame(25, "back", 26)
					event.remove_item(165, 1)
					resume_step = 4
					vm.wait(4)
					event.load_event_script("i01h01/i01h01_1.stb", -1)
					return
				end)
			end
			if resume_step <= 2 then
				cutscene.noop()
			end
			return 0
		end
		if resume_step <= 6 then
			if resume_step <= 5 then
				cutscene.noop()
			end
			return 0
		end
		if resume_step <= 10 then
			if resume_step <= 8 then
				resume_step = 9
				play_shop_house_scene(2)
				return vm.continue_with(function()
					palm_brinks_shop_house.resume_exploration()
					event.set_villager_ai_enabled(0, 24)
					event.set_character_position(24, 38.77, -0.02, -147.68)
					event.set_character_rotation(24, 0.0, 0.72, 0.0)
					event.set_character_motion(24, "立ち")
					resume_step = 10
					vm.wait(10)
					event.set_villager_ai_enabled(1, 24)
					event.load_event_script("i01h01/i01h01_1.stb", -1)
					return
				end)
			end
			if resume_step <= 9 then
				cutscene.noop()
			end
			return 0
		end
		if resume_step <= 12 then
			if resume_step <= 11 then
				cutscene.noop()
			end
			return 0
		end
		if resume_step <= 13 then
			return 0
		end
		if resume_step <= 15 then
			return 0
		end
		return nil
	end)
end
script[520] = script.handle_backpack_request

--- Plays the cheer and payment scene and returns to the house script.
function script.play_cheer_and_payment_scene()
	event.set_character_active(0, 24)
	play_shop_house_scene(2)
	vm.wait(2)
	event.load_event_script("i01h01/i01h01_1.stb", -1)
end
script[521] = script.play_cheer_and_payment_scene

--- Starts the dialogue with Starbre, the house owner.
function script.talk_to_starbre()
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		resume_step = 1
		vm.wait(1)
		resume_step = 2
		palm_brinks_house.talk_to_house_owner()
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				palm_brinks_shop_house.handle_talk_event_skippable()
			end
			return 0
		end
		return nil
	end)
end
script[1000] = script.talk_to_starbre

--- Replays the backpack request scene that matches the held items and invention state.
function script.replay_backpack_request()
	local backpack_invention_state: s32 = 0
	local backpack_count: s32 = 0
	local item_224_count: s32 = 0
	local item_245_count: s32 = 0
	local item_227_count: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.set_character_motion(0, "立ち")
		event.set_save_flag(21, 0)
		event.fade_out_screen(30)
		resume_step = 1
		wait.frames(30)
		palm_brinks_shop_house.hide_house_owner()
		backpack_count = event.get_item_count(165) or backpack_count
		if backpack_count >= 1 then
			event.remove_item(165, 1)
			resume_step = 2
			play_shop_house_scene(5)
			palm_brinks_shop_house.resume_exploration()
			event.set_character_position(0, 16.25, -0.02, -166.37)
			event.set_character_rotation(0, 0.0, 1.16, 0.0)
			event.set_character_motion(0, "立ち")
			event.set_villager_ai_enabled(0, 24)
			event.set_character_position(24, 38.77, -0.02, -147.68)
			event.set_character_rotation(24, 0.0, -2.04, 0.0)
			event.set_character_motion(24, "立ち")
			resume_step = 3
			vm.wait(3)
			event.set_villager_ai_enabled(1, 24)
			event.set_save_flag(20, 1)
			event.set_character_active(1, 26)
			event.attach_character_to_frame(25, "back", 26)
			resume_step = 4
			vm.wait(4)
			event.load_event_script("i01h01/i01h01_1.stb", -1)
			return
		end
		item_224_count = event.get_item_count(224) or item_224_count
		item_245_count = event.get_item_count(245) or item_245_count
		item_227_count = event.get_item_count(227) or item_227_count
		if item_224_count >= 20 and item_245_count >= 1 and item_227_count >= 2 then
			resume_step = 5
			play_shop_house_scene(4)
			palm_brinks_shop_house.resume_exploration()
			event.set_character_position(0, 59.55, -1.12, -135.97)
			event.set_character_rotation(0, 0.0, -2.24, 0.0)
			event.set_character_motion(0, "立ち")
			event.set_villager_ai_enabled(0, 24)
			event.set_character_position(24, 38.77, -0.02, -147.68)
			event.set_character_rotation(24, 0.0, 0.72, 0.0)
			event.set_character_motion(24, "立ち")
			resume_step = 6
			vm.wait(6)
			event.set_villager_ai_enabled(1, 24)
			resume_step = 7
			vm.wait(7)
			event.load_event_script("i01h01/i01h01_1.stb", -1)
			return
		end
		backpack_invention_state = event.is_invention_created(165) or backpack_invention_state
		if backpack_invention_state ~= -1 then
			resume_step = 8
			play_shop_house_scene(2)
			event.set_villager_ai_enabled(0, 24)
			event.set_character_position(24, 38.77, -0.02, -147.68)
			event.set_character_rotation(24, 0.0, 0.72, 0.0)
			event.set_character_motion(24, "立ち")
			resume_step = 9
			vm.wait(9)
			event.set_villager_ai_enabled(1, 24)
			resume_step = 10
			vm.wait(10)
			event.load_event_script("i01h01/i01h01_1.stb", -1)
			return
		end
		if backpack_invention_state == -1 then
			resume_step = 11
			play_shop_house_scene(1)
			palm_brinks_shop_house.resume_exploration()
			event.set_character_position(0, 16.25, -0.02, -166.37)
			event.set_character_rotation(0, 0.0, 1.16, 0.0)
			event.set_character_motion(0, "立ち")
			event.set_villager_ai_enabled(0, 24)
			event.set_character_position(24, 38.77, -0.02, -147.68)
			event.set_character_rotation(24, 0.0, -2.04, 0.0)
			event.set_character_motion(24, "立ち")
			resume_step = 12
			vm.wait(12)
			event.set_villager_ai_enabled(1, 24)
			resume_step = 13
			vm.wait(13)
			event.load_event_script("i01h01/i01h01_1.stb", -1)
			return
		end
		event.fade_in_screen(30)
		resume_step = 14
		vm.wait(14)
		event.load_event_script("i01h01/i01h01_1.stb", -1)
		return
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step <= 1 then
				cutscene.noop()
				resume_step = 2
				play_shop_house_scene(5)
				return vm.continue_with(function()
					palm_brinks_shop_house.resume_exploration()
					event.set_character_position(0, 16.25, -0.02, -166.37)
					event.set_character_rotation(0, 0.0, 1.16, 0.0)
					event.set_character_motion(0, "立ち")
					event.set_villager_ai_enabled(0, 24)
					event.set_character_position(24, 38.77, -0.02, -147.68)
					event.set_character_rotation(24, 0.0, -2.04, 0.0)
					event.set_character_motion(24, "立ち")
					resume_step = 3
					vm.wait(3)
					event.set_villager_ai_enabled(1, 24)
					event.set_save_flag(20, 1)
					event.set_character_active(1, 26)
					event.attach_character_to_frame(25, "back", 26)
					resume_step = 4
					vm.wait(4)
					event.load_event_script("i01h01/i01h01_1.stb", -1)
					return
				end)
			end
			if resume_step <= 2 then
				cutscene.noop()
			end
			return 0
		end
		if resume_step <= 7 then
			if resume_step <= 5 then
				cutscene.noop()
			end
			return 0
		end
		if resume_step <= 10 then
			return 0
		end
		if resume_step <= 13 then
			if resume_step <= 11 then
				cutscene.noop()
			end
			return 0
		end
		if resume_step <= 14 then
			return 0
		end
		return nil
	end)
end
script[11053] = script.replay_backpack_request

return script
