--!strict
--- Runs the Raybrandt castle soldier chase and the time gate scene that leads to the Georama.

local vm = require("@lib/vm")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local raybrandt_castle = require("@lib/event/raybrandt_castle")
local wait = require("@lib/event/wait")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine runs it in place of its default.
function script.key_open() end

--- Plays the soldier chase scene, places the soldiers and shows the battle controls.
function script.cutscene_soldier_chase()
	raybrandt_castle.play_soldier_chase_scene()
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
	message.show_and_wait(0, -1, 8, 0, 0)
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end
script[500] = script.cutscene_soldier_chase

--- Plays the time gate scene, gives the party its items and goes to the Georama editor.
function script.cutscene_time_gate()
	local checkpoint: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(30)
		checkpoint = 1
		wait.frames(30)
		event.clear_event_battle_monsters(-1)
		checkpoint = 2
		raybrandt_castle.play_time_gate_scene()
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
		checkpoint = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if checkpoint <= 3 then
			if checkpoint <= 1 then
				checkpoint = 2
				raybrandt_castle.play_time_gate_scene()
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
					checkpoint = 3
					vm.wait(3)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[510] = script.cutscene_time_gate

--- Runs the defeat sequence with a silent message when the party is defeated.
function script.on_player_defeated()
	dungeon.run_defeat_sequence_with_message_silent(0)
end
script[1200] = script.on_player_defeated

--- Equips the starting items, switches the main character and starts the soldier chase battle.
function script.start_soldier_chase_battle()
	event.add_inventory_item(110)
	event.add_inventory_item(127)
	event.add_inventory_item(133)
	event.add_inventory_item(266)
	event.equip_character_item(1, 110)
	event.equip_character_item(1, 127)
	event.equip_character_item(1, 133)
	event.equip_character_item(1, 266)
	event.switch_dungeon_main_character(1)
	raybrandt_castle.play_soldier_chase_scene()
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
script[10500] = script.start_soldier_chase_battle

return script
