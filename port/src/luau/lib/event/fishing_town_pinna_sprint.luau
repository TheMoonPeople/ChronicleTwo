--!strict
--- Holds the prize message, villager placement, talk and cleanup helpers for the Pinna Sprint Hall.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local npc = vm.module("@lib/event/npc")

local fishing_town_pinna_sprint = {}

--- Resets the sound ports, deletes the event characters and clears the save control bits before leaving the hall.
function fishing_town_pinna_sprint.clean_up_event()
	event.initialize_sound_port(5)
	event.initialize_sound_port(8)
	event.initialize_sound_port(1)
	event.delete_character_extension_packs(0)
	event.delete_character(25)
	event.delete_character(26)
	event.delete_character(27)
	event.delete_character(28)
	event.delete_character(29)
	event.delete_character(30)
	event.delete_character(24)
	event.delete_character(8)
	event.set_save_control_bits(1, 0)
end

--- Loads and places the hall villagers, choosing characters by chapter and extra mode.
function fishing_town_pinna_sprint.place_villagers()
	local chapter: s32 = 0
	local extra_mode: s32 = 0
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.load_character_motion_pack(4, "event/e00/e70/e70_mints.gltf", "info", 0)
	event.load_character(4, "chara/p01_28a.gltf", "info", 24)
	npc.load_villager(24, 156, vm.f32(100.41), vm.f32(23.15), vm.f32(-396.44), vm.f32(0.4))
	event.load_character(4, "event/e00/e70/cup.gltf", "info", 8)
	event.set_character_active(0, 8)
	chapter = event.get_chapter() or chapter
	extra_mode = event.is_extra_mode() or extra_mode
	if extra_mode == 0 then
		npc.load_villager(25, 161, -105.0, 0.0, -340.0, vm.f32(-2.81))
	else
		npc.load_villager(25, 171, -105.0, 0.0, -340.0, vm.f32(-2.81))
	end
	if extra_mode ~= 0 or chapter < 6 then
		npc.load_villager(26, 169, -432.0, 0.0, 25.0, vm.f32(-1.4))
	else
		npc.load_villager(26, 167, -432.0, 0.0, 25.0, vm.f32(-1.4))
	end
	if extra_mode == 0 then
		if chapter < 6 then
			npc.load_villager(27, 166, vm.f32(-206.4), 0.0, vm.f32(100.9), vm.f32(1.8))
		else
			npc.load_villager(27, 165, vm.f32(-206.4), 0.0, vm.f32(100.9), vm.f32(1.8))
		end
	else
		npc.load_villager(27, 160, vm.f32(-206.4), 0.0, vm.f32(100.9), vm.f32(1.8))
	end
	if extra_mode ~= 0 or chapter < 6 then
		npc.load_villager(28, 172, -199.5, 0.0, vm.f32(126.9), vm.f32(1.63))
	else
		npc.load_villager(28, 158, 430.0, 0.0, vm.f32(1.2), vm.f32(1.49))
	end
	if extra_mode == 0 then
		npc.load_villager(29, 159, vm.f32(48.9), 0.0, vm.f32(376.2), vm.f32(3.11))
	else
		npc.load_villager(29, 162, vm.f32(48.9), 0.0, vm.f32(376.2), vm.f32(3.11))
	end
	npc.load_villager(30, 168, vm.f32(214.9), 0.0, vm.f32(-103.6), vm.f32(-1.15))
end

--- Shows a message listing three prize items, each with its number.
function fishing_town_pinna_sprint.show_prizes_message(item_1: s32, number_1: s32, item_2: s32, number_2: s32, item_3: s32, number_3: s32)
	event.apply_message_window_preset(1, 4)
	message.set_window_mode(1, 4)
	event.set_message_item_name(1, 1, item_1)
	event.set_message_item_name(1, 2, item_2)
	event.set_message_item_name(1, 3, item_3)
	event.set_message_number(1, 1, number_1)
	event.set_message_number(1, 2, number_2)
	event.set_message_number(1, 3, number_3)
	message.show(1, 9, 8, 0, 0)
end

--- Prints the talking character and starts the NPC conversation.
function fishing_town_pinna_sprint.talk_to_npc()
	local talk_character_id: s32 = 0
	local talk_character: s32 = 0
	print("talk_chara_id=", talk_character_id, "talk_chara=", talk_character, "\n")
	cutscene.talk_skipping_variant(talk_character_id, -1, 0, 0)
end

--- Deletes the event characters and jumps to map i03h05.
function fishing_town_pinna_sprint.warp_to_i03h05()
	event.delete_character_extension_packs(0)
	event.delete_character(25)
	event.delete_character(26)
	event.delete_character(27)
	event.delete_character(28)
	event.delete_character(29)
	event.delete_character(30)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(24)
	event.delete_character(8)
	event.jump_to_map_3(-1, "i03h05", 500)
end

return fishing_town_pinna_sprint
