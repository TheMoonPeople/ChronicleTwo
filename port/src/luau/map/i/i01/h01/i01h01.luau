--!strict
--- Event script for the interior of the Palm Brinks shop house covering entries, exits and story scenes.

local vm = require("@lib/vm")
local cutscene = require("@lib/event/cutscene")
local inventory = require("@lib/event/inventory")
local message = require("@lib/event/message")
local palm_brinks_shop_house = require("@lib/event/palm_brinks_shop_house")
local wait = require("@lib/event/wait")

--- Runs the house owner dialogue that depends on the repair, invention and story progress flags.
local function talk_to_house_owner(owner_slot: s32, talk_target: any)
	local flag: s32 = 0
	local item_count: s32 = 0
	local player_chara: s32 = 0
	local selected_choice: any = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	event.set_character_motion(0, "立ち", 0)
	wait.for_frame_count(9)
	flag = event.get_save_flag(7) or flag
	if flag == 1 then
		event.set_villager_ai_enabled(0, 24)
		message.set_window_mode(0, 1)
		cutscene.begin_talk(owner_slot, 0, 0)
		player_chara = event.get_player_character_slot() or player_chara
		event.open_message_window_2(0, "スティーブの調子はどうじゃ？")
		message.say_bubble(0, -1, owner_slot, player_chara, 0)
		event.set_character_motion(owner_slot, "立ち")
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.open_message_window_2(0, "ねんりょう補給\nコアのパワーアップ")
		selected_choice = message.ask_choice(0, -1, 5, 256, 208, 2, 0)
		event.set_message_window_option(0, 0, 0)
		event.set_message_bubble_tail(0, 1)
		if selected_choice == 0 then
			event.set_save_data_value(2)
			event.open_message_window_2(0, "よし、これで\n修理完了じゃ！")
			message.say_bubble(0, -1, owner_slot, player_chara, 0)
		end
		if selected_choice == 1 then
			event.fade_out_screen(25)
			wait.for_frame_count(30)
			event.open_event_menu(6, 23)
			vm.wait(7)
			event.fade_in_screen(25)
		end
		event.set_villager_ai_enabled(1, 24)
		return
	end
	flag = event.get_save_flag(107) or flag
	if flag == 1 then
		event.set_villager_ai_enabled(0, 24)
		event.open_message_window_2(
			0,
			"こんなことであきらめるのか？\nなにごともネバーギブアップじゃ。"
		)
		cutscene.talk(owner_slot, -1, 0, 0)
		event.set_villager_ai_enabled(1, 24)
		return
	end
	flag = event.get_save_flag(20) or flag
	if flag == 1 then
		vm.wait(9)
		event.load_event_script("i01h01/i01h01c.stb", 500)
		return
	end
	item_count = event.get_item_count(165) or item_count
	if item_count > 0 then
		event.set_save_flag(20, 1)
		vm.wait(10)
		event.load_event_script("i01h01/i01h01b.stb", 520)
		return
	end
	argc = event.get_item_count(224) or argc
	argc_2 = event.get_item_count(245) or argc_2
	argc_3 = event.get_item_count(227) or argc_3
	item_count = event.is_invention_created(165) or item_count
	if argc >= 20 and argc_2 >= 1 and argc_3 >= 2 and item_count ~= -1 then
		vm.wait(11)
		event.load_event_script("i01h01/i01h01b.stb", 520)
		return
	end
	flag = event.get_save_flag(19) or flag
	if flag == 1 then
		event.set_villager_ai_enabled(0, 24)
		event.open_message_window_2(
			0,
			"ここをでて、目の前にあるかぼちゃの\nかんばんの店がアイテム屋じゃ。<page>鉄クズ２０個、銅のかたまり２個、\nそれとぶあつい皮じゃぞ。\n早く買ってくるのじゃ。"
		)
		cutscene.talk(owner_slot, -1, 0, 0)
		event.set_villager_ai_enabled(1, 24)
		return
	end
	item_count = event.is_invention_created(165) or item_count
	if item_count ~= -1 then
		vm.wait(13)
		event.load_event_script("i01h01/i01h01b.stb", 520)
		return
	end
	item_count = event.has_invention_ideas(165) or item_count
	if item_count == 1 then
		vm.wait(14)
		event.load_event_script("i01h01/i01h01b.stb", 520)
		return
	end
	flag = event.get_save_flag(17) or flag
	if flag == 1 then
		vm.wait(15)
		event.load_event_script("i01h01/i01h01b.stb", 510)
		return
	end
	flag = event.get_save_flag(105) or flag
	if flag == 0 then
		event.open_message_window_2(0, "ユリス、バイトをサボるんじゃないぞ。\nわかったな！")
		cutscene.talk(owner_slot, -1, 0, 0)
		return
	end
	event.set_villager_ai_enabled(0, 24)
	event.open_message_window_2(0, "まずは自分の力で、\nやってみるのじゃ。")
	cutscene.talk(owner_slot, -1, 0, 0)
	event.open_message_window_2(0, "どうしても解らなければ、\nヒントをだしてやる。")
	cutscene.talk(owner_slot, -1, 0, 0)
	event.open_message_window_2(0, "さあ、行け！")
	cutscene.talk(owner_slot, -1, 0, 0)
	event.set_villager_ai_enabled(1, 24)
