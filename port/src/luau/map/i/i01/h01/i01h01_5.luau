--!strict
--- Event script for the interior of the Palm Brinks shop house covering entries, exits and story scenes.

local vm = require("@lib/vm")
local inventory = require("@lib/event/inventory")
local palm_brinks_house = require("@lib/event/spanish/palm_brinks_house")
local palm_brinks_shop_house = require("@lib/event/palm_brinks_shop_house")
local wait = require("@lib/event/wait")

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
	event.load_event_script("i01h01/i01h01c_1.stb", 151)
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
	event.load_event_script("i01h01/i01h01b_1.stb", 500)
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
		event.load_event_script("i01h01/i01h01c_1.stb", 510)
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
	event.load_event_script("i01h01/i01h01c_1.stb", 520)
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
	wait.frames(10)
	inventory.announce_received(386, 1)
	event.add_inventory_item(386)
	inventory.resolve_overflow_alt(1)
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

--- Replays the camera gift scene.
function script.replay_camera_gift_scene()
	vm.wait(1)
	event.load_event_script("i01h01/i01h01b_1.stb", 500)
	vm.wait(2)
end
script[11051] = script.replay_camera_gift_scene

--- Replays the flashback scene.
function script.replay_flashback_scene()
	palm_brinks_shop_house.initialize_house_with_steve()
	event.set_character_active(1, 25)
	vm.wait(1)
	event.load_event_script("i01h01/i01h01b_1.stb", 510)
	vm.wait(2)
end
script[11052] = script.replay_flashback_scene

--- Resets the backpack flag and replays the backpack request scene.
function script.replay_backpack_request()
	palm_brinks_shop_house.initialize_house_with_steve()
	event.set_save_flag(20, 0)
	event.set_character_active(1, 25)
	vm.wait(1)
	event.load_event_script("i01h01/i01h01b_1.stb", 11053)
	vm.wait(2)
end
script[11053] = script.replay_backpack_request

--- Replays the scene that introduces Steve and sends the party into the dungeon.
function script.replay_steve_introduction_scene()
	palm_brinks_shop_house.initialize_house_with_steve()
	event.set_character_active(1, 25)
	vm.wait(1)
	event.load_event_script("i01h01/i01h01c_1.stb", 500)
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
	event.load_event_script("i01h01/i01h01c_1.stb", 520)
	vm.wait(2)
end
script[11083] = script.replay_steve_dungeon_trip

return script
