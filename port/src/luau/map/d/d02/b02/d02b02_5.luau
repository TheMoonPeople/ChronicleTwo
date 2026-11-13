--!strict
--- Boss floor script for the Rainbow Butterfly fight, with the butterfly arrival and split cutscenes, hint messages and the return to the previous floor.

local vm = require("@lib/vm")
local calc = require("@lib/event/calc")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local inventory = require("@lib/event/inventory")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local rainbow_butterfly_wood_butterfly_event = require("@lib/event/rainbow_butterfly_wood_butterfly_event")
local wait = require("@lib/event/wait")

local mints_slot: s32 = 0
local monica_slot: s32 = 0

--- Loads the characters, boss model, title sprite and message file used by the butterfly arrival cutscene.
local function load_arrival_cutscene(sound_bank: s32)
	local active_character: s32 = 0
	local block: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		mints_slot = 0
		monica_slot = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot)
		event.load_character_motion_pack(5, "event/e200/e257/e257_mints.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e257/e257_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 13)
	end
	if active_character == 1 then
		mints_slot = 8
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", mints_slot)
		event.load_equipment_model(5, 0, 4, "info", mints_slot)
		event.load_equipment_model(5, 0, 3, "info", mints_slot)
		event.load_equipment_model(5, 0, 2, "info", mints_slot, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot)
		event.load_character_motion_pack(5, "event/e200/e257/e257_mints.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot)
		event.set_character_active(1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e257/e257_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.set_character_visible(1, 0)
	event.set_character_visible(2, 0)
	event.load_character(5, "dungeon/monster/b02a.gltf", "info", 11)
	event.set_character_active(0, 11)
	event.attach_object_handle_to_character(3, 11)
	event.set_object_handle_sound_bank(3, sound_bank)
	event.clear_object_sequence(3, 11)
	event.set_object_sequence_object(3, 3)
	block = event.load_event_image_4(5, "textures/event/e200/e257/e257telop01_1.json", 0) or block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e257telop01", block)
	event.set_event_sprite_position(0, 256, 312)
	event.set_event_sprite_size(0, 512, 128)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_scale(0, 1.0, 1.0)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(10, 0)
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.load_message_file(0, 5, "event/e200/e257/e257_1.txt")
end

--- Reassigns the two party character slots to their post-skip values when the arrival cutscene is skipped.
local function swap_party_slots_after_arrival_skip(sound_bank: s32)
	mints_slot = 0
	monica_slot = 8
	mints_slot = 8
	monica_slot = 0
end

--- Restores the party and deletes the boss model and title sprite loaded for the arrival cutscene.
local function unload_arrival_cutscene()
	local active_character: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		event.set_character_active(1, mints_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(13)
	end
	if active_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, mints_slot)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(mints_slot)
		event.delete_character(13)
	end
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.delete_character(11)
	event.delete_event_image(0)
end

--- Plays the cutscene in which the Rainbow Butterfly flies over the heroes and they react to it.
local function play_arrival_cutscene()
	local frame: s32 = 0
	local sound_bank: s32 = 0
	local character_angle: f32 = 0
	local camera_angle: f32 = 0
	local look_at_angle: f32 = 0
	local character_radius: f32 = 0
	local camera_radius: f32 = 0
	local look_at_radius: f32 = 0
	local character_rotation: f32 = 0
	local character_x: f32 = 0
	local character_z: f32 = 0
	local camera_x: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_z: f32 = 0
	local voice_id: s32 = 0
	local voice_open_state: s32 = 0
	local voice_ready_state: s32 = 0
	local partner_angle: f32 = 0
	local partner_radius: f32 = 0
	local partner_x: f32 = 0
	local partner_z: f32 = 0
	local partner_rotation: f32 = 0
	local partner_angle_offset: f32 = 0
	local butterfly_yaw: f32 = 0
	local previous_butterfly_x: f32 = 0
	local previous_butterfly_z: f32 = 0
	local butterfly_x: f32 = 0
	local butterfly_y: f32 = 0
	local butterfly_z: f32 = 0
	local butterfly_angle: f32 = 0
	local partner_turn_rotation: f32 = 0
	local character_turn_rotation: f32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(257, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.fade_out_screen(30)
		at = 1
		wait.frames(30)
		event.load_map_sounds(2833)
		sound_bank = event.load_sound_effect_file_2(2833) or sound_bank
		event.stop_music(0)
		at = 2
		wait.frames(4)
		event.load_music(31)
		load_arrival_cutscene(sound_bank)
		event.set_object_sequence_motion(11, "歩き")
		event.set_character_active(0, 11)
		event.show_dungeon_status_bar(0, 1.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(222.66, 860.66, 315.48)
		event.set_camera_sequence_look_at(386.81, 799.84, 241.69)
		event.fade_in_screen(30)
		at = 3
		wait.frames(60)
		event.set_character_active(1, monica_slot)
		event.set_object_handle_footstep_sound(1, 17)
		event.set_object_sequence_position(1, 459.65, 700.0, 314.9)
		event.set_object_sequence_rotation(1, 0.0, -1.63, 0.0)
		event.jump_object_sequence(1, 338.06, 791.14, 270.62, -0.6, 30)
		event.set_object_sequence_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "飛びＬ", 6)
		event.queue_object_sequence_next_motion(1, "着地2", 6)
		event.queue_object_sequence_next_motion(1, "着地2Ｌ", 6)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		at = 4
		wait.frames(10)
		event.move_camera_sequence_eased(222.66, 860.66, 315.48, 374.28, 799.84, 218.4, 30, 2, 1.0)
		event.play_sound_effect(sound_bank, 0)
		event.set_character_active(1, mints_slot)
		event.set_object_sequence_position(0, 465.64, 700.0, 251.72)
		event.set_object_sequence_rotation(0, 0.0, -1.63, 0.0)
		event.jump_object_sequence(0, 345.04, 787.93, 219.25, -0.6, 30)
		event.set_object_sequence_motion(0, "飛びL", 6)
		event.queue_object_sequence_next_motion(0, "飛びL", 6)
		event.queue_object_sequence_next_motion(0, "飛びL", 6)
		event.queue_object_sequence_next_motion(0, "飛びL", 6)
		event.queue_object_sequence_next_motion(0, "飛びL", 6)
		event.queue_object_sequence_next_motion(0, "飛びL", 6)
		event.queue_object_sequence_next_motion(0, "飛びL", 6)
		event.queue_object_sequence_next_motion(0, "飛びL", 6)
		event.queue_object_sequence_next_motion(0, "飛びL", 6)
		event.queue_object_sequence_next_motion(0, "飛びL", 6)
		event.queue_object_sequence_next_motion(0, "こける", 6)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_character_cloth_animation_enabled(mints_slot, 0)
		at = 5
		wait.frames(20)
		event.play_sound_effect(sound_bank, 1)
		at = 6
		wait.frames(10)
		event.play_sound_effect(sound_bank, 2)
		at = 7
		wait.frames(30)
		event.set_character_cloth_animation_enabled(monica_slot, 0)
		event.set_character_cloth_animation_enabled(mints_slot, 1)
		event.enable_drama_skip()
		character_angle = vm.f32(0.116339)
		camera_angle = vm.f32(0.074309)
		look_at_angle = vm.f32(0.124094)
		character_radius = vm.f32(496.65527)
		camera_radius = vm.f32(526.85187)
		look_at_radius = vm.f32(483.53925)
		character_rotation = vm.f32(-1.63)
		character_x = vm.f32(vm.f32(vm.sin(character_angle) * character_radius) + vm.f32(268.802))
		character_z = vm.f32(vm.f32(vm.cos(character_angle) * character_radius) + vm.f32(-322.002))
		camera_x = vm.f32(vm.f32(vm.sin(camera_angle) * camera_radius) + vm.f32(268.802))
		camera_z = vm.f32(vm.f32(vm.cos(camera_angle) * camera_radius) + vm.f32(-322.002))
		look_at_x = vm.f32(vm.f32(vm.sin(look_at_angle) * look_at_radius) + vm.f32(268.802))
		look_at_z = vm.f32(vm.f32(vm.cos(look_at_angle) * look_at_radius) + vm.f32(-322.002))
		event.set_camera_sequence_position(camera_x, 809.42, camera_z)
		event.set_camera_sequence_look_at(look_at_x, 815.5, look_at_z)
		event.set_object_sequence_position(1, character_x, 791.14, character_z)
		event.set_object_sequence_rotation(1, 0.0, character_rotation, 0.0)
		event.set_object_sequence_motion(1, "着地2Ｌ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ちあがり", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		at = 8
		vm.wait(8)
		event.set_character_cloth_animation_enabled(monica_slot, 1)
		event.reset_object_sequence_dynamic_animation(1)
		event.delay_object_sequence_motion_track(1, 1)
		event.reset_object_sequence_dynamic_animation(1)
		event.delay_object_sequence_motion_track(1, 1)
		event.reset_object_sequence_dynamic_animation(1)
		at = 9
		wait.frames(60)
		event.set_object_sequence_motion(1, "きょろきょろ歩き", 2)
		event.queue_object_sequence_next_motion(1, "歩き", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目～ひき目")
		event.set_object_sequence_texture_animation(1, 1, "通常口パク")
		voice_id = 2570010
		event.open_voice_stream_wave(1, voice_id)
		while true do
			voice_open_state = event.get_voice_stream_open_state() or voice_open_state
			if voice_open_state == 0 then
				break
			else
				at = 10
				vm.wait(10)
			end
		end
		event.ready_voice_stream(1)
		while true do
			voice_ready_state = event.get_voice_stream_open_state() or voice_ready_state
			if voice_ready_state == 0 then
				break
			else
				at = 11
				vm.wait(11)
			end
		end
		event.set_message_button_prompt(0, 0)
		event.open_message_window_2(0, voice_id)
		message.open(0, -1, 8, 0, 0)
		event.play_voice_stream(1)
		frame = 0
		while frame < 180 do
			character_x = vm.f32(vm.f32(vm.sin(character_angle) * character_radius) + vm.f32(268.802))
			character_z = vm.f32(vm.f32(vm.cos(character_angle) * character_radius) + vm.f32(-322.002))
			camera_x = vm.f32(vm.f32(vm.sin(camera_angle) * camera_radius) + vm.f32(268.802))
			camera_z = vm.f32(vm.f32(vm.cos(camera_angle) * camera_radius) + vm.f32(-322.002))
			look_at_x = vm.f32(vm.f32(vm.sin(look_at_angle) * look_at_radius) + vm.f32(268.802))
			look_at_z = vm.f32(vm.f32(vm.cos(look_at_angle) * look_at_radius) + vm.f32(-322.002))
			event.set_object_sequence_position(1, character_x, 791.14, character_z)
			event.set_object_sequence_rotation(1, 0.0, character_rotation, 0.0)
			event.set_camera_sequence_position(camera_x, 809.42, camera_z)
			event.set_camera_sequence_look_at(look_at_x, 815.5, look_at_z)
			frame = frame + 1
			at = 12
			vm.wait(12)
			character_angle = rainbow_butterfly_wood_butterfly_event.wrap_angle(vm.f32(character_angle - vm.f32(0.002)))
			character_rotation = rainbow_butterfly_wood_butterfly_event.wrap_angle(vm.f32(character_rotation - vm.f32(0.002)))
			camera_angle = rainbow_butterfly_wood_butterfly_event.wrap_angle(vm.f32(camera_angle - vm.f32(0.002)))
			look_at_angle = rainbow_butterfly_wood_butterfly_event.wrap_angle(vm.f32(look_at_angle - vm.f32(0.002)))
			if frame == 158 then
				event.set_object_sequence_texture_animation(1, 0, "通常口パク")
			end
		end
		message.close(0)
		event.close_voice_stream(1)
		event.set_message_button_prompt(0, 1)
		partner_angle = vm.f32(character_angle + 0.0625)
		partner_radius = vm.f32(character_radius - 100.0)
		partner_x = vm.f32(vm.f32(vm.sin(partner_angle) * partner_radius) + vm.f32(268.802))
		partner_z = vm.f32(vm.f32(vm.cos(partner_angle) * partner_radius) + vm.f32(-322.002))
		partner_rotation = 2.0
		event.set_object_sequence_position(0, partner_x, 783.25, partner_z)
		event.set_object_sequence_rotation(0, 0.0, partner_rotation, 0.0)
		event.set_object_sequence_motion(0, "キョロキョロ歩き")
		event.set_object_handle_footstep_sound(0, 17)
		frame = 0
		while frame < 90 do
			partner_angle_offset = calc.interpolate(-0.125, 0.0625, frame, 90)
			partner_angle = rainbow_butterfly_wood_butterfly_event.wrap_angle(vm.f32(character_angle + partner_angle_offset))
			partner_x = vm.f32(vm.f32(vm.sin(partner_angle) * partner_radius) + vm.f32(268.802))
			partner_z = vm.f32(vm.f32(vm.cos(partner_angle) * partner_radius) + vm.f32(-322.002))
			character_x = vm.f32(vm.f32(vm.sin(character_angle) * character_radius) + vm.f32(268.802))
			character_z = vm.f32(vm.f32(vm.cos(character_angle) * character_radius) + vm.f32(-322.002))
			camera_x = vm.f32(vm.f32(vm.sin(camera_angle) * camera_radius) + vm.f32(268.802))
			camera_z = vm.f32(vm.f32(vm.cos(camera_angle) * camera_radius) + vm.f32(-322.002))
			look_at_x = vm.f32(vm.f32(vm.sin(look_at_angle) * look_at_radius) + vm.f32(268.802))
			look_at_z = vm.f32(vm.f32(vm.cos(look_at_angle) * look_at_radius) + vm.f32(-322.002))
			event.set_object_sequence_position(0, partner_x, 783.25, partner_z)
			event.set_object_sequence_rotation(0, 0.0, partner_rotation, 0.0)
			event.set_object_sequence_position(1, character_x, 791.14, character_z)
			event.set_object_sequence_rotation(1, 0.0, character_rotation, 0.0)
			event.set_camera_sequence_position(camera_x, 809.42, camera_z)
			event.set_camera_sequence_look_at(look_at_x, 815.5, look_at_z)
			frame = frame + 1
			at = 13
			vm.wait(13)
			partner_rotation = rainbow_butterfly_wood_butterfly_event.wrap_angle(vm.f32(partner_rotation - vm.f32(0.002)))
			character_angle = rainbow_butterfly_wood_butterfly_event.wrap_angle(vm.f32(character_angle - vm.f32(0.002)))
			character_rotation = rainbow_butterfly_wood_butterfly_event.wrap_angle(vm.f32(character_rotation - vm.f32(0.002)))
			camera_angle = rainbow_butterfly_wood_butterfly_event.wrap_angle(vm.f32(camera_angle - vm.f32(0.002)))
			look_at_angle = rainbow_butterfly_wood_butterfly_event.wrap_angle(vm.f32(look_at_angle - vm.f32(0.002)))
		end
		event.play_music(0)
		event.set_object_sequence_motion(1, "立ち")
		event.set_object_sequence_motion(0, "指さす", 2)
		event.queue_object_sequence_next_motion(0, "指さすL", 4)
		at = 14
		message.show_voiced(2570020)
		event.set_object_sequence_motion(1, "右振りかえり180度（ＰＧ）", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		character_rotation = vm.f32(-2.17)
		frame = 0
		while frame < 30 do
			event.set_object_sequence_rotation(1, 0.0, character_rotation, 0.0)
			at = 15
			vm.wait(15)
			character_rotation = rainbow_butterfly_wood_butterfly_event.wrap_angle(vm.f32(character_rotation - vm.f32(0.07)))
			frame = frame + 1
		end
		at = 16
		wait.frames(30)
		message.close(0)
		event.close_voice_stream(1)
		event.set_character_active(0, mints_slot)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 11)
		event.set_camera_sequence_position(356.04, 805.96, -432.95)
		event.set_camera_sequence_look_at(414.81, 835.96, -493.23)
		frame = 0
		while frame < 240 do
			butterfly_y = calc.interpolate(vm.f32(1691.85), vm.f32(858.57), frame, 240)
			butterfly_angle = calc.interpolate(vm.f32(-3.926991), vm.f32(-1.5707964), frame, 240)
			butterfly_x = vm.f32(vm.sin(butterfly_angle) * vm.f32(1476.7))
			butterfly_z = vm.f32(vm.cos(butterfly_angle) * vm.f32(1476.7))
			butterfly_x = vm.f32(butterfly_x + vm.f32(1970.21))
			butterfly_z = vm.f32(butterfly_z + vm.f32(-576.77))
			butterfly_yaw = event.get_look_angle(butterfly_x - previous_butterfly_x, butterfly_z - previous_butterfly_z) or butterfly_yaw
			event.set_object_sequence_position(3, butterfly_x, butterfly_y, butterfly_z)
			event.set_object_sequence_rotation(3, 0.0, butterfly_yaw, 0.0)
			at = 17
			vm.wait(17)
			frame = frame + 1
			previous_butterfly_x = butterfly_x
			previous_butterfly_z = butterfly_z
		end
		event.clear_camera_sequence()
		event.set_camera_sequence_position(564.06, 1040.4275, -876.85254)
		event.set_camera_sequence_look_at(535.89, 1075.06, -944.46)
		event.move_camera_sequence_eased(648.57, 936.53, -674.03, 535.89, 1075.06, -944.46, 150, 2, 1.0)
		event.set_object_sequence_position(3, 500.0, 1100.0, -1000.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.play_sound_effect(sound_bank, 4)
		at = 18
		wait.frames(30)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(10, 128.0, 128.0, 128.0, 128.0, 30)
		at = 19
		wait.frames(240)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_character_active(1, mints_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, 11)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-242.49, 801.47, -239.88)
		event.set_camera_sequence_look_at(-175.51, 815.89, -178.94)
		event.set_object_sequence_position(0, -219.74, 784.37, -209.85)
		event.set_object_sequence_rotation(0, 0.0, -1.95, 0.0)
		event.set_object_sequence_motion(0, "上向くL", 4)
		event.set_object_sequence_position(1, -215.91, 784.38, -225.43)
		event.set_object_sequence_rotation(1, 0.0, -1.39, 0.0)
		event.set_object_sequence_motion(1, "上向くL", 4)
		event.reset_object_sequence_dynamic_animation(1)
		at = 20
		wait.frames(60)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 21
		message.show_voiced(2570030)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "上向くL")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_motion(0, "かまえる", 2)
		event.queue_object_sequence_next_motion(0, "かまえるL", 4)
		at = 22
		wait.frames(30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 23
		message.show_voiced(2570040)
		event.reset_mouth_texture_animations()
		at = 24
		wait.frames(15)
		event.set_camera_sequence_position(-212.52, 803.06, -183.32)
		event.set_camera_sequence_look_at(-203.01, 814.64, -250.93)
		event.set_object_sequence_position(0, -214.38, 784.37, -234.13)
		event.set_object_sequence_rotation(0, 0.0, 3.13, 0.0)
		event.set_object_sequence_motion(0, "かまえるL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_position(1, -202.79, 784.38, -212.64)
		event.set_object_sequence_rotation(1, 0.0, -3.07, 0.0)
		event.set_object_sequence_motion(1, "構えＬ", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目～おこり目とじ")
		event.set_character_active(1, 11)
		event.set_object_sequence_position(3, 115.96, 1381.16, -3665.01)
		event.set_object_sequence_rotation(3, 0.7853982, -0.15, 0.0)
		event.move_object_sequence(3, -243.09, 926.4, 17.21, 120)
		at = 25
		wait.frames(30)
		event.play_sound_effect(sound_bank, 5)
		at = 26
		wait.frames(30)
		event.set_object_sequence_motion(0, "蝶迫る", 2)
		event.queue_object_sequence_next_motion(0, "蝶迫るL", 4)
		event.set_object_sequence_motion(1, "構えから顔覆う", 2)
		event.queue_object_sequence_next_motion(1, "覆うＬ", 4)
		at = 27
		wait.frames(30)
		event.set_motion_blur(96)
		event.set_wind(40.0, -9.51001, 0.0, 67.609985)
		event.shake_camera_sequence_vertically(0.0, 1.0, 0.0, 30)
		at = 28
		wait.frames(30)
		event.set_motion_blur(0)
		event.set_character_active(0, 11)
		event.set_object_sequence_motion(0, "振り返る", 2)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "覆いから右回り右180", 2)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		frame = 0
		while frame < 30 do
			partner_turn_rotation = calc.interpolate(vm.f32(3.13), vm.f32(-0.15), frame, 30.0)
			character_turn_rotation = calc.interpolate(vm.f32(-3.07), vm.f32(-0.62), frame, 30.0)
			event.set_object_sequence_rotation(0, 0.0, partner_turn_rotation, 0.0)
			event.set_object_sequence_rotation(1, 0.0, character_turn_rotation, 0.0)
			at = 29
			vm.wait(29)
			frame = frame + 1
		end
		event.set_wind(-1)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目とじ～おこり目あき")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 30
		message.show_voiced(2570050)
		event.reset_mouth_texture_animations()
		event.fade_out_screen(30)
		at = 31
		wait.frames(45)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait.frames_skipping(4)
		end
		if at <= 2 then
			swap_party_slots_after_arrival_skip(sound_bank)
			wait.frames_skipping(60)
		end
		if at <= 3 then
			wait.frames_skipping(10)
		end
		if at <= 4 then
			wait.frames_skipping(20)
		end
		if at <= 5 then
			wait.frames_skipping(10)
		end
		if at <= 6 then
			wait.frames_skipping(30)
		end
		if at <= 7 then
			character_angle = vm.f32(0.116339)
			camera_angle = vm.f32(0.074309)
			look_at_angle = vm.f32(0.124094)
			character_radius = vm.f32(496.65527)
			camera_radius = vm.f32(526.85187)
			look_at_radius = vm.f32(483.53925)
			character_rotation = vm.f32(-1.63)
			character_x = vm.f32(vm.f32(vm.sin(character_angle) * character_radius) + vm.f32(268.802))
			character_z = vm.f32(vm.f32(vm.cos(character_angle) * character_radius) + vm.f32(-322.002))
			camera_x = vm.f32(vm.f32(vm.sin(camera_angle) * camera_radius) + vm.f32(268.802))
			camera_z = vm.f32(vm.f32(vm.cos(camera_angle) * camera_radius) + vm.f32(-322.002))
			look_at_x = vm.f32(vm.f32(vm.sin(look_at_angle) * look_at_radius) + vm.f32(268.802))
			look_at_z = vm.f32(vm.f32(vm.cos(look_at_angle) * look_at_radius) + vm.f32(-322.002))
		end
		if at <= 8 then
			wait.frames_skipping(60)
		end
		if at <= 9 then
			voice_id = 2570010
		end
		if at <= 11 then
			message.open_skipping(0, -1, 8, 0, 0)
			frame = 0
			character_x = vm.f32(vm.f32(vm.sin(character_angle) * character_radius) + vm.f32(268.802))
			character_z = vm.f32(vm.f32(vm.cos(character_angle) * character_radius) + vm.f32(-322.002))
			camera_x = vm.f32(vm.f32(vm.sin(camera_angle) * camera_radius) + vm.f32(268.802))
			camera_z = vm.f32(vm.f32(vm.cos(camera_angle) * camera_radius) + vm.f32(-322.002))
			look_at_x = vm.f32(vm.f32(vm.sin(look_at_angle) * look_at_radius) + vm.f32(268.802))
			look_at_z = vm.f32(vm.f32(vm.cos(look_at_angle) * look_at_radius) + vm.f32(-322.002))
			local _ = frame < 180
			frame = frame + 1
		end
		if at <= 12 then
			character_angle = rainbow_butterfly_wood_butterfly_event.apply_full_turn_round_trip(vm.f32(character_angle - vm.f32(0.002)))
			character_rotation = rainbow_butterfly_wood_butterfly_event.apply_full_turn_round_trip(vm.f32(character_rotation - vm.f32(0.002)))
			camera_angle = rainbow_butterfly_wood_butterfly_event.apply_full_turn_round_trip(vm.f32(camera_angle - vm.f32(0.002)))
			look_at_angle = rainbow_butterfly_wood_butterfly_event.apply_full_turn_round_trip(vm.f32(look_at_angle - vm.f32(0.002)))
			message.close_skipping(0)
			partner_angle = vm.f32(character_angle + 0.0625)
			partner_radius = vm.f32(character_radius - 100.0)
			partner_x = vm.f32(vm.f32(vm.sin(partner_angle) * partner_radius) + vm.f32(268.802))
			partner_z = vm.f32(vm.f32(vm.cos(partner_angle) * partner_radius) + vm.f32(-322.002))
			partner_rotation = 2.0
			local _ = frame == 158
			frame = 0
			partner_angle_offset = calc.interpolate(-0.125, 0.0625, frame, 90)
			partner_angle = rainbow_butterfly_wood_butterfly_event.apply_full_turn_round_trip(vm.f32(character_angle + partner_angle_offset))
			partner_x = vm.f32(vm.f32(vm.sin(partner_angle) * partner_radius) + vm.f32(268.802))
			partner_z = vm.f32(vm.f32(vm.cos(partner_angle) * partner_radius) + vm.f32(-322.002))
			character_x = vm.f32(vm.f32(vm.sin(character_angle) * character_radius) + vm.f32(268.802))
			character_z = vm.f32(vm.f32(vm.cos(character_angle) * character_radius) + vm.f32(-322.002))
			camera_x = vm.f32(vm.f32(vm.sin(camera_angle) * camera_radius) + vm.f32(268.802))
			camera_z = vm.f32(vm.f32(vm.cos(camera_angle) * camera_radius) + vm.f32(-322.002))
			look_at_x = vm.f32(vm.f32(vm.sin(look_at_angle) * look_at_radius) + vm.f32(268.802))
			look_at_z = vm.f32(vm.f32(vm.cos(look_at_angle) * look_at_radius) + vm.f32(-322.002))
			local _ = frame < 90
			frame = frame + 1
		end
		if at <= 13 then
			partner_rotation = rainbow_butterfly_wood_butterfly_event.apply_full_turn_round_trip(vm.f32(partner_rotation - vm.f32(0.002)))
			character_angle = rainbow_butterfly_wood_butterfly_event.apply_full_turn_round_trip(vm.f32(character_angle - vm.f32(0.002)))
			character_rotation = rainbow_butterfly_wood_butterfly_event.apply_full_turn_round_trip(vm.f32(character_rotation - vm.f32(0.002)))
			camera_angle = rainbow_butterfly_wood_butterfly_event.apply_full_turn_round_trip(vm.f32(camera_angle - vm.f32(0.002)))
			look_at_angle = rainbow_butterfly_wood_butterfly_event.apply_full_turn_round_trip(vm.f32(look_at_angle - vm.f32(0.002)))
			message.show_voiced_skipping(2570020)
		end
		if at <= 14 then
			character_rotation = vm.f32(-2.17)
			frame = 0
		end
		if at <= 15 then
			character_rotation = rainbow_butterfly_wood_butterfly_event.apply_full_turn_round_trip(vm.f32(character_rotation - vm.f32(0.07)))
			local _ = frame < 30
			frame = frame + 1
			wait.frames_skipping(30)
		end
		if at <= 16 then
			message.close_skipping(0)
			frame = 0
			butterfly_y = calc.interpolate(vm.f32(1691.85), vm.f32(858.57), frame, 240)
			butterfly_angle = calc.interpolate(vm.f32(-3.926991), vm.f32(-1.5707964), frame, 240)
			butterfly_x = vm.f32(vm.sin(butterfly_angle) * vm.f32(1476.7))
			butterfly_z = vm.f32(vm.cos(butterfly_angle) * vm.f32(1476.7))
			butterfly_x = vm.f32(butterfly_x + vm.f32(1970.21))
			butterfly_z = vm.f32(butterfly_z + vm.f32(-576.77))
		end
		if at <= 17 then
			local _ = frame < 240
			frame = frame + 1
			previous_butterfly_x = butterfly_x
			previous_butterfly_z = butterfly_z
			wait.frames_skipping(30)
		end
		if at <= 18 then
			wait.frames_skipping(240)
		end
		if at <= 19 then
			wait.frames_skipping(60)
		end
		if at <= 20 then
			message.show_voiced_skipping(2570030)
		end
		if at <= 21 then
			wait.frames_skipping(30)
		end
		if at <= 22 then
			message.show_voiced_skipping(2570040)
		end
		if at <= 23 then
			wait.frames_skipping(15)
		end
		if at <= 24 then
			wait.frames_skipping(30)
		end
		if at <= 25 then
			wait.frames_skipping(30)
		end
		if at <= 26 then
			wait.frames_skipping(30)
		end
		if at <= 27 then
			wait.frames_skipping(30)
		end
		if at <= 28 then
			frame = 0
			partner_turn_rotation = calc.interpolate(vm.f32(3.13), vm.f32(-0.15), frame, 30.0)
			character_turn_rotation = calc.interpolate(vm.f32(-3.07), vm.f32(-0.62), frame, 30.0)
		end
		if at <= 29 then
			local _ = frame < 30
			frame = frame + 1
			message.show_voiced_skipping(2570050)
		end
		if at <= 30 then
			wait.frames_skipping(45)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.set_character_cloth_animation_enabled(monica_slot, 1)
	event.set_event_sprite_draw_pass(0, 0)
	unload_arrival_cutscene()
	event.show_dungeon_status_bar(1, 1.0)
	event.set_motion_blur(0)
	event.play_music(0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Loads the characters, butterfly models, item model, sprites and message file used by the butterfly split cutscene.
local function load_split_cutscene()
	local active_character: s32 = 0
	local block: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		mints_slot = 0
		monica_slot = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot)
		event.load_character_motion_pack(5, "event/e200/e260/e260_mints.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 14)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e260/e260_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 14)
	end
	if active_character == 1 then
		mints_slot = 8
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", mints_slot)
		event.load_equipment_model(5, 0, 4, "info", mints_slot)
		event.load_equipment_model(5, 0, 3, "info", mints_slot)
		event.load_equipment_model(5, 0, 2, "info", mints_slot, 14)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot)
		event.load_character_motion_pack(5, "event/e200/e260/e260_mints.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot)
		event.set_character_active(1, 14)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e260/e260_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 11)
	event.set_character_active(0, 11)
	event.load_character(5, "event/e200/e260/e260_holly.gltf", "info", 12)
	event.set_character_active(0, 12)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4, 12)
	event.set_object_sequence_object(4, 4)
	event.set_object_handle_frame_draw_flag(4, "kami", 0)
	event.load_character(5, "event/e200/e260/e260_lettr1.gltf", "info", 13)
	event.set_character_active(0, 13)
	event.attach_object_handle_to_character(5, 13)
	event.clear_object_sequence(5, 13)
	event.set_object_sequence_object(5, 5)
	event.load_character(5, "dungeon/monster/b02a1.gltf", "b02a1", 15)
	event.set_character_active(0, 15)
	event.attach_object_handle_to_character(6, 15)
	event.clear_object_sequence(6, 15)
	event.set_object_sequence_object(6, 6)
	event.load_character(5, "dungeon/monster/b02a2.gltf", "b02a2", 16)
	event.set_character_active(0, 16)
	event.attach_object_handle_to_character(7, 16)
	event.clear_object_sequence(7, 16)
	event.set_object_sequence_object(7, 7)
	event.load_character(5, "dungeon/monster/b02a3.gltf", "b02a3", 17)
	event.set_character_active(0, 17)
	event.attach_object_handle_to_character(8, 17)
	event.clear_object_sequence(8, 17)
	event.set_object_sequence_object(8, 8)
	event.load_character(5, "dungeon/monster/b02a4.gltf", "b02a4", 18)
	event.set_character_active(0, 18)
	event.attach_object_handle_to_character(9, 18)
	event.clear_object_sequence(9, 18)
	event.set_object_sequence_object(9, 9)
	event.load_character(5, "dungeon/monster/b02a5.gltf", "b02a5", 19)
	event.set_character_active(0, 19)
	event.attach_object_handle_to_character(10, 19)
	event.clear_object_sequence(10, 19)
	event.set_object_sequence_object(10, 10)
	event.load_character(5, "dungeon/monster/b02a6.gltf", "b02a6", 20)
	event.set_character_active(0, 20)
	event.attach_object_handle_to_character(11, 20)
	event.clear_object_sequence(11, 20)
	event.set_object_sequence_object(11, 11)
	event.load_character(5, "dungeon/monster/b02a7.gltf", "b02a7", 21)
	event.set_character_active(0, 21)
	event.attach_object_handle_to_character(12, 21)
	event.clear_object_sequence(12, 21)
	event.set_object_sequence_object(12, 12)
	event.load_character(5, "event/e200/e260/e260_hohikari.gltf", "info", 22)
	event.set_character_active(0, 22)
	event.attach_object_handle_to_character(13, 22)
	event.clear_object_sequence(13, 22)
	event.set_object_sequence_object(13, 13)
	event.load_character(5, "event/e200/e260/e260_hohikari1.gltf", "info", 23)
	event.set_character_active(0, 23)
	event.attach_object_handle_to_character(14, 23)
	event.clear_object_sequence(14, 23)
	event.set_object_sequence_object(14, 14)
	block = event.load_event_image_4(5, "textures/event/e200/e260/e260.json", 0) or block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e26001", block)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 416)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(20, 0)
	event.clear_object_sequence(20)
	event.set_object_sequence_object(20, 20)
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "e26002", block)
	event.set_event_sprite_color(1, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(1, 0, 0, 512, 416)
	event.set_event_sprite_size(1, 512, 416)
	event.set_event_sprite_position(1, 256, 208)
	event.set_event_sprite_draw_pass(1, 0)
	event.attach_object_handle_to_sprite(21, 1)
	event.clear_object_sequence(21)
	event.set_object_sequence_object(21, 21)
	event.reset_event_sprite(2)
	event.set_event_sprite_type(2, 0)
	event.set_event_sprite_texture(2, "e26003", block)
	event.set_event_sprite_color(2, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(2, 0, 0, 512, 416)
	event.set_event_sprite_size(2, 512, 416)
	event.set_event_sprite_position(2, 256, 208)
	event.set_event_sprite_draw_pass(2, 0)
	event.attach_object_handle_to_sprite(22, 2)
	event.clear_object_sequence(22)
	event.set_object_sequence_object(22, 22)
	event.reset_event_sprite(3)
	event.set_event_sprite_type(3, 0)
	event.set_event_sprite_texture(3, "e26004", block)
	event.set_event_sprite_color(3, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(3, 0, 0, 512.0, 416)
	event.set_event_sprite_size(3, 512, 416)
	event.set_event_sprite_position(3, 256, 208)
	event.set_event_sprite_draw_pass(3, 0)
	event.attach_object_handle_to_sprite(23, 3)
	event.clear_object_sequence(23)
	event.set_object_sequence_object(23, 23)
	event.reset_event_sprite(4)
	event.set_event_sprite_type(4, 0)
	event.set_event_sprite_texture(4, "e26005", block)
	event.set_event_sprite_color(4, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(4, 0, 0, 512.0, 416)
	event.set_event_sprite_size(4, 512, 416)
	event.set_event_sprite_position(4, 256, 208)
	event.set_event_sprite_draw_pass(4, 0)
	event.attach_object_handle_to_sprite(24, 4)
	event.clear_object_sequence(24)
	event.set_object_sequence_object(24, 24)
	event.load_message_file(0, 5, "event/e200/e260/e260_1.txt")
end

--- Reassigns the two party character slots to their post-skip values when the split cutscene is skipped.
local function swap_party_slots_after_split_skip()
	mints_slot = 0
	monica_slot = 8
	mints_slot = 8
	monica_slot = 0
end

--- Restores the party and deletes the butterfly models and sprites loaded for the split cutscene.
local function unload_split_cutscene()
	local active_character: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		event.set_character_active(1, mints_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character(monica_slot)
		event.delete_character(14)
	end
	if active_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(mints_slot)
		event.delete_character(14)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(17)
	event.delete_character(18)
	event.delete_character(19)
	event.delete_character(20)
	event.delete_character(21)
	event.delete_character(22)
	event.delete_character(23)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.set_event_sprite_draw_pass(2, 0)
	event.set_event_sprite_draw_pass(3, 0)
	event.set_event_sprite_draw_pass(4, 0)
	event.delete_event_image(0)
end

--- Plays the cutscene in which the butterfly splits into seven and the heroes receive the reward item.
local function play_split_cutscene()
	local sound_bank: s32 = 0
	local fanfare_sound_bank: s32 = 0
	local active_character: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(260, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.fade_out_screen(30)
		at = 2
		wait.frames(30)
		event.load_map_sounds(2836)
		sound_bank = event.load_sound_effect_file_2(2836) or sound_bank
		fanfare_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or fanfare_sound_bank
		event.stop_music(0)
		at = 3
		wait.frames(4)
		event.load_music(53)
		event.set_environment_music_volume(0.6)
		active_character = event.get_playable_character() or active_character
		if active_character == 2 then
			event.switch_dungeon_main_character(0)
		end
		if active_character == 3 then
			event.switch_dungeon_main_character(1)
		end
		load_split_cutscene()
		event.set_character_active(0, mints_slot)
		event.set_character_active(0, monica_slot)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.set_character_active(0, 13)
		event.set_character_active(0, 14)
		event.set_character_active(0, 15)
		event.set_character_active(0, 16)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.set_character_active(0, 19)
		event.set_character_active(0, 20)
		event.set_character_active(0, 21)
		event.set_character_active(0, 22)
		event.set_character_active(0, 23)
		event.show_dungeon_status_bar(0, 1.0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 950.0, 200.0)
		event.set_camera_sequence_look_at(0.0, 1000.0, 0.0)
		event.play_sound_effect(sound_bank, 0)
		event.fade_in_screen(30)
		at = 4
		wait.frames(30)
		event.set_character_active(1, 15)
		event.set_character_active(1, 16)
		event.set_character_active(1, 17)
		event.set_character_active(1, 18)
		event.set_character_active(1, 19)
		event.set_character_active(1, 20)
		event.set_character_active(1, 21)
		event.set_object_handle_scale(6, 0.5, 0.5, 0.5)
		event.set_object_handle_scale(7, 0.5, 0.5, 0.5)
		event.set_object_handle_scale(8, 0.5, 0.5, 0.5)
		event.set_object_handle_scale(9, 0.5, 0.5, 0.5)
		event.set_object_handle_scale(10, 0.5, 0.5, 0.5)
		event.set_object_handle_scale(11, 0.5, 0.5, 0.5)
		event.set_object_handle_scale(12, 0.5, 0.5, 0.5)
		event.set_object_sequence_position(6, 0.0, 1000.0, 200.0)
		event.set_object_sequence_rotation(6, 0.0, 3.1415927, 0.0)
		event.set_object_sequence_motion(6, "飛行", 4)
		event.set_object_sequence_position(7, 141.4, 950.0, 141.4)
		event.set_object_sequence_rotation(7, 0.0, 3.926991, 0.0)
		event.set_object_sequence_motion(7, "飛行", 4)
		event.set_object_sequence_position(8, -141.4, 950.0, 141.4)
		event.set_object_sequence_rotation(8, 0.0, 2.3561945, 0.0)
		event.set_object_sequence_motion(8, "飛行", 4)
		event.set_object_sequence_position(9, 70.7, 925.0, 170.7)
		event.set_object_sequence_rotation(9, 0.0, 3.5342917, 0.0)
		event.set_object_sequence_motion(9, "飛行", 4)
		event.set_object_sequence_position(10, 70.7, 975.0, 170.7)
		event.set_object_sequence_rotation(10, 0.0, 3.5342917, 0.0)
		event.set_object_sequence_motion(10, "飛行", 4)
		event.set_object_sequence_position(11, -70.7, 925.0, 170.7)
		event.set_object_sequence_rotation(11, 0.0, 27.488937, 0.0)
		event.set_object_sequence_motion(11, "飛行", 4)
		event.set_object_sequence_position(12, -70.7, 975.0, 170.7)
		event.set_object_sequence_rotation(12, 0.0, 27.488937, 0.0)
		event.set_object_sequence_motion(12, "飛行", 4)
		event.move_object_sequence(10, 0.0, 1000.0, 0.0, 120)
		at = 5
		wait.frames(3)
		event.move_object_sequence(11, 0.0, 1000.0, 0.0, 120)
		at = 6
		wait.frames(3)
		event.move_object_sequence(6, 0.0, 1000.0, 0.0, 120)
		at = 7
		wait.frames(3)
		event.move_object_sequence(7, 0.0, 1000.0, 0.0, 120)
		at = 8
		wait.frames(3)
		event.move_object_sequence(12, 0.0, 1000.0, 0.0, 120)
		at = 9
		wait.frames(3)
		event.move_object_sequence(9, 0.0, 1000.0, 0.0, 120)
		at = 10
		wait.frames(3)
		event.move_object_sequence(8, 0.0, 1000.0, 0.0, 120)
		at = 11
		wait.frames(60)
		event.set_character_active(1, 22)
		event.set_object_sequence_position(13, 0.0, 1000.0, 0.0)
		event.set_object_sequence_motion(13, "ホーリーの光", 6)
		event.stop_sound_effect(sound_bank, 0)
		at = 12
		object.wait_until_done(10)
		event.set_character_active(0, 19)
		at = 13
		object.wait_until_done(11)
		event.set_character_active(0, 20)
		at = 14
		object.wait_until_done(6)
		event.set_character_active(0, 15)
		at = 15
		object.wait_until_done(7)
		event.set_character_active(0, 16)
		at = 16
		object.wait_until_done(12)
		event.set_character_active(0, 21)
		at = 17
		object.wait_until_done(9)
		event.set_character_active(0, 18)
		at = 18
		object.wait_until_done(8)
		event.set_character_active(0, 17)
		event.play_sound_effect(sound_bank, 1)
		event.set_character_active(1, 12)
		event.set_character_visible(12, 1, 1, 0.05)
		event.set_object_sequence_position(4, 0.0, 980.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(4, "現れる", 4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(4, 1, "目とじ")
		event.set_character_active(1, 23)
		event.set_object_sequence_position(14, 0.0, 980.0, 0.0)
		event.set_object_sequence_rotation(14, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(14, "光MAX", 4)
		at = 19
		wait.frames(60)
		event.set_object_sequence_motion(14, "消える", 2)
		at = 20
		wait.frames(60)
		event.set_character_active(0, 22)
		event.set_character_active(0, 23)
		event.set_camera_sequence_position(0.0, 1010.0, 35.0)
		event.set_camera_sequence_look_at(0.0, 1010.0, 0.0)
		event.set_object_sequence_position(4, 0.0, 1000.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(4, 1, "目とじ")
		event.move_camera_sequence(0.0, 1025.0, 35.0, 0.0, 1025.0, 0.0, 150)
		at = 21
		wait.frames(150)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(4, 1, "目とじ～目あき")
		event.play_music(0)
		event.set_mouth_texture_animations(4, "口パク")
		at = 22
		message.show_voiced(2600010)
		event.reset_mouth_texture_animations()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-2.24, 796.76, -510.87)
		event.set_camera_sequence_look_at(-68.02, 802.26, -509.43)
		event.set_character_active(1, mints_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 14)
		event.set_character_active(0, 12)
		event.set_object_sequence_position(0, -42.69, 774.65, -517.65)
		event.set_object_sequence_rotation(0, 0.0, 2.13, 0.0)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_position(1, -28.93, 774.65, -505.13)
		event.set_object_sequence_rotation(1, 0.0, 2.61, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 23
		message.show_voiced(2600020)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(19.58, 1019.28, 33.73)
		event.set_camera_sequence_look_at(-28.59, 1038.2, -27.4)
		event.set_character_active(0, mints_slot)
		event.set_character_active(0, monica_slot)
		event.set_character_active(0, 14)
		event.set_character_active(1, 12)
		event.set_object_sequence_motion(4, "会話2", 2)
		event.queue_object_sequence_next_motion(4, "立ち")
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.set_mouth_texture_animations(4, "口パク")
		at = 24
		message.show_voiced(2600030)
		event.set_object_sequence_motion(4, "立ち")
		event.reset_mouth_texture_animations()
		at = 25
		object.wait_until_done(4)
		event.set_camera_sequence_position(-2.24, 796.76, -510.87)
		event.set_camera_sequence_look_at(-68.02, 802.26, -509.43)
		event.set_character_active(1, mints_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 14)
		event.set_character_active(0, 12)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 26
		message.show_voiced(2600040)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 27
		message.show_voiced(2600045)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(0.0, 1025.0, 35.0)
		event.set_camera_sequence_look_at(0.0, 1025.0, 0.0)
		event.set_character_active(0, mints_slot)
		event.set_character_active(0, monica_slot)
		event.set_character_active(0, 14)
		event.set_character_active(1, 12)
		event.set_object_sequence_motion(4, "うつむく", 6)
		event.queue_object_sequence_next_motion(4, "うつむくL", 6)
		event.queue_object_sequence_next_motion(4, "顔を上げる", 2)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(4, 1, "目あき～目とじ")
		event.delay_object_sequence_texture_animation_track(4, 75)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(4, 1, "目とじ～目あき")
		event.set_mouth_texture_animations(4, "口パク")
		at = 28
		message.show_voiced(2600050)
		event.reset_mouth_texture_animations()
		at = 29
		object.wait_until_done(4)
		event.set_camera_sequence_position(-2.24, 796.76, -510.87)
		event.set_camera_sequence_look_at(-68.02, 802.26, -509.43)
		event.set_character_active(1, mints_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 14)
		event.set_character_active(0, 12)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 30
		message.show_voiced(2600060)
		event.reset_mouth_texture_animations()
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(20, 128.0, 128.0, 128.0, 128.0, 15)
		at = 31
		wait.frames(15)
		event.set_character_active(0, mints_slot)
		event.set_character_active(0, monica_slot)
		event.set_character_active(0, 14)
		event.set_character_active(0, 12)
		at = 32
		message.show_voiced(2600070)
		at = 33
		message.show_voiced(2600075)
		at = 34
		message.show_voiced(2600080)
		event.set_event_sprite_draw_pass(1, 1)
		event.set_object_sequence_color(21, 128.0, 128.0, 128.0, 128.0, 15)
		at = 35
		wait.frames(15)
		event.set_event_sprite_draw_pass(0, 0)
		at = 36
		message.show_voiced(2600090)
		event.set_event_sprite_draw_pass(2, 1)
		event.set_object_sequence_color(22, 128.0, 128.0, 128.0, 128.0, 15)
		at = 37
		wait.frames(15)
		event.set_event_sprite_draw_pass(1, 0)
		at = 38
		message.show_voiced(2600100)
		at = 39
		message.show_voiced(2600110)
		at = 40
		message.show_voiced(2600115)
		event.set_event_sprite_draw_pass(3, 1)
		event.set_object_sequence_color(23, 128.0, 128.0, 128.0, 128.0, 15)
		at = 41
		wait.frames(15)
		event.set_event_sprite_draw_pass(2, 0)
		at = 42
		message.show_voiced(2600120)
		at = 43
		message.show_voiced(2600130)
		event.set_event_sprite_draw_pass(4, 1)
		event.set_object_sequence_color(24, 128.0, 128.0, 128.0, 128.0, 15)
		at = 44
		wait.frames(15)
		event.set_event_sprite_draw_pass(3, 0)
		at = 45
		message.show_voiced(2600140)
		at = 46
		message.show_voiced(2600145)
		at = 47
		message.show_voiced(2600150)
		at = 48
		message.show_voiced(2600160)
		event.set_camera_sequence_position(19.72, 819.45, -34.3)
		event.set_camera_sequence_look_at(0.0, 823.12, 0.0)
		event.set_character_active(1, mints_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 14)
		event.set_character_active(1, 12)
		event.set_object_sequence_position(0, -15.79, 795.0, 7.98)
		event.set_object_sequence_rotation(0, 0.0, 2.3, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_position(1, 0.0, 795.0, 10.0)
		event.set_object_sequence_rotation(1, 0.0, 3.1415927, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(4, 0.0, 795.0, -10.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.set_object_sequence_color(24, 128.0, 128.0, 128.0, 0.0, 15)
		at = 49
		wait.frames(15)
		event.set_event_sprite_draw_pass(4, 0)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 50
		message.show_voiced(2600170)
		event.reset_mouth_texture_animations()
		event.move_camera_sequence_angle_height_distance(0.79, -4.57, 45.0, 360)
		event.set_mouth_texture_animations(4, "口パク")
		at = 51
		message.show_voiced(2600180)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "口パク")
		at = 52
		message.show_voiced(2600190)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "口パク")
		at = 53
		message.show_voiced(2600200)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "口パク")
		at = 54
		message.show_voiced(2600210)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "口パク")
		at = 55
		message.show_voiced(2600220)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "口パク")
		at = 56
		message.show_voiced(2600230)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "口パク")
		at = 57
		message.show_voiced(2600240)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 58
		message.show_voiced(2600250)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 13)
		event.attach_character_to_frame(12, "letter", 13)
		event.set_object_sequence_motion(4, "手紙を渡す", 2)
		event.queue_object_sequence_next_motion(4, "手紙を渡すL", 4)
		event.play_sound_effect(sound_bank, 2)
		event.set_mouth_texture_animations(4, "口パク")
		at = 59
		message.show_voiced(2600260)
		event.reset_mouth_texture_animations()
		at = 60
		object.wait_until_done(4)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-2.24, 796.76, -510.87)
		event.set_camera_sequence_look_at(-68.02, 802.26, -509.43)
		event.set_character_active(0, 12)
		event.set_object_sequence_position(0, -42.69, 774.65, -517.65)
		event.set_object_sequence_rotation(0, 0.0, 2.13, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.detach_character_from_frame(13)
		event.attach_character_to_frame(monica_slot, "sword_hand", 13)
		event.set_object_sequence_position(1, -28.93, 774.65, -505.13)
		event.set_object_sequence_rotation(1, 0.0, 2.61, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(1, "封筒受け取り", 6)
		event.queue_object_sequence_next_motion(1, "封筒受け取りＬ", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.play_sound_effect(sound_bank, 3)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 61
		message.show_voiced(2600270)
		event.reset_mouth_texture_animations()
		event.pause_music()
		event.set_character_active(1, 11)
		event.set_character_position(11, -18.72, 797.98, -512.22)
		event.set_character_rotation(11, 0.0, 1.5707964, 0.0)
		event.set_character_motion(11, "発動", 6)
		at = 62
		wait.frames(2)
		event.play_sound_effect(fanfare_sound_bank, 0)
		at = 63
		wait.frames(120)
		event.play_sound_effect(sound_bank, 4)
		event.apply_message_window_preset(1, 4)
		message.set_window_mode(1, 4)
		event.set_message_item_name(1, 1, 385)
		at = 64
		message.show_and_wait(1, 10, 8, 0, 0)
		event.play_music(0)
		event.set_character_active(0, 11)
		event.detach_character_from_frame(13)
		event.set_character_active(0, 13)
		event.set_camera_sequence_position(0.0, 1017.78, 76.79)
		event.set_camera_sequence_look_at(0.0, 1025.0, 0.0)
		event.move_camera_sequence(0.0, 1025.0, 35.0, 0.0, 1025.0, 0.0, 180)
		event.set_character_active(0, mints_slot)
		event.set_character_active(0, monica_slot)
		event.set_character_active(0, 14)
		event.set_character_active(1, 12)
		event.set_object_sequence_position(4, 0.0, 1000.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.set_mouth_texture_animations(4, "口パク")
		at = 65
		message.show_voiced(2600280)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "口パク")
		at = 66
		message.show_voiced(2600290)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "口パク")
		at = 67
		message.show_voiced(2600300)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 23)
		event.set_object_sequence_position(14, 0.0, 1000.0, 0.0)
		event.set_object_sequence_rotation(14, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(14, "光る", 6)
		event.queue_object_sequence_next_motion(14, "光MAX", 4)
		event.play_sound_effect(sound_bank, 5)
		event.fade_out_music(30)
		at = 68
		wait.frames(60)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(186.87, 1388.53, 256.46)
		event.set_camera_sequence_look_at(0.0, 1025.0, 0.0)
		event.set_character_active(1, mints_slot)
		event.set_character_active(1, monica_slot)
		event.set_object_sequence_position(0, -143.38, 788.23, 56.15)
		event.set_object_sequence_rotation(0, 0.0, 2.3, 0.0)
		event.set_object_sequence_position(1, -123.21, 788.97, 62.99)
		event.set_object_sequence_rotation(1, 0.0, 2.46, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上から左", 5)
		event.set_character_active(1, 22)
		event.set_object_sequence_position(13, 0.0, 1000.0, 0.0)
		event.reset_object_sequence_motion(13)
		event.set_object_sequence_motion(13, "ホーリーの光", 6)
		at = 69
		wait.frames(60)
		event.set_character_active(0, 12)
		event.set_character_active(0, 23)
		event.set_character_active(1, 15)
		event.set_character_active(1, 16)
		event.set_character_active(1, 17)
		event.set_character_active(1, 18)
		event.set_character_active(1, 19)
		event.set_character_active(1, 20)
		event.set_character_active(1, 21)
		event.set_object_sequence_position(6, 0.0, 1000.0, 0.0)
		event.set_object_sequence_rotation(6, 0.0, 0.7853982, 0.0)
		event.set_object_sequence_position(7, 0.0, 1000.0, 0.0)
		event.set_object_sequence_rotation(7, 0.0, 1.5707964, 0.0)
		event.set_object_sequence_position(8, 0.0, 1000.0, 0.0)
		event.set_object_sequence_rotation(8, 0.0, 2.3561945, 0.0)
		event.set_object_sequence_position(9, 0.0, 1000.0, 0.0)
		event.set_object_sequence_rotation(9, 0.0, 3.1415927, 0.0)
		event.set_object_sequence_position(10, 0.0, 1000.0, 0.0)
		event.set_object_sequence_rotation(10, 0.0, -2.3561945, 0.0)
		event.set_object_sequence_position(11, 0.0, 1000.0, 0.0)
		event.set_object_sequence_rotation(11, 0.0, -1.5707964, 0.0)
		event.set_object_sequence_position(12, 0.0, 1000.0, 0.0)
		event.set_object_sequence_rotation(12, 0.0, -0.7853982, 0.0)
		event.move_object_sequence(6, 353.55338, 1000.0, 353.55338, 120)
		event.move_object_sequence(7, 500.0, 1000.0, 0.0, 120)
		event.move_object_sequence(8, 353.55338, 1000.0, -353.55338, 120)
		event.move_object_sequence(9, 0.0, 1000.0, -500.0, 120)
		event.move_object_sequence(10, -353.55338, 1000.0, -353.55338, 120)
		event.move_object_sequence(11, -500.0, 1000.0, 0.0, 120)
		event.move_object_sequence(12, -353.55338, 1000.0, 353.55338, 120)
		event.play_sound_effect(sound_bank, 6)
		at = 70
		wait.frames(150)
		event.set_character_active(0, 15)
		event.set_character_active(0, 16)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.set_character_active(0, 19)
		event.set_character_active(0, 20)
		event.set_character_active(0, 21)
		event.set_character_active(0, 22)
		event.set_camera_sequence_position(-2.24, 796.76, -510.87)
		event.set_camera_sequence_look_at(-68.02, 802.26, -509.43)
		event.set_environment_music_volume(1.0)
		event.set_character_active(1, mints_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 14)
		event.set_object_sequence_position(0, -42.69, 774.65, -517.65)
		event.set_object_sequence_rotation(0, 0.0, 2.49, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_motion(0, "上向くL", 4)
		event.set_object_sequence_position(1, -28.93, 774.65, -505.13)
		event.set_object_sequence_rotation(1, 0.0, 2.61, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(1, "上から左", 5)
		at = 71
		wait.frames(90)
		event.set_object_sequence_motion(1, "上から左", 2)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 72
		message.show_voiced(2600310)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "上向く戻り", 2)
		event.queue_object_sequence_next_motion(0, "右向く", 6)
		event.wait_object_sequence_motion_end(0)
		at = 73
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "右向くうなづき", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 74
		message.show_voiced(2600320)
		event.reset_mouth_texture_animations()
		event.fade_out_screen(30)
		at = 75
		wait.frames(45)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait.frames_skipping(30)
		end
		if at <= 2 then
			wait.frames_skipping(4)
		end
		if at <= 3 then
			swap_party_slots_after_split_skip()
			wait.frames_skipping(30)
		end
		if at <= 4 then
			wait.frames_skipping(3)
		end
		if at <= 5 then
			wait.frames_skipping(3)
		end
		if at <= 6 then
			wait.frames_skipping(3)
		end
		if at <= 7 then
			wait.frames_skipping(3)
		end
		if at <= 8 then
			wait.frames_skipping(3)
		end
		if at <= 9 then
			wait.frames_skipping(3)
		end
		if at <= 10 then
			wait.frames_skipping(60)
		end
		if at <= 11 then
			cutscene.skip_command(10)
		end
		if at <= 12 then
			cutscene.skip_command(11)
		end
		if at <= 13 then
			cutscene.skip_command(6)
		end
		if at <= 14 then
			cutscene.skip_command(7)
		end
		if at <= 15 then
			cutscene.skip_command(12)
		end
		if at <= 16 then
			cutscene.skip_command(9)
		end
		if at <= 17 then
			cutscene.skip_command(8)
		end
		if at <= 18 then
			wait.frames_skipping(60)
		end
		if at <= 19 then
			wait.frames_skipping(60)
		end
		if at <= 20 then
			wait.frames_skipping(150)
		end
		if at <= 21 then
			message.show_voiced_skipping(2600010)
		end
		if at <= 22 then
			message.show_voiced_skipping(2600020)
		end
		if at <= 23 then
			message.show_voiced_skipping(2600030)
		end
		if at <= 24 then
			cutscene.skip_command(4)
		end
		if at <= 25 then
			message.show_voiced_skipping(2600040)
		end
		if at <= 26 then
			message.show_voiced_skipping(2600045)
		end
		if at <= 27 then
			message.show_voiced_skipping(2600050)
		end
		if at <= 28 then
			cutscene.skip_command(4)
		end
		if at <= 29 then
			message.show_voiced_skipping(2600060)
		end
		if at <= 30 then
			wait.frames_skipping(15)
		end
		if at <= 31 then
			message.show_voiced_skipping(2600070)
		end
		if at <= 32 then
			message.show_voiced_skipping(2600075)
		end
		if at <= 33 then
			message.show_voiced_skipping(2600080)
		end
		if at <= 34 then
			wait.frames_skipping(15)
		end
		if at <= 35 then
			message.show_voiced_skipping(2600090)
		end
		if at <= 36 then
			wait.frames_skipping(15)
		end
		if at <= 37 then
			message.show_voiced_skipping(2600100)
		end
		if at <= 38 then
			message.show_voiced_skipping(2600110)
		end
		if at <= 39 then
			message.show_voiced_skipping(2600115)
		end
		if at <= 40 then
			wait.frames_skipping(15)
		end
		if at <= 41 then
			message.show_voiced_skipping(2600120)
		end
		if at <= 42 then
			message.show_voiced_skipping(2600130)
		end
		if at <= 43 then
			wait.frames_skipping(15)
		end
		if at <= 44 then
			message.show_voiced_skipping(2600140)
		end
		if at <= 45 then
			message.show_voiced_skipping(2600145)
		end
		if at <= 46 then
			message.show_voiced_skipping(2600150)
		end
		if at <= 47 then
			message.show_voiced_skipping(2600160)
		end
		if at <= 48 then
			wait.frames_skipping(15)
		end
		if at <= 49 then
			message.show_voiced_skipping(2600170)
		end
		if at <= 50 then
			message.show_voiced_skipping(2600180)
		end
		if at <= 51 then
			message.show_voiced_skipping(2600190)
		end
		if at <= 52 then
			message.show_voiced_skipping(2600200)
		end
		if at <= 53 then
			message.show_voiced_skipping(2600210)
		end
		if at <= 54 then
			message.show_voiced_skipping(2600220)
		end
		if at <= 55 then
			message.show_voiced_skipping(2600230)
		end
		if at <= 56 then
			message.show_voiced_skipping(2600240)
		end
		if at <= 57 then
			message.show_voiced_skipping(2600250)
		end
		if at <= 58 then
			message.show_voiced_skipping(2600260)
		end
		if at <= 59 then
			cutscene.skip_command(4)
		end
		if at <= 60 then
			message.show_voiced_skipping(2600270)
		end
		if at <= 61 then
			wait.frames_skipping(2)
		end
		if at <= 62 then
			wait.frames_skipping(120)
		end
		if at <= 63 then
			message.set_window_mode_skipping(1, 4)
			message.show_and_wait_skipping(1, 10, 8, 0, 0)
		end
		if at <= 64 then
			message.show_voiced_skipping(2600280)
		end
		if at <= 65 then
			message.show_voiced_skipping(2600290)
		end
		if at <= 66 then
			message.show_voiced_skipping(2600300)
		end
		if at <= 67 then
			wait.frames_skipping(60)
		end
		if at <= 68 then
			wait.frames_skipping(60)
		end
		if at <= 69 then
			wait.frames_skipping(150)
		end
		if at <= 70 then
			wait.frames_skipping(90)
		end
		if at <= 71 then
			message.show_voiced_skipping(2600310)
		end
		if at <= 72 then
			cutscene.skip_command(0)
		end
		if at <= 73 then
			message.show_voiced_skipping(2600320)
		end
		if at <= 74 then
			wait.frames_skipping(45)
		end
		return true
	end)
	at = 76
	vm.entry(76)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 0)
	event.stop_sound_effect(fanfare_sound_bank, 0)
	event.stop_music(0)
	unload_split_cutscene()
	event.show_dungeon_status_bar(1, 1.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
script.default_event = play_arrival_cutscene

--- Disables saving, places the boss butterflies, starts the boss music and gives control to the player.
function script.start_boss_fight()
	rainbow_butterfly_wood_butterfly_event.disable_saving()
	rainbow_butterfly_wood_butterfly_event.place_boss_monsters()
	event.stop_music(0)
	wait.frames(4)
	event.load_music(31)
	event.play_music(0)
	event.set_character_position(0, -124.13, 782.88, -644.77)
	event.fade_in_screen(30)
	event.reset_follow_camera(0)
end
script[200] = script.start_boss_fight

--- Plays the arrival cutscene, then places the boss butterflies and gives control to the player.
function script.play_arrival_then_start_boss_fight()
	play_arrival_cutscene()
	rainbow_butterfly_wood_butterfly_event.disable_saving()
	rainbow_butterfly_wood_butterfly_event.place_boss_monsters()
	vm.wait(3)
	event.set_character_position(0, -124.13, 782.88, -644.77)
	event.fade_in_screen(30)
	event.reset_follow_camera(0)
end
script[500] = script.play_arrival_then_start_boss_fight

--- Plays the split cutscene, grants the reward item and returns to the previous boss floor.
function script.finish_boss_fight_and_return()
	local stage_id: s32 = 0
	local floor: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.stop_music(0)
		event.fade_out_screen(30)
		at = 1
		wait.frames(30)
		event.clear_event_battle_monsters(-1)
		stage_id = event.get_dungeon_stage_id() or stage_id
		floor = event.get_dungeon_floor() or floor
		event.set_dungeon_floor_info(stage_id, floor, 5, 2)
		at = 2
		play_split_cutscene()
		event.add_inventory_item(385)
		at = 3
		inventory.resolve_overflow_alt(0)
		event.skip_next_music_load()
		event.load_dungeon_map("d02b01")
		event.load_event_script("d02b01/d02b01.stb", 201)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				play_split_cutscene()
				return vm.continue_with(function()
					event.add_inventory_item(385)
					at = 3
					inventory.resolve_overflow_alt(0)
					event.skip_next_music_load()
					event.load_dungeon_map("d02b01")
					event.load_event_script("d02b01/d02b01.stb", 201)
					return
				end)
			end
			if at <= 2 then
				wait.skip_ten_frames_variant(0)
			end
			return 0
		end
		return nil
	end)
end
script[501] = script.finish_boss_fight_and_return

--- Shows a hint that the butterfly separated into seven and can be caught one by one.
function script.show_split_butterflies_hint()
	event.initialize_event()
	event.set_dungeon_pause_flags(3, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "La mariposa se ha dividido en\nsiete. [UNI00a1]Acaba con ellas de una\nen una!")
	message.show_and_wait(0, -1, 5, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(3, 0)
	event.finish_event()
end
script[502] = script.show_split_butterflies_hint

--- Shows a hint that the butterflies flee from noise and movement.
function script.show_sneak_up_hint()
	event.initialize_event()
	event.set_dungeon_pause_flags(3, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		"El ruido y el movimiento ahuyentan a las\n mariposas. Si no te acercas en silencio,\nescapar[UNI00e1]n."
	)
	message.show_and_wait(0, -1, 5, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(3, 0)
	event.finish_event()
end
script[503] = script.show_sneak_up_hint

--- Shows a hint that the butterflies must be defeated in a certain order.
function script.show_defeat_order_hint()
	event.initialize_event()
	event.set_dungeon_pause_flags(3, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "Tienes que vencerlas en un\n cierto orden. Piensa en el\narco iris...")
	message.show_and_wait(0, -1, 5, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(3, 0)
	event.finish_event()
end
script[504] = script.show_defeat_order_hint

--- Shows a hint that the butterflies are defeated in rainbow color order starting with red.
function script.show_rainbow_order_hint()
	event.initialize_event()
	event.set_dungeon_pause_flags(3, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "V[UNI00e9]ncelas siguiendo el orden de los\ncolores del arco iris. El primero es\nel rojo.")
	message.show_and_wait(0, -1, 5, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(3, 0)
	event.finish_event()
end
script[505] = script.show_rainbow_order_hint

--- Holds the camera on an overview of the arena for a few seconds.
function script.cutscene_overview_camera()
	event.set_dungeon_pause_flags(3, 1)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(665.3, 1226.64, 776.05)
	event.set_camera_sequence_look_at(426.01, 939.19, -311.58)
	wait.frames(300)
	event.set_dungeon_pause_flags(3, 0)
end
script[506] = script.cutscene_overview_camera

--- Shows hints that attacks do not work and the Lafrescia flower may hold a clue.
function script.show_nothing_works_hint()
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.set_dungeon_pause_flags(1, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "[(!)]La Mariposa Arco Iris parece\n invencible.\n Ser[UNI00e1] mejor que cambies\n de plan.")
	message.show_and_wait(0, -1, 5, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]La Mariposa Arco Iris apareci[UNI00f3] en cuanto\n floreci[UNI00f3] la Lafrescia... Seguro que\n la flor encierra la clave\n para vencerla."
	)
	message.show_and_wait(0, -1, 5, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end
script[507] = script.show_nothing_works_hint

--- Starts the music on channel 0.
function script.play_music_channel_0()
	event.play_music(0)
end
script[510] = script.play_music_channel_0

--- Starts the music on channel 1.
function script.play_music_channel_1()
	event.play_music(1)
end
script[511] = script.play_music_channel_1

--- Stops the music on channel 0.
function script.stop_music_channel_0()
	event.stop_music(0)
end
script[512] = script.stop_music_channel_0

--- Stops the music on channel 1.
function script.stop_music_channel_1()
	event.stop_music(1)
end
script[513] = script.stop_music_channel_1

--- Runs the defeat sequence when the player loses the fight.
function script.on_player_defeated()
	dungeon.run_defeat_sequence_with_message_silent(0)
end
script[1200] = script.on_player_defeated

--- Loads the previous boss floor and runs its event 12551.
function script.forward_event_12551_to_previous_floor()
	event.load_dungeon_map("d02b01")
	event.load_event_script("d02b01/d02b01.stb", 12551)
end
script[12551] = script.forward_event_12551_to_previous_floor

--- Loads the previous boss floor and runs its event 12552.
function script.forward_event_12552_to_previous_floor()
	event.load_dungeon_map("d02b01")
	event.load_event_script("d02b01/d02b01.stb", 12552)
end
script[12552] = script.forward_event_12552_to_previous_floor

--- Loads the previous boss floor and runs its event 12560.
function script.forward_event_12560_to_previous_floor()
	event.load_dungeon_map("d02b01")
	event.load_event_script("d02b01/d02b01.stb", 12560)
end
script[12560] = script.forward_event_12560_to_previous_floor

--- Event 12570, which map data, a script or the engine runs by number.
script.play_arrival_cutscene = play_arrival_cutscene
script[12570] = script.play_arrival_cutscene

--- Event 12600, which map data, a script or the engine runs by number.
script.play_split_cutscene = play_split_cutscene
script[12600] = script.play_split_cutscene

return script