end

--- Dispatches the triggered talk event to the house owner dialogue or the Steve scene.
local function handle_talk_event()
	local owner_slot: s32 = 0
	local talk_target: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	event.set_message_window_mode(0, 1)
	owner_slot = event.get_triggered_event_data_2(13) or owner_slot
	talk_target = event.get_triggered_event_data_2(14) or talk_target
	print("[talk_chara]", talk_target, "\n")
	print("[talk_chara_id]", talk_target, "\n")
	if talk_target == 1 then
		talk_to_house_owner(owner_slot, talk_target)
	end
	if talk_target == -1 then
		flag = event.get_save_flag(6) or flag
		flag_2 = event.get_save_flag(7) or flag_2
		if flag == 1 and flag_2 == 0 then
			vm.wait(2)
			event.load_event_script("i01h01/i01h01c.stb", 520)
		end
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

--- Initializes the house with Steve and fades in.
function script.default_event()
	print("i01h01--------start event----------\n")
	palm_brinks_shop_house.initialize_house_with_steve()
	event.fade_in_screen(30)
end

--- Runs event 151 of the follow-up script instead of the default handler.
function script.key_open()
	vm.wait(1)
	event.load_event_script("i01h01/i01h01c.stb", 151)
end

--- Fixes up music and flags and goes out to the town map.
function script.exit_to_outside()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	flag = event.get_save_flag(18) or flag
	if flag == 1 then
		flag = event.get_save_flag(17) or flag
		if flag == 0 then
			event.play_music(0)
			event.set_save_flag(17, 1)
		end
	end
	flag_2 = event.get_save_flag(105) or flag_2
	flag_3 = event.get_save_flag(109) or flag_3
	flag = event.get_save_flag(56) or flag
	if flag_2 ~= 0 and flag_3 == 0 and flag == 0 then
		event.skip_next_music_load()
	end
	event.fade_out_screen(1)
	vm.wait(1)
	event.fade_in_screen(30)
	vm.wait(2)
	event.go_to_outside_map(-1, "m01")
	vm.wait(3)
end
script[200] = script.exit_to_outside

--- Hides the memo and starts the camera gift scene.
function script.start_camera_gift_scene()
	palm_brinks_shop_house.initialize_event_hiding_memo()
	event.set_function_point_enabled("", "fc_event_e108c", 0)
	print("e105a i01h01.stb-------------------\n")
	event.load_event_script("i01h01/i01h01b.stb", 500)
	vm.wait(1)
end
script[500] = script.start_camera_gift_scene

