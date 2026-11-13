--!strict
--- Scene helpers for the events of the Palm Brinks shop house.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local palm_brinks_shop_house = {}

--- Drives lip sync and the timed sound effect of a voiced message until the player advances it.
function palm_brinks_shop_house.animate_voiced_message(window: s32, character_slot: s32, se_id: s32, sound_index: s32, sound_trigger_time: f32)
	local mouth_state: s32 = 0
	local motion_time: f32 = 0
	local voice_state: s32 = 0
	local previous_voice_state: s32 = 0
	local input_done: s32 = 0
	local frame_count: s32 = 0
	local previous_audible: s32 = 0
	local audible: s32 = 0
	event.trigger_mouth_texture_animation(1)
	event.trigger_mouth_motion(0)
	mouth_state = 0
	frame_count = 0
	previous_voice_state = event.get_voice_stream_state(1) or previous_voice_state
	audible = 0
	while true do
		motion_time = event.get_character_motion_wait(character_slot) or motion_time
		if motion_time < vm.f32(sound_trigger_time + vm.f32(0.01)) and motion_time > vm.f32(sound_trigger_time - vm.f32(0.01)) then
			event.play_sound_effect(se_id, sound_index)
		end
		previous_voice_state = voice_state
		voice_state = event.get_voice_stream_state(1) or voice_state
		if previous_voice_state ~= 0 and voice_state == 0 then
			event.trigger_mouth_motion(2)
			mouth_state = 2
		end
		previous_audible = audible
		audible = event.is_voice_stream_audible(1) or audible
		if previous_audible == 0 and audible == 1 then
			event.trigger_mouth_texture_animation(1)
		end
		if previous_audible == 1 and audible == 0 then
			event.trigger_mouth_texture_animation(0)
		end
		local input_result: s32
		input_result, mouth_state = message.poll_advance(window, mouth_state)
		input_done = input_result
		if input_done ~= 0 then
			frame_count = vm.i32(frame_count + 1)
			break
		else
			vm.wait(1)
			frame_count = vm.i32(frame_count + 1)
		end
	end
	if mouth_state == 0 then
		event.trigger_mouth_motion(2)
	end
	event.reset_mouth_motions()
	event.trigger_mouth_texture_animation(0)
	event.reset_mouth_texture_animations()
	event.stop_voice_stream(1)
end

--- Reads the talk target from the triggered event and starts the matching conversation or event script.
function palm_brinks_shop_house.dispatch_talk_event()
	local character_slot: s32 = 0
	local character_id: s32 = 0
	local flag_6: s32 = 0
	local flag_7: s32 = 0
	event.set_message_window_mode(0, 1)
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	character_id = event.get_triggered_event_data_2(14) or character_id
	print("[talk_chara]", character_id, "\n")
	print("[talk_chara_id]", character_id, "\n")
	if character_id == 1 then
		palm_brinks_shop_house.talk_to_house_owner(character_slot, character_id)
	end
	if character_id == -1 then
		flag_6 = event.get_save_flag(6) or flag_6
		flag_7 = event.get_save_flag(7) or flag_7
		if flag_6 == 1 and flag_7 == 0 then
			vm.wait(2)
			event.load_event_script("i01h01/i01h01c.stb", 520)
		end
	end
end

--- Hides the house owner, sets story flag 17 once flag 18 is set, and fades back out to the town map.
function palm_brinks_shop_house.exit_to_town()
	local story_flag: s32 = 0
	palm_brinks_shop_house.hide_house_owner()
	story_flag = event.get_save_flag(18) or story_flag
	if story_flag == 1 then
		story_flag = event.get_save_flag(17) or story_flag
		if story_flag == 0 then
			event.set_save_flag(17, 1)
		end
	end
	event.fade_out_screen(1)
	vm.wait(1)
	event.fade_in_screen(30)
	event.go_to_outside_map(-1, "m01")
end

--- Logs the talked-to character and starts the conversation with it.
function palm_brinks_shop_house.handle_talk_event()
	local character_slot: s32 = 0
	local character_id: s32 = 0
	print("[talk_chara]", character_id, "\n")
	print("[talk_chara_id]", character_id, "\n")
	palm_brinks_shop_house.talk_with_character(character_slot, character_id)
end

--- Logs the talked-to character and starts its skippable conversation.
function palm_brinks_shop_house.handle_talk_event_skippable()
	local character_slot: s32 = 0
	local character_id: s32 = 0
	print("[talk_chara]", character_id, "\n")
	print("[talk_chara_id]", character_id, "\n")
	palm_brinks_shop_house.talk_with_character_skippable(character_slot, character_id)
end

--- Disables the house owner's villager AI and hides the character.
function palm_brinks_shop_house.hide_house_owner()
	event.set_villager_ai_enabled(0, 24)
	event.set_character_active(0, 24)
end

--- Initializes the event and removes the memo pickup once the player owns the memo item.
function palm_brinks_shop_house.initialize_event_hiding_memo()
	local memo_count: s32 = 0
	event.initialize_event()
	memo_count = event.get_item_count(386) or memo_count
	if 0 < memo_count then
		event.set_function_point_enabled("", "item2", 0)
		event.attach_object_handle_to_map_part_2(0, "memo")
		event.set_object_handle_visible(0, 0)
	end
end

--- Initializes the house event and places the Steve and backpack characters according to the story progress.
function palm_brinks_shop_house.initialize_house_with_steve()
	local save_value: s32 = 0
	local story_flag: s32 = 0
	local e107_flag: s32 = 0
	local backpack_flag: s32 = 0
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	palm_brinks_shop_house.initialize_event_hiding_memo()
	event.set_character_active(1, 24)
	event.set_function_point_enabled("", "fc_event_e108c", 0)
	save_value = event.get_save_data_value(0) or save_value
	story_flag = event.get_save_flag(7) or story_flag
	if save_value == 3 and story_flag == 0 then
		print("LOAD_STEAVE------------------\n")
		event.load_character(4, "event/e100/e105/e105_steve.gltf", "info", 25)
		event.set_character_active(1, 25)
		event.load_character(4, "event/e100/e105/back01.gltf", "info", 26)
		event.set_character_active(0, 26)
		e107_flag = event.get_save_flag(107) or e107_flag
		if story_flag == 0 and e107_flag == 1 then
			print("e107 ikou--------------------\n")
			event.set_character_active(0, 24)
			event.set_character_active(1, 25)
			event.set_character_position(25, -116.62, -12.11, -221.76)
			event.set_character_rotation(25, 0.0, 0.16, 0.0)
			event.set_function_point_enabled("", "fc_event_e108c", 1)
		else
			event.set_character_position(25, 62.85, 11.43, -176.07)
			event.set_character_rotation(25, 0.0, -0.72, 0.0)
		end
		backpack_flag = event.get_save_flag(20) or backpack_flag
		if backpack_flag ~= 0 then
			event.set_character_active(1, 26)
			event.attach_character_to_frame(25, "back", 26)
		end
	end
end

