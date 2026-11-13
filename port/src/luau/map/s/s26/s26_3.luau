--!strict
--- Georama tutorial and Conda letter cutscenes for the Carpenterion room, with exits to Georama and neighbouring maps.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local carpenterion_outer = require("@lib/event/carpenterion_outer")
local cutscene = require("@lib/event/cutscene")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

local max_slot: s32 = 0
local monica_slot: s32 = 0

--- Loads Max, Monica, Conda, the Geostone and the tutorial images for the Geostone explanation.
local function load_geostone_scene_actors()
	local playable_character: s32 = 0
	local image_block: s32 = 0
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		max_slot = 0
		monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e200/e254/e254_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 38)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e254/e254_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 38)
	end
	if playable_character == 1 then
		max_slot = 32
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", max_slot)
		event.load_equipment_model(5, 0, 4, "info", max_slot)
		event.load_equipment_model(5, 0, 3, "info", max_slot)
		event.load_equipment_model(5, 0, 2, "info", max_slot, 38)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e200/e254/e254_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.set_character_active(1, 38)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e254/e254_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_character(5, "event/e200/e254/e254_conda.gltf", "info", 36)
	event.set_character_active(0, 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(3, 36)
	event.set_object_sequence_object(3, 4)
	event.load_character(5, "effect/giostone.gltf", "info", 35)
	event.set_character_active(0, 35)
	event.attach_object_handle_to_character(5, 35)
	event.clear_object_sequence(4, 35)
	event.set_object_sequence_object(4, 5)
	print("00000000000000000000000000000000000000000000\n")
	event.load_event_image_4(5, "textures/menu/eventdl.json", 0)
	image_block = event.load_event_image_4(5, "textures/event/e200/e254/e254_1.json", 1) or image_block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e25401", image_block)
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
	event.set_event_sprite_texture(1, "e25402", image_block)
	event.set_event_sprite_color(1, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(1, 0, 0, 512, 416)
	event.set_event_sprite_size(1, 512, 416)
	event.set_event_sprite_position(1, 256, 208)
	event.set_event_sprite_draw_pass(1, 0)
	event.attach_object_handle_to_sprite(21, 1)
	event.clear_object_sequence(21)
	event.set_object_sequence_object(21, 21)
	print("1111111111111111111111111111111111111111111111\n")
end

--- Applies the character slot assignment of the Geostone actor loader when the explanation is skipped.
local function reset_party_slots_after_skip()
	max_slot = 0
	monica_slot = 32
	max_slot = 32
	monica_slot = 0
	print("00000000000000000000000000000000000000000000\n")
	print("1111111111111111111111111111111111111111111111\n")
end

--- Releases the characters and images loaded for the Geostone explanation.
local function unload_geostone_scene_actors()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, max_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(38)
	end
	if playable_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, max_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(max_slot)
		event.delete_character(38)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.delete_character(36)
	event.delete_character(35)
	event.delete_event_image(0)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.delete_event_image(1)
end

--- Plays the scene where Conda explains Geostones, Polyn and the Analyse command.
local function cutscene_geostone_explanation()
	local menu_value: s32 = 0
	local unused_argument: s32 = 0
	local sound_id: s32 = 0
	local stone_x: f32 = 0
	local stone_y: f32 = 0
	local stone_z: f32 = 0
	local button_pressed: s32 = 0
	local resume_step: number = 0
	vm.section(function()
		event.initialize_event()
		event.apply_message_window_preset(0, 0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(88.14, 44.81, 0.0)
		event.set_camera_sequence_look_at(0.0, 19.45, 0.0)
		event.fade_out_screen(0)
		resume_step = 1
		vm.wait(1)
		event.load_map_sounds(2239)
		sound_id = event.load_sound_effect_file_2(2239) or sound_id
		event.stop_music(0)
		resume_step = 2
		wait.frames(4)
		event.load_music(57)
		load_geostone_scene_actors()
		event.enable_drama_skip()
		event.play_music(0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(88.14, 44.81, 0.0)
		event.set_camera_sequence_look_at(0.0, 19.45, 0.0)
		event.set_character_active(1, max_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 38)
		event.set_character_active(1, 36)
		event.set_character_active(1, 35)
		event.set_object_sequence_position(0, -20.0, 0.0, 20.0)
		event.set_object_sequence_rotation(0, 0.0, 2.3561945, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_position(1, 20.0, 0.0, 20.0)
		event.set_object_sequence_rotation(1, 0.0, -2.3561945, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_position(3, -20.0, 0.0, -20.0)
		event.set_object_sequence_rotation(3, 0.0, 0.7853982, 0.0)
		event.set_object_sequence_motion(3, "ジオストーン持ち", 4)
		event.attach_character_to_frame(36, "gio", 35)
		event.fade_in_screen(30)
		resume_step = 3
		wait.frames(30)
		event.open_message_window_2(
			0,
			"Dies sind Geosteine. Sie enthalten\ndas Wissen der alten Zivilisation.<page>Legt man sie in den Reaktor, kann\nman verschiedene Dinge mit dem\nSchreinerium bauen."
		)
		resume_step = 4
		message.say_bubble(0, -1, 36, monica_slot, unused_argument)
		event.set_object_sequence_motion(3, "炉にくべる", 2)
		resume_step = 5
		wait.frames(23)
		event.play_sound_effect(sound_id, 9)
		do
			local out1, out2, out3 = event.get_object_handle_frame_position(4, "gio")
			stone_x = out1 or stone_x
			stone_y = out2 or stone_y
			stone_z = out3 or stone_z
		end
		event.detach_character_from_frame(35)
		print("x=", vm.float(stone_x), "y=", vm.float(stone_y), "z=", vm.float(stone_z), "\n")
		event.set_object_sequence_position(4, stone_x, stone_y, stone_z)
		event.jump_object_sequence(4, 0.0, 0.0, 0.0, -0.25, 30)
		resume_step = 6
		wait.frames(30)
		event.play_sound_effect(sound_id, 10)
		event.set_character_active(0, 35)
		resume_step = 7
		wait.frames(15)
		event.set_menu_value(5, 5, 74)
		menu_value = 0
		while menu_value == 0 do
			resume_step = 8
			vm.wait(8)
			menu_value = event.get_menu_value_2(8) or menu_value
		end
		event.set_menu_value(4)
		event.set_menu_value(3, 1)
		menu_value = 0
		while menu_value == 0 do
			resume_step = 9
			vm.wait(9)
			button_pressed = wait.is_button_pressed(64)
			menu_value = event.get_menu_value(7, button_pressed) or menu_value
		end
		event.set_menu_value(3, 0)
		event.set_menu_value(7)
		event.set_object_sequence_motion(3, "会話2")
		event.open_message_window_2(0, "Ah ja! Fast\nh[UNI00e4]tt ich's vergessen.")
		resume_step = 10
		message.say_bubble(0, -1, 36, monica_slot, unused_argument)
		event.open_message_window_2(
			0,
			"Geosteine liefern Informationen [UNI00fc]ber\nden Bau von Dingen und Daten f[UNI00fc]r\neine bessere Zukunft."
		)
		resume_step = 11
		message.say_bubble(0, -1, 36, monica_slot, unused_argument)
		event.set_event_map_visible(0)
		event.set_event_sprite_draw_pass(0, 2)
		event.set_object_sequence_color(20, 128.0, 128.0, 128.0, 128.0)
		event.start_crossfade(15)
		resume_step = 12
		wait.frames(15)
		event.open_message_window_2(
			0,
			'Beim Bau der neuen Welt kannst du\ndeine Fortschritte mit "Analyse" im\nGeorama-Men[UNI00fc] einsehen.'
		)
		resume_step = 13
		message.say_bubble(0, -1, 36, monica_slot, unused_argument)
		event.set_event_sprite_draw_pass(1, 2)
		event.set_object_sequence_color(21, 128.0, 128.0, 128.0, 128.0)
		event.start_crossfade(15)
		resume_step = 14
		wait.frames(15)
		event.set_event_sprite_draw_pass(0, 0)
		event.open_message_window_2(0, 'Oben rechts im Georama-Men[UNI00fc] siehst\ndu die Anzeige\n"Verbl. Polyn".')
		resume_step = 15
		message.say_bubble(0, -1, 36, monica_slot, unused_argument)
		event.open_message_window_2(0, "Zum Existieren brauchen Dinge eine\nbestimmte Energie.<page>Diese nennen wir Polyn.")
		resume_step = 16
		message.say_bubble(0, -1, 36, monica_slot, unused_argument)
		event.open_message_window_2(
			0,
			"Es kann nur eine begrenzte Menge\nPolyn im Georama-Feld geben. Das\nSchreinerium l[UNI00e4]sst ein [UNI00dc]berschreiten\ndes Maximums nicht zu.<page>Merk dir das."
		)
		resume_step = 17
		message.say_bubble(0, -1, 36, monica_slot, unused_argument)
		event.set_event_map_visible(1)
		event.set_event_sprite_draw_pass(1, 0)
		event.start_crossfade(15)
		resume_step = 18
		wait.frames(15)
		event.open_message_window_2(
			0,
			"Wenn du etwas wissen willst, kannst\ndu mich [UNI00fc]ber den Hilfe-Funk fragen.\nIch geb dir gerne Auskunft."
		)
		resume_step = 19
		message.say_bubble(0, -1, 36, monica_slot, unused_argument)
		event.open_message_window_2(0, "Den Rest [UNI00fc]berlass ich euch jungen\n Leuten. Ich geh jetzt zu dem\nZug-Dingsbums.")
		resume_step = 20
		message.say_bubble(0, -1, 36, monica_slot, unused_argument)
		event.open_message_window_2(
			0,
			"Ich bin im letzten Waggon,\nschaut mal vorbei. O. K.?<page>Braucht ihr Georamamaterialien,\nbin ich gern behilflich."
		)
		resume_step = 21
		message.say_bubble(0, -1, 36, monica_slot, unused_argument)
		event.set_camera_sequence_position(15.0, 17.57, 15.0)
		event.set_camera_sequence_look_at(-20.0, 15.0, -20.0)
		event.move_camera_sequence(4.35, 17.57, 4.35, -20.0, 15.0, -20.0, 300)
		event.set_object_sequence_motion(3, "会話2")
		event.open_message_window_2(0, "Also gut. Fangen wir an!\nBist du bereit?")
		resume_step = 22
		message.say_bubble(0, -1, 36, monica_slot, unused_argument)
		event.set_object_sequence_motion(3, "立ち")
		event.fade_out_music(30)
		event.fade_out_screen(30)
		resume_step = 23
		wait.frames(30)
	end, function(received: { any }): boolean
		if resume_step <= 1 then
			wait.frames_skipping(4)
		end
		if resume_step <= 2 then
			reset_party_slots_after_skip()
			wait.frames_skipping(30)
		end
		if resume_step <= 3 then
			message.show_then_close_variant(0, -1, 36, monica_slot, unused_argument)
		end
		if resume_step <= 4 then
			wait.frames_skipping(23)
		end
		if resume_step <= 5 then
			print("x=", vm.float(stone_x), "y=", vm.float(stone_y), "z=", vm.float(stone_z), "\n")
			wait.frames_skipping(30)
		end
		if resume_step <= 6 then
			wait.frames_skipping(15)
		end
		if resume_step <= 7 then
			menu_value = 0
		end
		if resume_step <= 8 then
			local _ = if menu_value == 0 then 1 else 0
			menu_value = 0
		end
		if resume_step <= 9 then
			button_pressed = wait.is_button_pressed_skipping(64)
			message.show_then_close_variant(0, -1, 36, monica_slot, unused_argument)
		end
		if resume_step <= 10 then
			message.show_then_close_variant(0, -1, 36, monica_slot, unused_argument)
		end
		if resume_step <= 11 then
			wait.frames_skipping(15)
		end
		if resume_step <= 12 then
			message.show_then_close_variant(0, -1, 36, monica_slot, unused_argument)
		end
		if resume_step <= 13 then
			wait.frames_skipping(15)
		end
		if resume_step <= 14 then
			message.show_then_close_variant(0, -1, 36, monica_slot, unused_argument)
		end
		if resume_step <= 15 then
			message.show_then_close_variant(0, -1, 36, monica_slot, unused_argument)
		end
		if resume_step <= 16 then
			message.show_then_close_variant(0, -1, 36, monica_slot, unused_argument)
		end
		if resume_step <= 17 then
			wait.frames_skipping(15)
		end
		if resume_step <= 18 then
			message.show_then_close_variant(0, -1, 36, monica_slot, unused_argument)
		end
		if resume_step <= 19 then
			message.show_then_close_variant(0, -1, 36, monica_slot, unused_argument)
		end
		if resume_step <= 20 then
			message.show_then_close_variant(0, -1, 36, monica_slot, unused_argument)
		end
		if resume_step <= 21 then
			message.show_then_close_variant(0, -1, 36, monica_slot, unused_argument)
		end
		if resume_step <= 22 then
			wait.frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.set_event_map_visible(1)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.set_menu_value(4)
	event.set_menu_value(7)
	unload_geostone_scene_actors()
	event.finish_event()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Loads Max, Monica, Conda and the title image for Conda's introduction scene.
local function load_conda_intro_actors()
	local playable_character: s32 = 0
	local image_block: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		max_slot = 0
		monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e200/e250/e250_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e250/e250_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 37)
	end
	if playable_character == 1 then
		max_slot = 32
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", max_slot)
		event.load_equipment_model(5, 0, 4, "info", max_slot)
		event.load_equipment_model(5, 0, 3, "info", max_slot)
		event.load_equipment_model(5, 0, 2, "info", max_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e200/e250/e250_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.load_character(5, "event/e200/e250/e250_conda.gltf", "info", 39)
	event.attach_object_handle_to_character(5, 39)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_character_active(0, 39)
	image_block = event.load_event_image_4(5, "textures/event/e200/e250/e250_1.json", 0) or image_block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e25001", image_block)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(9, 0)
	event.clear_object_sequence(9)
	event.set_object_sequence_object(9, 9)
	event.set_object_handle_frame_visible(5, "tue", 0)
	event.load_message_file(0, 5, "event/e200/e250/e250_1.txt")
end

--- Releases the characters and image loaded for Conda's introduction scene.
local function unload_conda_intro_actors()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, max_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(37)
	end
	if playable_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, max_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(max_slot)
		event.delete_character(37)
	end
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_character(39)
	event.delete_event_image(0)
end

--- Plays the scene where Conda introduces the Georama and the Carpenterion.
local function cutscene_conda_introduction()
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(2231)
		load_conda_intro_actors()
		event.stop_music(0)
		wait.frames(4)
		event.load_music(192)
		event.play_environment_music(220)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(0, 3)
		event.set_object_handle_footstep_sound(1, 3)
		event.set_save_flag(43, 1)
		event.set_function_point_enabled("", "fire-0", 0)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.set_character_active(1, max_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 39)
		event.set_camera_sequence_position(61.11, 28.64, 11.99)
		event.set_camera_sequence_look_at(34.15, 26.92, 87.57)
		event.move_camera_sequence_eased(61.11, 28.64, 11.99, -6.39, 26.92, -14.44, 90, 2, 0.2)
		event.set_object_sequence_position(0, -24.93, 0.0, -74.55)
		event.set_object_sequence_rotation(0, 0.0, -0.77, 0.0)
		event.set_object_sequence_position(1, -6.49, 0.0, -68.74)
		event.set_object_sequence_rotation(1, 0.0, -0.24, 0.0)
		event.set_object_sequence_position(5, -36.31, 0.0, -7.52)
		event.set_object_sequence_rotation(5, 0.0, 2.52, 0.0)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.move_object_sequence(0, -28.68, 0.0, -40.21, 90)
		event.rotate_object_sequence(0, 0.0, 0.19, 0.0, 30)
		event.move_object_sequence(1, -28.95, 0.0, -26.6, 90)
		event.rotate_object_sequence(1, 0.0, 0.12, 0.0, 30)
		wait.frames(90)
		event.play_music(0)
		event.set_object_sequence_texture_animation(0, 1, "うれし半口")
		event.set_object_sequence_motion(0, "立ち", 0)
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "かなりキョロキョロ", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 0)
		event.set_object_sequence_motion(5, "会話2", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		message.show_voiced(2500300)
		event.set_camera_sequence_position(-8.78, 24.17, 51.3)
		event.set_camera_sequence_look_at(-16.28, 24.17, 38.68)
		event.move_camera_sequence_eased(-8.78, 24.17, 51.3, 4.48, 24.17, 43.59, 210, 2, 0.4)
		message.show_voiced(2500310)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(61.11, 28.64, 11.99)
		event.set_camera_sequence_look_at(-6.39, 26.92, -14.44)
		message.show_voiced(2500320)
		event.set_camera_sequence_position(7.29, 21.91, 58.86)
		event.set_camera_sequence_look_at(-28.35, 17.54, 8.66)
		event.set_object_sequence_position(0, -25.04, 0.0, -22.19)
		event.set_object_sequence_rotation(0, 0.0, 1.39, 0.0)
		event.set_object_sequence_position(1, -42.75, 0.0, -17.11)
		event.set_object_sequence_rotation(1, 0.0, 0.36, 0.0)
		event.set_object_sequence_position(5, -35.97, 0.0, 6.92)
		event.set_object_sequence_rotation(5, 0.0, 2.88, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(0, "→下見立ち", 6, -1.0, 1)
		event.call_command(466, 0, "下見立ち", 4, -1.0, 1) -- retail: the handler rejects 5 arguments
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(2500330)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(5, "会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		message.show_voiced(2500340)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(2500350)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "これは？", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "これは？L", 4)
		event.delay_camera_sequence_position_track(10)
		event.move_camera_sequence_eased(7.29, 21.91, 58.86, -13.44, 17.54, 2.84, 30, 2, 0.4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(2500360)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(5, "会話2", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		message.show_voiced(2500370)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(2500380)
		event.reset_mouth_texture_animations()
		camera.wait_until_done()
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(9, 128.0, 128.0, 128.0, 128.0, 10)
		message.show_voiced(2500390)
		message.show_voiced(2500400)
		message.show_voiced(2500410)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_camera_sequence_position(52.08, 130.61, 41.85)
		event.set_camera_sequence_look_at(2.22, 22.34, 3.5)
		event.set_object_sequence_position(0, -23.71, -1.07, -19.28)
		event.set_object_sequence_rotation(0, 0.0, 0.91, 0.0)
		event.set_object_sequence_position(1, -28.62, 0.82, 11.54)
		event.set_object_sequence_rotation(1, 0.0, 1.68, 0.0)
		event.set_object_sequence_position(5, -2.8, -0.0, 32.42)
		event.set_object_sequence_rotation(5, 0.0, 3.0, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.move_camera_sequence_eased(45.54, 116.59, 36.82, -4.32, 8.32, -1.53, 330, 2, 0.4)
		message.show_voiced_for(2500420, 260)
		message.show_voiced_for(2500425, 90)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(12.93, 17.36, -15.66)
		event.set_camera_sequence_look_at(8.82, 17.73, -6.03)
		event.move_camera_sequence_eased(12.93, 17.36, -15.66, 2.22, 17.73, -16.01, 270, 2, 0.4)
		event.set_object_sequence_rotation(1, 0.0, 1.32, 0.0)
		message.show_voiced_for(2500430, 300)
		event.fade_out_music(30)
		event.set_message_window_mode(0, 8)
		event.open_message_window_2(0, "Die Georama-Erkl[UNI00e4]rung wurde\ndem Hilfe-Men[UNI00fc] hinzugef[UNI00fc]gt.")
		message.show_and_wait(0, -1, 8, 0, 0)
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		wait.frames(4)
		event.load_music(22)
		event.play_music(0)
		event.set_save_flag(43, 0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(4.11, 22.66, -17.12)
		event.set_camera_sequence_look_at(0.71, 19.07, 8.38)
		event.move_camera_sequence_eased(2.27, 22.66, -3.34, -1.12, 19.07, 22.16, 180, 2, 0.4)
		message.show_voiced_for(2500440, 210)
		message.show_voiced_for(2500450, 252)
		event.set_camera_sequence_position(-45.1, 19.94, -58.7)
		event.set_camera_sequence_look_at(-8.21, 23.23, 19.97)
		event.set_object_sequence_position(0, -34.66, 0.0, 3.86)
		event.set_object_sequence_rotation(0, 0.0, 1.15, 0.0)
		event.set_object_sequence_position(1, -22.93, -0.0, 24.09)
		event.set_object_sequence_rotation(1, 0.0, 1.8, 0.0)
		event.set_object_sequence_position(5, 21.52, -0.0, 23.04)
		event.set_object_sequence_rotation(5, 0.0, -1.96, 0.0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(1, "会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(2500460)
		event.reset_mouth_texture_animations()
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "会話", 2)
		event.queue_object_sequence_next_motion(0, "立ち", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(2500470)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "左向く", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(2500480)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(5, "会話", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		message.show_voiced(2500490)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_function_point_enabled("", "fire-0", 1)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	unload_conda_intro_actors()
	event.stop_environment_music()
	event.fade_out_screen(0)
end

--- Assigns the character slots of Max and Monica for the letter scene.
local function assign_party_slots()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		max_slot = 0
		monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e200/e280/e280_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e280/e280_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 37)
	end
	if playable_character == 1 then
		max_slot = 32
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", max_slot)
		event.load_equipment_model(5, 0, 4, "info", max_slot)
		event.load_equipment_model(5, 0, 3, "info", max_slot)
		event.load_equipment_model(5, 0, 2, "info", max_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e200/e280/e280_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e280/e280_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.load_character(5, "event/e200/e280/e280_conda.gltf", "info", 39)
	event.attach_object_handle_to_character(5, 39)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_character_active(0, 39)
	event.load_character(5, "event/e200/e280/e280_noam.gltf", "info", 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 34)
	event.load_character(5, "event/e200/e280/e280_zak.gltf", "info", 35)
	event.attach_object_handle_to_character(3, 35)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_character_active(0, 35)
	event.load_character(5, "event/e200/e280/e280_wicky.gltf", "info", 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_character_active(0, 36)
	event.load_character(5, "event/e200/e280/e280_mogri.gltf", "info", 38)
	event.attach_object_handle_to_character(6, 38)
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 6)
	event.set_character_active(0, 38)
	event.load_character(5, "event/e200/e280/e280_tobo.gltf", "info", 40)
	event.attach_object_handle_to_character(7, 40)
	event.clear_object_sequence(7)
	event.set_object_sequence_object(7, 7)
	event.set_character_active(0, 40)
	event.load_character(5, "event/e200/e280/e280_rococo.gltf", "info", 41)
	event.attach_object_handle_to_character(8, 41)
	event.clear_object_sequence(8)
	event.set_object_sequence_object(8, 8)
	event.set_character_active(0, 41)
	event.load_message_file(0, 5, "event/e200/e280/e280b_1.txt")
end

--- Applies the character slot assignment of the letter scene setup when the scene is skipped.
local function skip_assign_party_slots()
	max_slot = 0
	monica_slot = 32
	max_slot = 32
	monica_slot = 0
end

--- Finishes the letter scene and jumps to the s02 map.
local function leave_for_s02()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, max_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(37)
	end
	if playable_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, max_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(max_slot)
		event.delete_character(37)
	end
	event.delete_character(39)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(38)
	event.delete_character(40)
	event.delete_character(41)
	event.jump_to_map_3(-1, "s02", 503)
end

--- Plays the scene where a letter is opened, read aloud and discussed.
local function cutscene_read_letter()
	local sound_id: s32 = 0
	local resume_step: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		resume_step = 1
		wait.frames(4)
		event.load_music(112)
		event.load_map_sounds(2514)
		sound_id = event.load_sound_effect_file_2(2514) or sound_id
		event.play_music(0)
		assign_party_slots()
		event.enable_drama_skip()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, max_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 39)
		event.set_character_active(1, 34)
		event.set_character_active(1, 35)
		event.set_character_active(1, 36)
		event.set_character_active(1, 38)
		event.set_character_active(1, 40)
		event.set_character_active(1, 41)
		event.set_camera_sequence_position(-92.53, 119.19, 118.35)
		event.set_camera_sequence_look_at(11.54, 11.66, -7.56)
		event.set_object_sequence_position(0, -6.46, 0.0, 61.2)
		event.set_object_sequence_rotation(0, 0.0, 3.12, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_position(1, 7.05, 0.0, 67.92)
		event.set_object_sequence_rotation(1, 0.0, -2.92, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_position(5, 0.0, 0.0, -28.0)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(5, "手紙を閉じるL", 4)
		event.set_object_sequence_position(6, 23.39, 0.0, -13.65)
		event.set_object_sequence_rotation(6, 0.0, -1.08, 0.0)
		event.set_object_sequence_motion(6, "立ち", 4)
		event.set_object_sequence_position(8, 25.95, 0.0, 9.52)
		event.set_object_sequence_rotation(8, 0.0, -1.92, 0.0)
		event.set_object_sequence_motion(8, "立ち", 4)
		event.set_object_sequence_position(4, 7.8, 0.0, 25.45)
		event.set_object_sequence_rotation(4, 0.0, -2.88, 0.0)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.set_object_sequence_position(7, -14.77, 0.0, 24.05)
		event.set_object_sequence_rotation(7, 0.0, 2.68, 0.0)
		event.set_object_sequence_motion(7, "立ち", 4)
		event.set_object_sequence_position(2, -25.0, 0.0, 11.97)
		event.set_object_sequence_rotation(2, 0.0, 1.8, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_position(3, -24.95, 0.0, -10.56)
		event.set_object_sequence_rotation(3, 0.0, 0.96, 0.0)
		event.set_object_sequence_motion(3, "立ち", 4)
		event.fade_in_screen(30)
		resume_step = 2
		wait.frames(15)
		resume_step = 3
		wait.frames(90)
		event.play_sound_effect(sound_id, 16)
		event.set_object_sequence_motion(5, "手紙を開く", 2)
		event.queue_object_sequence_next_motion(5, "手紙を開くL", 4)
		resume_step = 4
		wait.frames(60)
		event.set_camera_sequence_position(0.0, 17.78, 7.71)
		event.set_camera_sequence_look_at(0.0, 17.46, 0.0)
		event.set_object_sequence_motion(5, "手紙を読む", 4)
		event.set_object_sequence_motion(6, "立ち", 4)
		event.set_object_sequence_motion(8, "ぷるぷる", 4)
		event.set_object_sequence_motion(4, "下向き立ち", 4)
		event.set_object_sequence_motion(7, "立ち", 4)
		event.set_object_sequence_motion(2, "泣く", 4)
		event.set_object_sequence_motion(3, "泣く", 4)
		event.start_crossfade(30)
		resume_step = 5
		wait.frames(15)
		resume_step = 6
		wait.frames(60)
		resume_step = 7
		message.show_voiced(2800220)
		event.set_camera_speed(0)
		event.clear_camera_sequence()
		event.move_camera_sequence_angle_height_distance_eased(-1.6, 0.32, 7.71, 250, 1, 1.0)
		event.move_camera_sequence_angle_height_distance(1.6, 0.32, 7.71, 500)
		event.delay_camera_sequence_angle_track(1)
		event.move_camera_sequence_angle_height_distance_eased(0.0, 0.32, 7.71, 250, 2, 1.0)
		event.set_message_button_prompt(0, 0)
		resume_step = 8
		message.show_voiced_with_button_prompt(2800225, -1, 16)
		resume_step = 9
		message.show_voiced_with_button_prompt(2800230, -1, 16)
		resume_step = 10
		message.show_voiced_with_button_prompt(2800240, -1, 20)
		resume_step = 11
		message.show_voiced_with_button_prompt(2800250, -1, 16)
		resume_step = 12
		message.show_voiced_with_button_prompt(2800260, -1, 16)
		resume_step = 13
		message.show_voiced_with_button_prompt(2800270, -1, 16)
		resume_step = 14
		message.show_voiced_with_button_prompt(2800275, -1, 16)
		event.set_message_button_prompt(0, 1)
		event.set_object_sequence_motion(5, "手紙を開くL")
		resume_step = 15
		camera.wait_until_done()
		resume_step = 16
		wait.frames(30)
		event.play_sound_effect(sound_id, 17)
		event.set_object_sequence_motion(5, "手紙を閉じる", 4)
		event.queue_object_sequence_next_motion(5, "手紙を閉じるL", 4)
		resume_step = 17
		wait.frames(60)
		event.set_camera_sequence_position(-92.53, 119.19, 118.35)
		event.set_camera_sequence_look_at(11.54, 11.66, -7.56)
		event.set_object_sequence_motion(6, "泣く", 4)
		event.set_object_sequence_motion(8, "泣く", 4)
		event.set_object_sequence_motion(4, "泣く", 4)
		event.set_object_sequence_motion(7, "泣く", 4)
		resume_step = 18
		wait.frames(15)
		resume_step = 19
		message.show_voiced(2800280)
		resume_step = 20
		wait.frames(30)
		event.set_object_handle_frame_visible(5, "letter", 0)
		event.set_object_handle_frame_visible(5, "letter4", 0)
		event.set_camera_sequence_position(-13.25, 21.72, -2.6)
		event.set_camera_sequence_look_at(3.29, 19.71, -29.35)
		event.set_object_sequence_motion(5, "グスッ", 4)
		resume_step = 21
		wait.frames(15)
		resume_step = 22
		message.show_voiced(2800290)
		resume_step = 23
		message.show_voiced(2800295)
		resume_step = 24
		wait.frames(30)
		event.set_camera_sequence_position(-12.64, 27.88, 28.23)
		event.set_camera_sequence_look_at(-0.15, 19.71, 58.96)
		event.set_object_sequence_motion(1, "はい？（会話リアクション）", 4, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		resume_step = 25
		wait.frames(15)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 26
		message.show_voiced(2800300)
		event.reset_mouth_texture_animations()
		resume_step = 27
		wait.frames(30)
		event.set_camera_sequence_position(-13.25, 21.72, -2.6)
		event.set_camera_sequence_look_at(3.29, 19.71, -29.35)
		event.set_object_sequence_motion(5, "座り", 4)
		resume_step = 28
		wait.frames(15)
		resume_step = 29
		message.show_voiced(2800310)
		resume_step = 30
		wait.frames(30)
		event.set_camera_sequence_position(-92.53, 119.19, 118.35)
		event.set_camera_sequence_look_at(11.54, 11.66, -7.56)
		resume_step = 31
		wait.frames(15)
		resume_step = 32
		message.show_voiced(2800320)
		resume_step = 33
		message.show_voiced(2800330)
		resume_step = 34
		wait.frames(60)
		event.set_object_sequence_motion(5, "見をのりだす", 4)
		event.queue_object_sequence_next_motion(5, "見をのりだすL", 4)
		resume_step = 35
		message.show_voiced_for(2800340, 60)
		resume_step = 36
		wait.frames(30)
		event.set_camera_sequence_position(-12.64, 27.88, 28.23)
		event.set_camera_sequence_look_at(-0.15, 19.71, 58.96)
		event.set_object_sequence_motion(1, "はい？（会話リアクション）", 4, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 37
		message.show_voiced(2800350)
		event.reset_mouth_texture_animations()
		resume_step = 38
		wait.frames(30)
		event.set_camera_sequence_position(0.0, 20.92, -6.23)
		event.set_camera_sequence_look_at(0.0, 19.86, -20.55)
		resume_step = 39
		wait.frames(15)
		resume_step = 40
		message.show_voiced(2800360)
		resume_step = 41
		wait.frames(30)
		event.set_camera_sequence_position(-5.07, 23.48, 27.69)
		event.set_camera_sequence_look_at(2.31, 23.67, 72.31)
		resume_step = 42
		wait.frames(15)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		resume_step = 43
		message.show_voiced(2800370)
		event.set_object_sequence_motion(1, "歩き")
		event.rotate_object_sequence(1, 0.0, 2.28, 0.0, 20)
		resume_step = 44
		object.wait_until_done(1)
		event.move_object_sequence(1, 29.3, 0.0, 46.07, 60)
		event.move_camera_sequence_eased(-18.11, 17.54, 36.58, -0.8, 23.67, 74.6, 480, 0, 0)
		resume_step = 45
		message.show_voiced_for(2800380, 120)
		resume_step = 46
		message.show_voiced_for(2800390, 270)
		resume_step = 47
		message.show_voiced(2800400)
	end, function(received: { any }): boolean
		if resume_step <= 1 then
			skip_assign_party_slots()
			wait.frames_skipping(15)
		end
		if resume_step <= 2 then
			wait.frames_skipping(90)
		end
		if resume_step <= 3 then
			wait.frames_skipping(60)
		end
		if resume_step <= 4 then
			wait.frames_skipping(15)
		end
		if resume_step <= 5 then
			wait.frames_skipping(60)
		end
		if resume_step <= 6 then
			message.show_voiced_skipping(2800220)
		end
		if resume_step <= 7 then
			message.show_voiced_for_frames_skipping(2800225, -1, 16)
		end
		if resume_step <= 8 then
			message.show_voiced_for_frames_skipping(2800230, -1, 16)
		end
		if resume_step <= 9 then
			message.show_voiced_for_frames_skipping(2800240, -1, 20)
		end
		if resume_step <= 10 then
			message.show_voiced_for_frames_skipping(2800250, -1, 16)
		end
		if resume_step <= 11 then
			message.show_voiced_for_frames_skipping(2800260, -1, 16)
		end
		if resume_step <= 12 then
			message.show_voiced_for_frames_skipping(2800270, -1, 16)
		end
		if resume_step <= 13 then
			message.show_voiced_for_frames_skipping(2800275, -1, 16)
		end
		if resume_step <= 14 then
			wait.background_load_skipping()
		end
		if resume_step <= 15 then
			wait.frames_skipping(30)
		end
		if resume_step <= 16 then
			wait.frames_skipping(60)
		end
		if resume_step <= 17 then
			wait.frames_skipping(15)
		end
		if resume_step <= 18 then
			message.show_voiced_skipping(2800280)
		end
		if resume_step <= 19 then
			wait.frames_skipping(30)
		end
		if resume_step <= 20 then
			wait.frames_skipping(15)
		end
		if resume_step <= 21 then
			message.show_voiced_skipping(2800290)
		end
		if resume_step <= 22 then
			message.show_voiced_skipping(2800295)
		end
		if resume_step <= 23 then
			wait.frames_skipping(30)
		end
		if resume_step <= 24 then
			wait.frames_skipping(15)
		end
		if resume_step <= 25 then
			message.show_voiced_skipping(2800300)
		end
		if resume_step <= 26 then
			wait.frames_skipping(30)
		end
		if resume_step <= 27 then
			wait.frames_skipping(15)
		end
		if resume_step <= 28 then
			message.show_voiced_skipping(2800310)
		end
		if resume_step <= 29 then
			wait.frames_skipping(30)
		end
		if resume_step <= 30 then
			wait.frames_skipping(15)
		end
		if resume_step <= 31 then
			message.show_voiced_skipping(2800320)
		end
		if resume_step <= 32 then
			message.show_voiced_skipping(2800330)
		end
		if resume_step <= 33 then
			wait.frames_skipping(60)
		end
		if resume_step <= 34 then
			message.show_voiced_for_skipping(2800340, 60)
		end
		if resume_step <= 35 then
			wait.frames_skipping(30)
		end
		if resume_step <= 36 then
			message.show_voiced_skipping(2800350)
		end
		if resume_step <= 37 then
			wait.frames_skipping(30)
		end
		if resume_step <= 38 then
			wait.frames_skipping(15)
		end
		if resume_step <= 39 then
			message.show_voiced_skipping(2800360)
		end
		if resume_step <= 40 then
			wait.frames_skipping(30)
		end
		if resume_step <= 41 then
			wait.frames_skipping(15)
		end
		if resume_step <= 42 then
			message.show_voiced_skipping(2800370)
		end
		if resume_step <= 43 then
			cutscene.skip_command(1)
		end
		if resume_step <= 44 then
			message.show_voiced_for_skipping(2800380, 120)
		end
		if resume_step <= 45 then
			message.show_voiced_for_skipping(2800390, 270)
		end
		if resume_step <= 46 then
			message.show_voiced_skipping(2800400)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.skip_next_music_load()
	leave_for_s02()
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script[99] = cutscene.noop

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing on entering the map.
function script.default_event() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = cutscene_geostone_explanation

--- Plays Conda's introduction and jumps to g01.
function script.cutscene_conda_introduction_then_enter_g01()
	cutscene_conda_introduction()
	event.fade_out_screen(0)
	vm.wait(2)
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "g01", 504)
end
script[501] = script.cutscene_conda_introduction_then_enter_g01

--- Plays the Geostone explanation and jumps to g01.
function script.cutscene_geostone_explanation_then_enter_g01()
	cutscene_geostone_explanation()
	event.jump_to_map_3(-1, "g01", 506)
	vm.wait(2)
end
script[502] = script.cutscene_geostone_explanation_then_enter_g01

--- Plays the Carpenterion exterior cutscene and jumps to s70.
function script.cutscene_carpenterion_outer()
	carpenterion_outer.play_event_e616()
	event.jump_to_map_3(-1, "s70", 532)
	vm.wait(2)
end
script[550] = script.cutscene_carpenterion_outer

--- Plays Conda's introduction and fades the screen in.
function script.cutscene_conda_introduction_on_arrival()
	cutscene_conda_introduction()
	event.fade_in_screen(30)
end
script[600] = script.cutscene_conda_introduction_on_arrival

--- Removes the letter item, plays the letter scene and fades the screen in.
function script.cutscene_letter_after_item_use()
	event.remove_item(385)
	cutscene_read_letter()
	event.fade_in_screen(30)
end
script[700] = script.cutscene_letter_after_item_use

return script