--- Loads Steve and runs the follow-up scene about fighting Flotsam again.
function script.start_flotsam_rematch_scene()
	local resume_step: number = 0
	return vm.guard(function()
		palm_brinks_shop_house.initialize_event_hiding_memo()
		event.load_character(4, "event/e100/e105/e105_steve.gltf", "info", 25)
		event.set_character_active(1, 25)
		event.set_character_active(0, 24)
		event.set_character_position(25, -120.88, -13.05, -215.36)
		event.set_character_rotation(25, 0.0, 0.0, 0.0)
		resume_step = 1
		vm.wait(1)
		print("スティーブ読み込んだ-------------\n")
		event.load_event_script("i01h01/i01h01c.stb", 510)
		print("いべんとe108b--------------\n")
		resume_step = 2
		vm.wait(2)
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				print("スティーブ読み込んだ-------------\n")
				print("いべんとe108b--------------\n")
			end
			return 0
		end
		return nil
	end)
end
script[510] = script.start_flotsam_rematch_scene

--- Hides the memo and runs the follow-up scene that sends the party into the dungeon with Steve.
function script.start_steve_dungeon_trip()
	palm_brinks_shop_house.initialize_event_hiding_memo()
	event.load_event_script("i01h01/i01h01c.stb", 520)
	vm.wait(1)
end
script[520] = script.start_steve_dungeon_trip

--- Makes the player face the trigger point and gives item 386.
function script.receive_item_386()
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	event.initialize_event()
	do
		local out1, out2, out3 = event.get_triggered_event_data_4(10)
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.delay_object_sequence_motion_track(0, 10)
	event.set_object_sequence_motion(0, "立ち")
	event.turn_object_sequence_toward(0, target_x, target_y, target_z, 10)
	wait.for_frame_count(10)
	inventory.announce_received(386, 1)
	event.add_inventory_item(386)
	inventory.resolve_overflow(1)
	palm_brinks_shop_house.initialize_event_hiding_memo()
end
script[590] = script.receive_item_386

--- Hides the memo pickup once the player owns the memo item.
function script.hide_owned_memo()
	print("event_610-------\n")
	palm_brinks_shop_house.initialize_event_hiding_memo()
end
script[610] = script.hide_owned_memo

--- Starts the dialogue with Starbre, the house owner.
function script.talk_to_starbre()
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		resume_step = 1
		vm.wait(1)
		resume_step = 2
		handle_talk_event()
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				palm_brinks_shop_house.handle_talk_event()
			end
			return 0
		end
		return nil
	end)
end
script[1000] = script.talk_to_starbre

--- Replays the camera gift scene.
function script.replay_camera_gift_scene()
	vm.wait(1)
	event.load_event_script("i01h01/i01h01b.stb", 500)
	vm.wait(2)
end
script[11051] = script.replay_camera_gift_scene

--- Replays the flashback scene.
function script.replay_flashback_scene()
	palm_brinks_shop_house.initialize_house_with_steve()
	event.set_character_active(1, 25)
	vm.wait(1)
	event.load_event_script("i01h01/i01h01b.stb", 510)
	vm.wait(2)
end
script[11052] = script.replay_flashback_scene

--- Resets the backpack flag and replays the backpack request scene.
function script.replay_backpack_request()
	palm_brinks_shop_house.initialize_house_with_steve()
	event.set_save_flag(20, 0)
	event.set_character_active(1, 25)
	vm.wait(1)
	event.load_event_script("i01h01/i01h01b.stb", 11053)
	vm.wait(2)
end
script[11053] = script.replay_backpack_request

--- Replays the scene that introduces Steve and sends the party into the dungeon.
function script.replay_steve_introduction_scene()
	palm_brinks_shop_house.initialize_house_with_steve()
	event.set_character_active(1, 25)
	vm.wait(1)
	event.load_event_script("i01h01/i01h01c.stb", 500)
	vm.wait(2)
end
script[11060] = script.replay_steve_introduction_scene

--- Sets the story flags and replays the scene that sends the party into the dungeon with Steve.
function script.replay_steve_dungeon_trip()
	event.set_party_member(2, 1)
	event.set_save_flag(25, 1)
	event.set_save_flag(108, 0)
	event.set_save_flag(103, 1)
	event.set_save_flag(107, 1)
	event.set_save_flag(7, 0)
	event.set_save_flag(6, 1)
	vm.wait(1)
	event.load_event_script("i01h01/i01h01c.stb", 520)
	vm.wait(2)
end
script[11083] = script.replay_steve_dungeon_trip

return script