--- Plays the discussion in which Starbre and the player agree, then fades the camera out.
function palm_brinks_shop_house.play_agreement_scene(se_id: s32)
	event.set_camera_sequence_position(-18.7, 18.74, -162.67)
	event.set_camera_sequence_look_at(41.67, 24.32, -147.28)
	event.set_object_sequence_rotation(0, 0.0, 0.9, 0.0)
	event.set_object_sequence_motion(0, "スターブル見L", 4)
	event.set_object_sequence_rotation(1, 0.0, -2.23, 0.0)
	event.set_object_sequence_motion(1, "腰に手L", 4)
	message.show_voiced(1050130)
	wait.frames(50)
	event.set_object_sequence_motion(1, "腰に手会話", 6)
	event.queue_object_sequence_next_motion(1, "腰に手L", 0)
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050140)
	event.reset_mouth_texture_animations()
	event.play_sound_effect(se_id, 3)
	event.set_object_sequence_motion(0, "ガッツポーズ", 6)
	event.queue_object_sequence_next_motion(0, "スターブル見L")
	event.delay_object_sequence_motion_track(1, 18)
	event.set_object_sequence_motion(1, "うなづく", 6)
	event.queue_object_sequence_next_motion(1, "腰に手L")
	message.show_voiced(1050150)
	object.wait_until_done(0)
	event.set_object_sequence_motion(1, "腰に手会話", 6)
	event.queue_object_sequence_next_motion(1, "腰に手L", 0)
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050160)
	event.reset_mouth_texture_animations()
	object.wait_until_done(1)
	event.play_sound_effect(se_id, 4)
	event.set_object_sequence_motion(0, "うなづく", 6)
	event.queue_object_sequence_next_motion(0, "スターブル見L")
	event.set_mouth_texture_animations(0, "通常口パク")
	message.show_voiced(1050170)
	event.reset_mouth_texture_animations()
	object.wait_until_done(0)
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050180)
	event.reset_mouth_texture_animations()
	event.mark_camera_sequence_fade_track()
	event.fade_out_camera_sequence(50, 0.0, 0.0, 0.0)
	camera.wait_until_done()
end

--- Plays the scene in which Starbre and the player talk and the player touches the Atlamillia.
function palm_brinks_shop_house.play_atlamillia_touch_scene(se_id: s32)
	event.set_camera_sequence_position(113.96, 46.95, -138.53)
	event.set_camera_sequence_look_at(50.9, 27.15, -165.35)
	event.set_object_sequence_rotation(0, 0.0, 2.34, 0.0)
	event.set_object_sequence_motion(0, "スティーブ見L", 4)
	event.set_object_sequence_motion(1, "腕組み", 4)
	wait.frames(30)
	event.set_object_sequence_motion(1, "左を見る", 2)
	event.queue_object_sequence_next_motion(1, "左を見るL")
	wait.frames(9)
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050010)
	event.reset_mouth_texture_animations()
	event.set_object_sequence_motion(0, "うなづく（スティーブ）", 2)
	event.queue_object_sequence_next_motion(0, "スティーブ見L")
	event.set_mouth_texture_animations(0, "通常口パク")
	message.show_voiced(1050020)
	event.reset_mouth_texture_animations()
	object.wait_until_done(0)
	event.set_object_sequence_motion(0, "右を見る", 2)
	event.queue_object_sequence_next_motion(0, "右を見るL")
	wait.frames(9)
	event.set_mouth_texture_animations(0, "通常口パク")
	message.show_voiced(1050030)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050040)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050050)
	event.reset_mouth_texture_animations()
	event.set_object_sequence_motion(0, "アトラミリアをさわる", 6)
	event.queue_object_sequence_next_motion(0, "アトラミリアをさわるL")
	wait.frames(24)
	event.play_sound_effect(se_id, 2)
	event.set_mouth_texture_animations(0, "通常口パク")
	message.show_voiced(1050060)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced_for(1050065, 15)
	event.reset_mouth_texture_animations()
end

--- Plays the scene in which the player carries the backpack in and sets it down.
function palm_brinks_shop_house.play_backpack_delivery_scene(se_id: s32)
	event.set_camera_sequence_position(-13.13, 19.21, -128.25)
	event.set_camera_sequence_look_at(60.53, 17.71, -147.9)
	event.set_object_sequence_position(0, 77.34, -0.02, -128.37)
	event.set_object_sequence_rotation(0, 0.0, -1.94, 0.0)
	event.set_object_sequence_motion(0, "バックパック歩き", 4, -1.0, 1)
	event.set_object_sequence_position(1, 24.24, -0.02, -152.65)
	event.set_object_sequence_rotation(1, 0.0, 0.93, 0.0)
	event.set_object_sequence_position(2, 62.85, 11.43, -176.07)
	event.set_object_sequence_rotation(2, 0.0, -0.72, 0.0)
	event.attach_character_to_frame(0, "ef00", 35)
	event.set_object_sequence_position(4, 0.0, 0.0, 0.0)
	event.set_object_sequence_rotation(4, 0.0, 1.12, 0.0)
	event.set_character_active(0, 24)
	event.fade_in_screen(15)
	event.move_object_sequence(0, 58.55, -0.02, -130.49, 35)
	object.wait_until_done(0)
	event.set_object_sequence_motion(0, "バックパック持ち")
	wait.frames(15)
	event.set_mouth_texture_animations(0, "通常口パク")
	message.show_voiced(1050440)
	event.reset_mouth_texture_animations()
	event.play_sound_effect(se_id, 2)
	event.set_object_sequence_motion(1, "ガッツポーズ", 2)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.set_mouth_texture_animations(1, "わらい口パク")
	message.show_voiced(1050450)
	event.reset_mouth_texture_animations()
	event.set_object_sequence_motion(0, "バックパックを置く", 2)
	event.queue_object_sequence_next_motion(0, "スターブル見L")
	for i = 0, 83 do
		if i == 24 then
			event.play_sound_effect(se_id, 5)
			event.detach_character_from_frame(35)
			event.set_object_sequence_position(4, 44.54, 6.47, -135.54)
		end
		vm.wait(5)
	end
	event.set_object_sequence_texture_animation(0, 1, "ためいき")
	wait.frames(70)
	event.set_object_sequence_texture_animation(0, 0)
	event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
	event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
	event.set_object_sequence_motion(1, "腰に手", 2)
	event.queue_object_sequence_next_motion(1, "腰に手L")
	wait.frames(14)
	event.set_mouth_texture_animations(1, "わらい口パク")
	message.show_voiced(1050460)
	event.reset_mouth_texture_animations()
	event.play_sound_effect(se_id, 6)
	event.set_object_sequence_motion(0, "うなづく", 6)
	event.reset_object_sequence_dynamic_animation(0)
	event.queue_object_sequence_next_motion(0, "スターブル見L")
	wait.frames(10)
	event.set_mouth_texture_animations(0, "通常口パク")
	message.show_voiced(1050470)
	event.reset_mouth_texture_animations()
	wait.frames(10)
	event.set_mouth_texture_animations(1, "わらい口パク")
	message.show_voiced(1050480)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "わらい口パク")
	message.show_voiced(1050490)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "わらい口パク")
	message.show_voiced(1050491)
	event.reset_mouth_texture_animations()
	event.play_sound_effect(se_id, 7)
	event.set_object_sequence_motion(0, "ガッツポーズ", 6, -1.0, 1)
	event.queue_object_sequence_next_motion(0, "スターブル見L")
	event.set_mouth_texture_animations(0, "わらい口パク")
	message.show_voiced(1050500)
	event.reset_mouth_texture_animations()
	event.play_sound_effect(se_id, 6)
	event.set_object_sequence_motion(1, "うなづく", 6)
	event.queue_object_sequence_next_motion(1, "腰に手L")
	event.set_mouth_texture_animations(1, "わらい口パク")
	message.show_voiced(1050510)
	event.reset_mouth_texture_animations()
