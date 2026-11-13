--!strict
--- Operations room with the arrival and Georama cutscenes.

local vm = require("@lib/vm")
local georama = require("@lib/event/georama")
local operations_room = require("@lib/event/operations_room")
local wait = require("@lib/event/wait")
local workshop_villagers = require("@lib/event/english/workshop_villagers")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.initialize_map() end
script[99] = script.initialize_map

--- Plays the pending cutscenes then places the player.
function script.default_event()
	local flag_524: s32 = 0
	local cutscene_played: s32 = 0
	local flag_536: s32 = 0
	local character_slot: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		cutscene_played = 0
		flag_524 = event.get_save_flag(524) or flag_524
		if flag_524 == 0 then
			cutscene_played = 1
			event.add_inventory_item(354, 1)
			resume_step = 1
			operations_room.play_e524_cutscene()
		end
		if georama.can_start_event_560() ~= 0 then
			cutscene_played = 1
			event.add_inventory_item(82, 1)
			resume_step = 2
			operations_room.play_e560_cutscene()
		end
		if cutscene_played == 1 then
			return
		end
		flag_536 = event.get_save_flag(536) or flag_536
		if flag_536 ~= 0 then
			character_slot = event.get_character_slot_by_number(400) or character_slot
			event.set_character_active(0, character_slot)
		end
		event.set_character_position(0, 0.0, 30.0, -180.0)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.reset_follow_camera(1, 0.0, 10.0)
		event.fade_in_screen(15)
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				local _ = georama.can_start_placeholder_event_c()
				cutscene_played = 1
				resume_step = 2
				operations_room.play_e560_cutscene()
				return vm.continue_with(function()
					if cutscene_played == 1 then
						return
					end
					flag_536 = event.get_save_flag(536) or flag_536
					if flag_536 ~= 0 then
						character_slot = event.get_character_slot_by_number(400) or character_slot
						event.set_character_active(0, character_slot)
					end
					event.set_character_position(0, 0.0, 30.0, -180.0)
					event.set_character_rotation(0, 0.0, 0.0, 0.0)
					event.reset_follow_camera(1, 0.0, 10.0)
					event.fade_in_screen(15)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.key_open() end

--- Fades out and jumps to f04.
function script.leave_for_f04()
	event.fade_out_screen(15)
	wait.frames(15)
	event.jump_to_map_2(-1, "f04")
	vm.wait(2)
end
script[551] = script.leave_for_f04

--- Event 1000, which map data, a script or the engine runs by number.
script[1000] = workshop_villagers.talk_to_villager

--- Event 15240, which map data, a script or the engine runs by number.
script[15240] = operations_room.play_e524_cutscene

--- Event 15600, which map data, a script or the engine runs by number.
script[15600] = operations_room.play_e560_cutscene

return script
