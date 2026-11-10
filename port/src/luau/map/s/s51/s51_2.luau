--!strict
-- map/s/s51/s51_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0660a773 = require("@lib/event/helper_0660a773")
local helper_2a1e9b48 = require("@lib/event/helper_2a1e9b48")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_bce61202 = require("@lib/event/helper_bce61202")
local wait_frames = require("@lib/event/wait_frames")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_bce61202()
	event.load_dungeon_monster(523, 1)
	event.place_dungeon_monster(523, -382.5, -0.2, 120.2, 0.0, 1.61, 0.0)
	event.place_dungeon_monster(523, -428.0, -0.2, 202.7, 0.0, 1.71, 0.0)
	event.place_dungeon_monster(523, -452.5, -0.2, 287.0, 0.0, 1.98, 0.0)
	event.place_dungeon_monster(523, -324.2, -0.2, 260.5, 0.0, 2.34, 0.0)
	vm.wait(2)
	event.set_dungeon_pause_flags(16385, 1)
	event.fade_in_screen(20)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "Viser : (X)\nParer : [r1]\nAttaquer : (O)\nMagie : [l1]+(O)")
	helper_75684dd8(0, -1, 8, 0, 0)
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(30)
		at = 1
		wait_frames(30)
		event.clear_event_battle_monsters(-1)
		at = 2
		helper_0660a773()
		event.give_monica_starting_equipment(1)
		event.set_playable_character(0)
		event.set_party_member(0, 1)
		event.set_party_member(1, 0)
		event.add_inventory_item(353)
		event.add_inventory_item(311)
		event.add_inventory_item(268, 5)
		event.add_inventory_item(294, 3)
		event.add_inventory_item(298, 3)
		event.add_inventory_item(425, 3)
		event.add_inventory_item(275, 2)
		event.set_save_flag(54, 1)
		event.skip_next_music_load()
		event.go_to_georama_edit(19, 151)
		at = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_0660a773()
				return vm.continue_with(function()
					event.give_monica_starting_equipment(1)
					event.set_playable_character(0)
					event.set_party_member(0, 1)
					event.set_party_member(1, 0)
					event.add_inventory_item(353)
					event.add_inventory_item(311)
					event.add_inventory_item(268, 5)
					event.add_inventory_item(294, 3)
					event.add_inventory_item(298, 3)
					event.add_inventory_item(425, 3)
					event.add_inventory_item(275, 2)
					event.set_save_flag(54, 1)
					event.skip_next_music_load()
					event.go_to_georama_edit(19, 151)
					at = 3
					vm.wait(3)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	helper_2a1e9b48(0)
end

--- Event 10500, which map data, a script or the engine runs by number.
function script.event_10500()
	event.add_inventory_item(110)
	event.add_inventory_item(127)
	event.add_inventory_item(133)
	event.add_inventory_item(266)
	event.equip_character_item(1, 110)
	event.equip_character_item(1, 127)
	event.equip_character_item(1, 133)
	event.equip_character_item(1, 266)
	event.switch_dungeon_main_character(1)
	helper_bce61202()
	event.set_dungeon_pause_flags(16384, 1)
	event.load_dungeon_monster(523, 1)
	event.place_dungeon_monster(523, -382.5, -0.2, 120.2, 0.0, 1.61, 0.0)
	event.place_dungeon_monster(523, -428.0, -0.2, 202.7, 0.0, 1.71, 0.0)
	event.place_dungeon_monster(523, -452.5, -0.2, 287.0, 0.0, 1.98, 0.0)
	event.place_dungeon_monster(523, -324.2, -0.2, 260.5, 0.0, 2.34, 0.0)
	vm.wait(2)
	event.fade_in_screen(20)
	event.finish_event()
end

return script