end

--- Has Starbre continue explaining about the camera before the player nods.
function palm_brinks_shop_house.play_camera_followup_scene(se_id: any)
	event.detach_character_from_frame(33)
	event.set_character_active(0, 33)
	event.set_camera_sequence_position(-33.79, 30.18, -157.21)
	event.set_camera_sequence_look_at(24.92, 17.88, -150.76)
	event.set_object_sequence_motion(0, "スターブル見L", 4)
	event.set_object_handle_visible(1, 1)
	event.set_object_handle_visible(2, 0)
	event.set_object_sequence_motion(1, "会話2", 6)
	event.queue_object_sequence_next_motion(1, "立ち", 0)
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050250)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050260)
	event.reset_mouth_texture_animations()
	event.set_object_sequence_motion(1, "会話2", 2)
	event.queue_object_sequence_next_motion(1, "立ち", 0)
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050261)
	event.reset_mouth_texture_animations()
	object.wait_until_done(1)
	event.set_object_sequence_motion(1, "立ち")
	object.wait_until_done(1)
	wait.frames(10)
	event.set_object_sequence_motion(0, "うなづく", 6)
	event.wait_object_sequence_motion_end(0)
	object.wait_until_done(0)
	wait.frames(15)
end

--- Shows two illustrations while Starbre explains, then has him take out his camera and keep speaking.
function palm_brinks_shop_house.play_camera_reveal_scene(se_id: s32)
	event.set_camera_sequence_position(-23.06, 16.81, -167.38)
	event.set_camera_sequence_look_at(22.88, 29.55, -159.05)
	event.set_object_sequence_rotation(1, 0.0, -2.35, 0.0)
	event.set_character_active(0, 0)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(50, 0.0, 0.0, 0.0)
	camera.wait_until_done()
	event.set_event_sprite_draw_pass(0, 1)
	event.set_object_sequence_color(3, 128.0, 128.0, 128.0, 128.0, 10)
	wait.frames(10)
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050190)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050200)
	event.reset_mouth_texture_animations()
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 1)
	event.set_object_sequence_color(4, 128.0, 128.0, 128.0, 128.0, 30)
	wait.frames(10)
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050210)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050211)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050212)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050213)
	event.reset_mouth_texture_animations()
	event.set_event_sprite_draw_pass(1, 0)
	event.move_camera_sequence(-2.41, 23.65, -165.23, 57.71, 27.49, -130.12, 28)
	camera.wait_until_done()
	event.set_object_sequence_motion(1, "カメラを出す", 6)
	event.queue_object_sequence_next_motion(1, "カメラを出すL")
	wait.until_motion_progress_counted(32, vm.f32(0.206), -1.0, 20)
	event.play_sound_effect(se_id, 5)
	event.set_character_active(1, 33)
	event.attach_character_to_frame(32, "camera_sta", 33)
	wait.until_motion_progress_counted(32, vm.f32(0.956), -1.0, 20)
	wait.until_motion_finished(32)
	event.play_sound_effect(se_id, 6)
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050220)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050230)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050240)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050241)
	event.reset_mouth_texture_animations()
end

--- Fades the camera in and has Starbre celebrate with a cheer.
function palm_brinks_shop_house.play_celebration_scene(se_id: s32)
	event.set_camera_sequence_position(35.49, 25.34, -101.59)
	event.set_camera_sequence_look_at(50.2, 23.69, -140.94)
	event.set_object_sequence_position(0, 59.55, -1.12, -135.97)
	event.set_object_sequence_rotation(0, 0.0, -2.0, 0.0)
	event.set_object_sequence_motion(0, "スターブル見L", 4)
	event.set_object_sequence_position(1, 38.77, -0.02, -147.68)
	event.set_object_sequence_rotation(1, 0.0, 0.96, 0.0)
	event.set_object_sequence_motion(1, "立ち", 4)
	event.set_object_sequence_position(2, 62.85, 11.43, -176.07)
	event.set_object_sequence_rotation(2, 0.0, -0.72, 0.0)
	wait.frames(30)
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	camera.wait_until_done()
	wait.frames(10)
	event.play_sound_effect(se_id, 2)
	event.set_object_sequence_motion(1, "ガッツポーズ", 6)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.set_mouth_texture_animations(1, "わらい口パク")
	message.show_voiced(1050420)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "わらい口パク")
	message.show_voiced(1050421)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "わらい口パク")
	message.show_voiced(1050430)
	event.reset_mouth_texture_animations()
	event.reset_object_sequence_motion(1)
end

--- Fades the camera in and has Starbre cheer.
function palm_brinks_shop_house.play_cheer_scene(se_id: s32)
	event.set_camera_sequence_position(50.99, 20.54, -99.77)
	event.set_camera_sequence_look_at(50.2, 23.69, -140.94)
	event.set_object_sequence_position(0, 59.55, -1.12, -135.97)
	event.set_object_sequence_rotation(0, 0.0, -2.24, 0.0)
	event.set_object_sequence_motion(0, "スターブル見L", 4, -1.0, 1)
	event.set_object_sequence_position(1, 38.77, -0.02, -147.68)
	event.set_object_sequence_rotation(1, 0.0, 0.72, 0.0)
	event.set_object_sequence_motion(1, "立ち", 4)
	event.set_object_sequence_position(2, 62.85, 11.43, -176.07)
	event.set_object_sequence_rotation(2, 0.0, -0.72, 0.0)
	wait.frames(30)
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	camera.wait_until_done()
	event.play_sound_effect(se_id, 2)
	event.set_object_sequence_motion(1, "ガッツポーズ", 2)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.set_mouth_texture_animations(1, "わらい口パク")
	message.show_voiced(1050360)
	event.reset_mouth_texture_animations()
end

--- Places the player, Starbre and Steve and has Starbre speak a closing remark.
function palm_brinks_shop_house.play_closing_remark_scene(se_id: any)
	event.set_camera_sequence_position(51.28, 21.78, -97.62)
	event.set_camera_sequence_look_at(50.16, 19.92, -141.52)
	event.set_object_sequence_position(0, 58.4, -0.02, -135.54)
	event.set_object_sequence_rotation(0, 0.0, -2.3, 0.0)
	event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
	event.set_object_sequence_position(1, 36.44, -0.02, -151.98)
	event.set_object_sequence_rotation(1, 0.0, 0.69, 0.0)
	event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
	event.set_character_position(25, 62.85, 11.43, -176.07)
	event.set_character_rotation(25, 0.0, -0.72, 0.0)
	wait.frames(15)
	event.set_mouth_texture_animations(1, "わらい口パク")
	message.show_voiced(1050530)
	event.reset_mouth_texture_animations()
end

--- Fades in on the player and Steve standing in the corridor.
function palm_brinks_shop_house.play_corridor_arrival_scene(se_id: s32)
	event.set_camera_sequence_position(-120.34, 23.49, -175.84)
	event.set_camera_sequence_look_at(-120.44, 21.93, -203.94)
	event.set_object_sequence_position(0, -119.53, -12.53, -229.18)
	event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
	event.reset_object_sequence_motion(0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_object_sequence_position(1, -119.53, -12.53, -229.18)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.reset_object_sequence_motion(1)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(50, 0.0, 0.0, 0.0)
	camera.wait_until_done()
	object.wait_until_done(0)
	object.wait_until_done(1)
	event.play_sound_effect(se_id, 1)
	wait.frames(50)
end

--- Turns the player, Steve and Starbre, opens the doors and sends the player and Steve off down the corridor as the camera fades out.
function palm_brinks_shop_house.play_corridor_departure_scene(se_id: s32)
	local projection: f32 = 0
	local projection_range: f32 = 0
	local frame_count: f32 = 0
	local projection_step: f32 = 0
	local frame_index: f32 = 0
	local current_projection: f32 = 0
	event.set_camera_sequence_position(-120.59, 12.3, -121.56)
	event.set_camera_sequence_look_at(-121.3, 14.64, -178.67)
	event.get_event_projection(projection)
	event.set_event_projection(478.9)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -128.93, -12.49, -206.0)
	event.set_object_sequence_rotation(0, 0.0, 1.49, 0.0)
	event.set_character_active(1, 34)
	event.set_object_sequence_position(2, -92.88, -13.05, -212.34)
	event.set_object_sequence_rotation(2, 0.0, -1.44, 0.0)
	event.set_character_active(1, 35)
	event.set_object_sequence_position(3, -128.93, -12.49, -206.0)
	event.set_object_sequence_rotation(3, 0.0, 1.49, 0.0)
	event.set_object_handle_visible(11, 0)
	vm.wait(1)
	event.set_object_sequence_motion(2, "歩き", 4)
	event.rotate_object_sequence(2, 0.0, -2.88, 0.0, 15)
	event.delay_object_sequence_motion_track(2, 15)
	event.set_object_sequence_motion(2, "上見立ち", 0)
	event.play_sound_effect(se_id, 4)
	event.reset_object_sequence_motion(0)
	event.reset_object_sequence_motion(3)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4)
	event.set_object_sequence_motion(3, "歩き（スティーブ）", 4)
	event.rotate_object_sequence(0, 0.0, -3.11, 0.0, 30)
	event.rotate_object_sequence(3, 0.0, -3.11, 0.0, 30)
	wait.frames(30)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 0)
	event.set_object_sequence_motion(3, "立ち（スティーブ）", 0)
	event.play_sound_effect(se_id, 5)
	event.rotate_object_sequence(12, 0.0, -1.57, 0.0, 50)
	event.rotate_object_sequence(13, 0.0, 1.57, 0.0, 50)
	wait.frames(50)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4, -1.0, 1)
	event.set_object_sequence_motion(3, "歩き（スティーブ）", 4)
	event.move_object_sequence(0, -125.29, -12.78, -310.13, 120)
	event.move_object_sequence(3, -125.29, -12.78, -310.13, 120)
	event.mark_camera_sequence_fade_track()
	event.delay_camera_sequence_fade_track(70)
	event.fade_out_camera_sequence(50, 0.0, 0.0, 0.0)
	frame_index = 1.0
	projection_range = vm.f32(132.00003)
	frame_count = 120.0
	projection_step = vm.f32(vm.fdiv(projection_range, frame_count))
	while true do
		current_projection = vm.f32(vm.f32(478.9) + vm.f32(projection_step * frame_index))
		event.set_event_projection(current_projection)
		vm.wait(4)
		frame_index = vm.f32(frame_index + 1.0)
		if frame_index > frame_count then
			break
		end
	end
	event.set_event_projection(projection)
end

--- Fades in on the corridor, has the player and Steve walk toward the camera and closes the doors behind them.
function palm_brinks_shop_house.play_corridor_entry_scene(se_id: s32)
	local projection: f32 = 0
	event.set_camera_sequence_position(-84.68, 6.96, -155.87)
	event.set_camera_sequence_look_at(-202.81, 27.8, -509.36)
	event.get_event_projection(projection)
	event.set_event_projection(468.9)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -121.68, -12.53, -351.93)
	event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
	event.set_character_active(1, 33)
	event.set_object_sequence_position(1, -121.68, -12.53, -351.93)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_handle_visible(10, 0)
	event.set_object_handle_visible(11, 0)
	event.set_object_sequence_rotation(12, 0.0, -1.57, 0.0)
	event.set_object_sequence_rotation(13, 0.0, 1.57, 0.0)
	event.set_object_handle_visible(14, 0)
	event.set_object_handle_visible(15, 0)
	event.fade_out_screen(0)
	object.wait_until_done(12)
	object.wait_until_done(13)
	event.play_sound_effect(se_id, 0)
	event.fade_in_screen(30)
	event.reset_object_sequence_motion(0)
	event.reset_object_sequence_motion(1)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4)
	event.set_object_sequence_motion(1, "歩き（スティーブ）", 4)
	event.move_object_sequence(0, -119.53, -12.53, -218.69, 100)
	event.move_object_sequence(1, -119.53, -12.53, -218.69, 100)
	wait.frames(80)
	event.play_sound_effect(se_id, 4)
	event.rotate_object_sequence(12, 0.0, 0.0, 0.0, 50)
	event.rotate_object_sequence(13, 0.0, 0.0, 0.0, 50)
	object.wait_until_done(0)
	object.wait_until_done(1)
	camera.wait_until_done()
	event.set_event_projection(projection)
end

--- Turns the player and Steve around, opens the doors and sends them out through the corridor as the camera fades out.
function palm_brinks_shop_house.play_corridor_exit_scene(se_id: s32)
	local projection: f32 = 0
	local projection_step: f32 = 0
	local current_projection: f32 = 0
	local frame_count: f32 = 0
	local frame_index: f32 = 0
	event.set_camera_sequence_position(-118.58, 15.3, -131.62)
	event.set_camera_sequence_look_at(-119.04, 14.32, -218.31)
	projection = event.get_event_projection() or projection
	event.set_event_projection(417.9)
	event.set_object_sequence_position(0, -119.53, -12.53, -229.18)
	event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_object_sequence_position(1, -119.53, -12.53, -229.18)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	event.set_object_sequence_motion(0, "歩き（スティーブ）")
	event.set_object_sequence_motion(1, "歩き（スティーブ）")
	event.rotate_object_sequence(0, 0.0, 3.14, 0.0, 50)
	event.rotate_object_sequence(1, 0.0, 3.14, 0.0, 50)
	object.wait_until_done(0)
	object.wait_until_done(1)
	event.set_object_sequence_motion(0, "立ち（スティーブ）")
	event.set_object_sequence_motion(1, "立ち（スティーブ）")
	object.wait_until_done(0)
	object.wait_until_done(1)
	event.play_sound_effect(se_id, 0)
	event.rotate_object_sequence(12, 0.0, -1.57, 0.0, 50)
	event.rotate_object_sequence(13, 0.0, 1.57, 0.0, 50)
	object.wait_until_done(12)
	object.wait_until_done(13)
	event.mark_camera_sequence_fade_track()
	event.delay_camera_sequence_fade_track(100)
	event.fade_out_camera_sequence(50, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 0)
	event.set_object_sequence_motion(1, "歩き（スティーブ）", 0)
	event.move_object_sequence(0, -119.23, -12.53, -333.8, 150)
	event.move_object_sequence(1, -119.23, -12.53, -333.8, 150)
	event.move_camera_sequence(-118.7, 15.3, -153.91, -119.04, 14.32, -218.31, 150)
	frame_count = 150.0
	frame_index = 1.0
	projection_step = vm.f32(vm.fdiv(vm.f32(107.00003), frame_count))
	while true do
		current_projection = vm.f32(projection_step * frame_index)
		current_projection = vm.f32(vm.f32(417.9) + current_projection)
		event.set_event_projection(current_projection)
		vm.wait(7)
		frame_index = vm.f32(frame_index + 1.0)
		if frame_index > frame_count then
			break
		end
	end
	object.wait_until_done(0)
	object.wait_until_done(1)
	camera.wait_until_done()
	event.set_event_projection(projection)
end

--- Plays the first speech in which Starbre addresses the player and Steve with a wide camera.
function palm_brinks_shop_house.play_first_speech_scene(se_id: any)
	local projection: f32 = 0
	event.set_camera_sequence_position(-51.29, 55.13, -119.05)
	event.set_camera_sequence_look_at(-104.92, 14.85, -202.28)
	projection = event.get_event_projection() or projection
	event.set_event_projection(524.9)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -119.73, -13.05, -196.93)
	event.set_object_sequence_rotation(0, 0.0, 1.49, 0.0)
	event.set_character_active(1, 34)
	event.set_object_sequence_position(2, -85.21, -13.05, -197.85)
	event.set_object_sequence_rotation(2, 0.0, -1.68, 0.0)
	event.set_character_active(1, 35)
	event.set_object_sequence_position(3, -119.73, -13.05, -196.93)
	event.set_object_sequence_rotation(3, 0.0, 1.49, 0.0)
	event.set_object_handle_visible(11, 1)
	event.set_object_sequence_motion(0, "下見立ち", 4)
	event.set_object_sequence_motion(3, "下見立ち", 4)
	event.set_object_sequence_motion(2, "上見立ち", 4)
	wait.frames(15)
	event.set_object_sequence_motion(2, "上見会話", 6)
	event.queue_object_sequence_next_motion(2, "上見立ち", 0)
	event.set_mouth_texture_animations(2, "大口パク")
	message.show_voiced(1060060)
	event.reset_mouth_texture_animations()
	event.set_event_projection(projection)
end

--- Has Starbre speak the line that concludes the flashback.
function palm_brinks_shop_house.play_flashback_conclusion_scene(projection: any, se_id: any)
	event.set_camera_sequence_position(-38.62, 34.71, -174.94)
	event.set_camera_sequence_look_at(37.54, 15.45, -157.32)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, 16.25, -0.02, -166.37)
	event.set_object_sequence_rotation(0, 0.0, 1.16, 0.0)
	event.set_object_sequence_motion(0, "スターブル見L", 4)
	event.set_character_active(1, 32)
	event.set_object_sequence_motion(1, "腰に手L", 4)
	event.set_character_active(1, 25)
	wait.frames(30)
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050330)
	event.reset_mouth_texture_animations()
end

--- Runs the whole flashback event, setting up the sprites and characters, playing its scenes and restoring the camera.
function palm_brinks_shop_house.play_flashback_event()
	local se_id: s32 = 0
	local projection: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local image_block: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(105, 1)
		event.initialize_event()
		event.enable_drama_skip()
		event.set_message_window_mode(0, 7)
		se_id = event.load_sound_effect_file_3(4, 1225) or se_id
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		projection = event.get_event_projection() or projection
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
		event.load_character_motion_pack(5, "event/e100/e105/e105_mints.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_position(0, 72.86, 57.47, 35.39)
		event.load_character(5, "event/e100/e105/e105_starbre.gltf", "info", 32)
		event.set_character_active(1, 32)
		event.attach_object_handle_to_character(1, 32)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 67.74, -59.99, 63.26)
		event.set_object_sequence_rotation(1, 0.0, 3.04, 0.0)
		image_block = event.load_event_image_4(5, "textures/event/e100/e105/e105b_2d.json", 0) or image_block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e105b_2d01", image_block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_alpha_blend(0, 0)
		event.attach_object_handle_to_sprite(2, 0)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "e105b_2d02", image_block)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
		event.set_event_sprite_size(1, 512, 448)
		event.set_event_sprite_position(1, 256, 224)
		event.set_event_sprite_draw_pass(1, 0)
		event.set_event_sprite_alpha_blend(1, 0)
		event.attach_object_handle_to_sprite(3, 1)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.reset_event_sprite(2)
		event.set_event_sprite_type(2, 0)
		event.set_event_sprite_texture(2, "e105b_2d03", image_block)
		event.set_event_sprite_color(2, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(2, 0, 0, 512, 448)
		event.set_event_sprite_size(2, 512, 448)
		event.set_event_sprite_position(2, 256, 224)
		event.set_event_sprite_draw_pass(2, 0)
		event.set_event_sprite_alpha_blend(2, 0)
		event.attach_object_handle_to_sprite(4, 2)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.load_message_file(0, 5, "event/e100/e105/e105b_1.txt")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		palm_brinks_shop_house.play_memory_slideshow_scene(projection, se_id)
		palm_brinks_shop_house.play_flashback_conclusion_scene(projection, se_id)
	end)
	vm.entry(4)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	wait.frames(30)
	event.set_character_active(1, 0)
	event.set_character_active(1, 25)
	event.set_event_projection(projection)
	event.set_camera_position(camera_x, camera_y, camera_z)
	event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.set_event_sprite_draw_pass(2, 0)
	event.delete_event_image(0)
	event.fade_in_screen(30)
end

--- Fades to an illustration sprite and has Starbre speak four lines over it.
function palm_brinks_shop_house.play_illustrated_chat_scene(se_id: any)
	local image_block: s32 = 0
	event.clear_camera_sequence()
	event.fade_out_camera_sequence(30, 0.0, 0.0, 0.0)
	camera.wait_until_done()
	event.set_camera_sequence_position(91.52, 19.06, -115.56)
	event.set_camera_sequence_look_at(36.75, 33.39, -130.18)
	event.set_character_active(0, 0)
	event.set_object_sequence_motion(1, "腰に手L", 4)
	image_block = event.load_event_image_4(5, "textures/event/e100/e105/e105c_2d.json", 0) or image_block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e105c_2d01", image_block)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
	event.set_event_sprite_size(0, 512, 448)
	event.set_event_sprite_position(0, 256, 224)
	event.set_event_sprite_alpha_blend(0, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(10, 0)
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	wait.frames(30)
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	camera.wait_until_done()
	event.set_event_sprite_draw_pass(0, 1)
	event.set_object_sequence_color(10, 128.0, 128.0, 128.0, 128.0, 10)
	wait.frames(30)
	event.set_object_sequence_motion(1, "腰に手会話", 4)
	event.set_mouth_texture_animations(1, "わらい口パク")
	message.show_voiced(1050370)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "わらい口パク")
	message.show_voiced(1050371)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "わらい口パク")
	message.show_voiced(1050380)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "わらい口パク")
	message.show_voiced(1050390)
	event.reset_mouth_texture_animations()
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
end

--- Fades in on the three characters and switches the light on with its sound effects.
function palm_brinks_shop_house.play_lights_on_scene(light_draw_flag: s32, se_id: s32)
	event.set_camera_sequence_position(-98.46, 29.02, -221.77)
	event.set_camera_sequence_look_at(-133.84, 25.44, -219.86)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -143.53, -12.49, -220.28)
	event.set_object_sequence_rotation(0, 0.0, 1.61, 0.0)
	event.set_object_sequence_position(2, -79.25, -13.53, -223.34)
	event.set_object_sequence_rotation(2, 0.0, -1.56, 0.0)
	event.set_object_sequence_position(3, -143.53, -12.49, -220.28)
	event.set_object_sequence_rotation(3, 0.0, 1.61, 0.0)
	event.reset_object_sequence_motion(0)
	event.reset_object_sequence_motion(3)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4, -1.0, 1)
	event.set_object_sequence_motion(3, "立ち（スティーブ）", 4)
	event.fade_in_screen(30)
	wait.frames(30)
	wait.frames(45)
	event.play_sound_effect(se_id, 6)
	event.play_sound_effect(se_id, 8)
	event.set_object_handle_frame_draw_flag(3, "light", light_draw_flag)
	wait.frames(45)
end

--- Plays Starbre's story over crossfading illustration sprites with voiced messages.
function palm_brinks_shop_house.play_memory_slideshow_scene(projection: f32, se_id: s32)
	event.set_event_projection(projection)
	event.set_camera_sequence_position(-15.15, 22.51, -151.72)
	event.set_camera_sequence_look_at(32.49, 27.39, -162.95)
	event.set_character_active(0, 0)
	event.set_object_sequence_position(1, 38.77, -0.02, -147.68)
	event.set_object_sequence_rotation(1, 0.0, -2.04, 0.0)
	event.set_object_sequence_motion(1, "手に腰L", 4)
	wait.frames(30)
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	camera.wait_until_done()
	event.set_object_sequence_texture_animation(1, 1, "目とじ")
	event.set_object_sequence_motion(1, "下を見る", 2)
	event.queue_object_sequence_next_motion(1, "下を見るL")
	wait.frames(10)
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050290)
	event.reset_mouth_texture_animations()
	event.set_character_active(0, 25)
	event.start_crossfade(0, 0, 30)
	event.set_event_sprite_draw_pass(0, 2)
	event.set_object_sequence_color(2, 128.0, 128.0, 128.0, 128.0, 0)
	wait.frames(30)
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050291)
	event.reset_mouth_texture_animations()
	object.wait_until_done(1)
	event.start_crossfade(30)
	event.set_object_sequence_color(2, 0.0, 0.0, 0.0, 0.0, 30)
	event.set_event_sprite_draw_pass(1, 2)
	event.set_object_sequence_color(3, 128.0, 128.0, 128.0, 128.0, 30)
	event.set_object_sequence_texture_animation(1, 0)
	event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
	event.set_object_sequence_texture_animation(1, 1, "目パチ")
	event.play_sound_effect(se_id, 2)
	event.set_object_sequence_motion(1, "上を見る", 2)
	event.queue_object_sequence_next_motion(1, "上を見るL")
	wait.frames(16)
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050300)
	event.reset_mouth_texture_animations()
	event.start_crossfade(30)
	event.set_object_sequence_color(3, 0.0, 0.0, 0.0, 30)
	event.set_event_sprite_draw_pass(2, 2)
	event.set_object_sequence_color(4, 128.0, 128.0, 128.0, 128.0, 30)
	event.set_object_sequence_color(3, 0.0, 0.0, 0.0, 0.0, 30)
	event.play_sound_effect(se_id, 3)
	event.set_object_sequence_motion(1, "頭をかく", 2)
	event.queue_object_sequence_next_motion(1, "頭をかくL")
	wait.frames(28)
	event.set_mouth_texture_animations(1, "通常口パク")
	palm_brinks_shop_house.show_voiced_message(1050310, 32, se_id, 4, vm.f32(0.15))
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	palm_brinks_shop_house.show_voiced_message(1050320, 32, se_id, 4, vm.f32(0.15))
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	palm_brinks_shop_house.show_voiced_message(1050321, 32, se_id, 4, vm.f32(0.15))
	event.reset_mouth_texture_animations()
	event.set_character_active(0, 32)
	event.start_crossfade(30)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.set_event_sprite_draw_pass(2, 0)
end

--- Fades the camera in and has Starbre speak three lines to the player.
function palm_brinks_shop_house.play_post_flashback_chat_scene(se_id: any)
	event.set_camera_sequence_position(-33.29, 24.37, -167.32)
	event.set_camera_sequence_look_at(40.27, 15.44, -159.28)
	event.set_object_sequence_position(0, 18.58, -1.12, -168.14)
	event.set_object_sequence_rotation(0, 0.0, 0.92, 0.0)
	event.set_object_sequence_motion(0, "スターブル見L", 4, -1.0, 1)
	event.set_object_sequence_position(1, 38.77, -0.02, -147.68)
	event.set_object_sequence_rotation(1, 0.0, -2.16, 0.0)
	wait.frames(20)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	camera.wait_until_done()
	wait.frames(15)
	event.set_object_sequence_motion(1, "会話2", 6)
	event.queue_object_sequence_next_motion(1, "立ち", 0)
	event.set_mouth_texture_animations(1, "わらい口パク")
	message.show_voiced(1050340)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "わらい口パク")
	message.show_voiced(1050341)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "わらい口パク")
	message.show_voiced(1050350)
	event.reset_mouth_texture_animations()
end

--- Plays the exchange in which the player and Steve promise Starbre to take on the job.
function palm_brinks_shop_house.play_promise_scene(se_id: any)
	event.set_camera_sequence_position(-93.2, 20.09, -139.75)
	event.set_camera_sequence_look_at(-109.87, 17.08, -226.98)
	event.reset_object_sequence_motion(1)
	event.reset_object_sequence_motion(3)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -119.73, -13.05, -196.93)
	event.set_object_sequence_rotation(0, 0.0, 1.49, 0.0)
	event.reset_object_sequence_motion(0)
	event.set_character_active(1, 34)
	event.set_object_sequence_position(2, -85.21, -13.05, -197.85)
	event.set_object_sequence_rotation(2, 0.0, -1.68, 0.0)
	event.set_character_active(1, 35)
	event.set_object_sequence_position(3, -119.73, -13.05, -196.93)
	event.set_object_sequence_rotation(3, 0.0, 1.49, 0.0)
	event.reset_object_sequence_motion(3)
	event.set_object_handle_visible(11, 0)
	event.set_object_sequence_motion(0, "うなづく", 6)
	event.queue_object_sequence_next_motion(0, "下見立ち", 4)
	event.set_object_sequence_motion(2, "上見立ち", 4)
	event.set_object_sequence_motion(3, "うなづく", 6)
	event.queue_object_sequence_next_motion(3, "下見立ち", 4)
	event.set_mouth_texture_animations(0, "わらい口パク")
	message.show_voiced(1060070)
	event.reset_mouth_texture_animations()
	wait.frames(15)
	event.set_object_sequence_motion(2, "上見会話2", 6)
	event.queue_object_sequence_next_motion(2, "上見立ち", 0)
	event.set_mouth_texture_animations(2, "わらい口パク")
	message.show_voiced(1060080)
	event.reset_mouth_texture_animations()
	wait.frames(15)
	event.set_object_sequence_motion(0, "まかせて", 6)
	event.queue_object_sequence_next_motion(0, "下見立ち", 4)
	event.set_object_sequence_motion(3, "まかせて", 6)
	event.queue_object_sequence_next_motion(3, "下見立ち", 4)
	wait.frames(10)
	event.set_mouth_texture_animations(0, "わらい口パク")
	message.show_voiced(1060090)
	event.reset_mouth_texture_animations()
	object.wait_until_done(0)
	object.wait_until_done(3)
end

--- Plays the conversation between the player and Starbre while they stand facing each other.
function palm_brinks_shop_house.play_standing_conversation_scene(se_id: any)
	event.set_camera_sequence_position(-17.27, 17.65, -125.13)
	event.set_camera_sequence_look_at(49.66, 25.36, -167.46)
	event.set_object_sequence_position(0, 16.96, -0.02, -159.01)
	event.set_object_sequence_rotation(0, 0.0, 1.62, 0.0)
	event.set_object_sequence_motion(0, "スティーブ見L", 4)
	event.set_object_sequence_position(1, 29.23, -0.02, -141.02)
	event.set_object_sequence_rotation(1, 0.0, 2.13, 0.0)
	event.set_object_sequence_motion(1, "腕組み", 4)
	wait.frames(9)
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050070)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050071)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(0, "わらい口パク")
	message.show_voiced(1050080)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050090)
	event.reset_mouth_texture_animations()
	event.set_object_sequence_motion(0, "右を見る", 6)
	event.queue_object_sequence_next_motion(0, "右を見るL")
	event.set_mouth_texture_animations(0, "わらい口パク")
	message.show_voiced(1050100)
	event.reset_mouth_texture_animations()
	object.wait_until_done(0)
	event.set_object_sequence_motion(1, "左を見る", 2)
	event.queue_object_sequence_next_motion(1, "左を見るL")
	event.set_mouth_texture_animations(1, "通常口パク")
	message.show_voiced(1050110)
	event.reset_mouth_texture_animations()
	object.wait_until_done(1)
	event.set_object_sequence_motion(0, "右を見る会話", 6)
	event.queue_object_sequence_next_motion(0, "右を見るL")
	event.set_mouth_texture_animations(0, "わらい口パク")
	message.show_voiced(1050120)
	event.reset_mouth_texture_animations()
	object.wait_until_done(0)
end

--- Fades the camera in and has the player walk to a spot in front of Starbre.
function palm_brinks_shop_house.play_walk_in_scene(se_id: any)
	local projection: f32 = 0
	event.set_camera_sequence_position(-13.56, 50.69, -99.84)
	event.set_camera_sequence_look_at(47.32, 59.3, -184.47)
	projection = event.get_event_projection() or projection
	event.set_event_projection(471.9)
	event.set_object_sequence_position(0, -17.08, -0.02, -207.87)
	event.set_object_sequence_rotation(0, 0.0, 1.62, 0.0)
	event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
	event.set_object_sequence_position(1, 34.05, -0.02, -143.69)
	event.set_object_sequence_rotation(1, 0.0, 2.73, 0.0)
	event.set_object_sequence_motion(1, "上を見るL", 4)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(50, 0.0, 0.0, 0.0)
	camera.wait_until_done()
	event.move_camera_sequence_eased(-13.56, 18.54, -99.84, 47.32, 27.15, -184.47, 90, 2, 0.4)
	camera.wait_until_done()
	event.set_object_sequence_motion(0, "歩き", 0)
	event.move_object_sequence(0, 8.7, -0.02, -189.32, 45)
	event.rotate_object_sequence(0, 0.0, 0.3, 0.0, 45)
	event.move_object_sequence(0, 16.96, -0.02, -159.01, 45)
	object.wait_until_done(0)
	event.rotate_object_sequence(0, 0.0, 1.74, 0.0, 10)
	event.delay_object_sequence_motion_track(0, 10)
	event.set_object_sequence_motion(0, "立ち")
	object.wait_until_done(0)
	wait.frames(10)
	event.set_event_projection(projection)
end

--- Reinitializes the event, restores the house owner and player, resets the follow camera and fades the screen in.
function palm_brinks_shop_house.resume_exploration()
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.set_villager_ai_enabled(1, 24)
	event.set_character_active(1, 0)
	event.set_character_active(1, 24)
	event.reset_follow_camera(1)
	event.fade_in_screen(30)
end

--- Streams a voice line and shows its message window with lip sync until the player advances it.
function palm_brinks_shop_house.show_voiced_message(message_id: s32, character_slot: s32, se_id: s32, sound_index: s32, sound_trigger_time: f32)
	local open_state: s32 = 0
	local ready_state: s32 = 0
	event.open_voice_stream_wave(1, message_id)
	while true do
		open_state = event.get_voice_stream_open_state() or open_state
		if open_state == 0 then
			break
		else
			vm.wait(1)
		end
	end
	event.ready_voice_stream(1)
	while true do
		ready_state = event.get_voice_stream_open_state() or ready_state
		if ready_state == 0 then
			break
		else
			vm.wait(2)
		end
	end
	event.open_message_window_2(0, message_id)
	message.open(0, -1, 8, 0, 0)
	event.play_voice_stream(1)
	palm_brinks_shop_house.animate_voiced_message(0, character_slot, se_id, sound_index, sound_trigger_time)
	message.close(0)
	event.close_voice_stream(1)
end

--- Applies the end state of the corridor arrival scene when the player skips it.
function palm_brinks_shop_house.skip_corridor_arrival_scene(se_id: s32)
	wait.background_load_skipping()
	cutscene.skip_command(0)
	cutscene.skip_command(1)
	wait.frames_skipping(50)
end

--- Waits out the corridor departure scene when the player skips it.
function palm_brinks_shop_house.skip_corridor_departure_scene(se_id: s32)
	local frame_index: f32 = 0
	wait.frames_skipping(30)
	wait.frames_skipping(50)
	frame_index = 1.0
	frame_index = vm.f32(frame_index + 1.0)
end

--- Applies the end state of the corridor exit scene when the player skips it.
function palm_brinks_shop_house.skip_corridor_exit_scene(se_id: s32)
	local projection_step: f32 = 0
	local current_projection: f32 = 0
	local frame_count: f32 = 0
	local frame_index: f32 = 0
	cutscene.skip_command(0)
	cutscene.skip_command(1)
	cutscene.skip_command(0)
	cutscene.skip_command(1)
	cutscene.skip_command(12)
	cutscene.skip_command(13)
	frame_count = 150.0
	frame_index = 1.0
	projection_step = vm.f32(vm.fdiv(vm.f32(107.00003), frame_count))
	current_projection = vm.f32(projection_step * frame_index)
	current_projection = vm.f32(vm.f32(417.9) + current_projection)
	frame_index = vm.f32(frame_index + 1.0)
	cutscene.skip_command(0)
	cutscene.skip_command(1)
	wait.background_load_skipping()
end

--- Replays the dialogue and choice of the scene when the player skips it and returns 1.
function palm_brinks_shop_house.skip_dialogue_scene_with_choice(se_id: s32)
	wait.background_load_skipping()
	wait.frames_skipping(30)
	wait.background_load_skipping()
	wait.frames_skipping(10)
	message.show_voiced_skipping(1060010)
	local _ = message.open_choice_skipping(0, -1, 8, 0, 0, 2, 0)
	message.show_voiced_skipping(1060040)
	message.show_voiced_skipping(1060050)
	wait.frames_skipping(30)
	return 1
end

--- Replays the first speech of the scene when the player skips it.
function palm_brinks_shop_house.skip_first_speech_scene(se_id: any)
	wait.frames_skipping(15)
	message.show_voiced_skipping(1060060)
end

--- Waits out the lights-on scene when the player skips it.
function palm_brinks_shop_house.skip_lights_on_scene(light_draw_flag: s32, se_id: s32)
	wait.frames_skipping(30)
	wait.frames_skipping(45)
	wait.frames_skipping(45)
end

--- Replays the promise scene's speech when the player skips it.
function palm_brinks_shop_house.skip_promise_scene(se_id: any)
	message.show_voiced_skipping(1060070)
	wait.frames_skipping(15)
	message.show_voiced_skipping(1060080)
	wait.frames_skipping(15)
	wait.frames_skipping(10)
	message.show_voiced_skipping(1060090)
	cutscene.skip_command(0)
	cutscene.skip_command(3)
end

--- Handles the talk with the house owner according to the story flags, materials owned and invention state.
function palm_brinks_shop_house.talk_to_house_owner(character_slot: s32, character_id: any)
	local story_flag: s32 = 0
	local query_result: s32 = 0
	local player_slot: s32 = 0
	local selection: any = 0
	local scrap_iron_count: s32 = 0
	local thick_leather_count: s32 = 0
	local copper_lump_count: s32 = 0
	event.set_character_motion(0, "立ち", 0)
	wait.for_frame_count(9)
	story_flag = event.get_save_flag(7) or story_flag
	if story_flag == 1 then
		event.set_villager_ai_enabled(0, 24)
		message.set_window_mode(0, 1)
		cutscene.begin_talk(character_slot, 0, 0)
		player_slot = event.get_player_character_slot() or player_slot
		event.open_message_window_2(0, "スティーブの調子はどうじゃ？")
		message.say_bubble(0, -1, character_slot, player_slot, 0)
		event.set_character_motion(character_slot, "立ち")
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.open_message_window_2(0, "ねんりょう補給\nコアのパワーアップ")
		selection = message.open_and_ask_choice(0, -1, 5, 256, 208, 2, 0)
		event.set_message_window_option(0, 0, 0)
		event.set_message_bubble_tail(0, 1)
		if selection == 0 then
			event.set_save_data_value(2)
			event.open_message_window_2(0, "よし、これで\n修理完了じゃ！")
			message.say_bubble(0, -1, character_slot, player_slot, 0)
		end
		if selection == 1 then
			event.fade_out_screen(25)
			wait.for_frame_count(30)
			event.open_event_menu(6, 23)
			vm.wait(7)
			event.fade_in_screen(25)
		end
		event.set_villager_ai_enabled(1, 24)
		return
	end
	story_flag = event.get_save_flag(107) or story_flag
	if story_flag == 1 then
		event.set_villager_ai_enabled(0, 24)
		event.open_message_window_2(
			0,
			"こんなことであきらめるのか？\nなにごともネバーギブアップじゃ。"
		)
		cutscene.talk(character_slot, -1, 0, 0)
		event.set_villager_ai_enabled(1, 24)
		return
	end
	story_flag = event.get_save_flag(20) or story_flag
	if story_flag == 1 then
		vm.wait(9)
		event.load_event_script("i01h01/i01h01c.stb", 500)
		return
	end
	query_result = event.get_item_count(165) or query_result
	if query_result > 0 then
		event.set_save_flag(20, 1)
		vm.wait(10)
		event.load_event_script("i01h01/i01h01b.stb", 520)
		return
	end
	scrap_iron_count = event.get_item_count(224) or scrap_iron_count
	thick_leather_count = event.get_item_count(245) or thick_leather_count
	copper_lump_count = event.get_item_count(227) or copper_lump_count
	query_result = event.is_invention_created(165) or query_result
	if scrap_iron_count >= 20 and thick_leather_count >= 1 and copper_lump_count >= 2 and query_result ~= -1 then
		vm.wait(11)
		event.load_event_script("i01h01/i01h01b.stb", 520)
		return
	end
	story_flag = event.get_save_flag(19) or story_flag
	if story_flag == 1 then
		event.set_villager_ai_enabled(0, 24)
		event.open_message_window_2(
			0,
			"ここをでて、目の前にあるかぼちゃの\nかんばんの店がアイテム屋じゃ。<page>鉄クズ２０個、銅のかたまり２個、\nそれとぶあつい皮じゃぞ。\n早く買ってくるのじゃ。"
		)
		cutscene.talk(character_slot, -1, 0, 0)
		event.set_villager_ai_enabled(1, 24)
		return
	end
	query_result = event.is_invention_created(165) or query_result
	if query_result ~= -1 then
		vm.wait(13)
		event.load_event_script("i01h01/i01h01b.stb", 520)
		return
	end
	query_result = event.has_invention_ideas(165) or query_result
	if query_result == 1 then
		vm.wait(14)
		event.load_event_script("i01h01/i01h01b.stb", 520)
		return
	end
	story_flag = event.get_save_flag(17) or story_flag
	if story_flag == 1 then
		vm.wait(15)
		event.load_event_script("i01h01/i01h01b.stb", 510)
		return
	end
	story_flag = event.get_save_flag(105) or story_flag
	if story_flag == 0 then
		event.open_message_window_2(0, "ユリス、バイトをサボるんじゃないぞ。\nわかったな！")
		cutscene.talk(character_slot, -1, 0, 0)
		return
	end
	event.set_villager_ai_enabled(0, 24)
	event.open_message_window_2(0, "まずは自分の力で、\nやってみるのじゃ。")
	cutscene.talk(character_slot, -1, 0, 0)
	event.open_message_window_2(0, "どうしても解らなければ、\nヒントをだしてやる。")
	cutscene.talk(character_slot, -1, 0, 0)
	event.open_message_window_2(0, "さあ、行け！")
	cutscene.talk(character_slot, -1, 0, 0)
	event.set_villager_ai_enabled(1, 24)
end

--- Opens the conversation with the character in the given slot and shows its choice window.
function palm_brinks_shop_house.talk_with_character(character_slot: s32, character_id: any)
	local player_slot: s32 = 0
	wait.skip_frame_count(9)
	message.set_window_mode_skipping(0, 1)
	character.interpolate_path(character_slot, 0, 0)
	message.show_then_close_variant(0, -1, character_slot, player_slot, 0)
	local _ = message.open_choice_skipping(0, -1, 5, 256, 208, 2, 0)
	message.show_then_close_variant(0, -1, character_slot, player_slot, 0)
	wait.skip_frame_count(30)
end

--- Opens the conversation with the character in the given slot using skippable waits.
function palm_brinks_shop_house.talk_with_character_skippable(character_slot: s32, character_id: any)
	local player_slot: s32 = 0
	wait.frames_skipping(9)
	message.set_window_mode_skipping(0, 1)
	character.interpolate_path(character_slot, 0, 0)
	message.show_then_close_variant(0, -1, character_slot, player_slot, 0)
	local _ = message.open_choice_skipping(0, -1, 5, 256, 208, 2, 0)
	message.show_then_close_variant(0, -1, character_slot, player_slot, 0)
	wait.frames_skipping(30)
end

return palm_brinks_shop_house
