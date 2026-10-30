--!strict
-- map/s/s39/s39_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5a735084 = require("@lib/event/helper_5a735084")
local helper_b450afc0 = require("@lib/event/helper_b450afc0")
local helper_dc38d801 = require("@lib/event/helper_dc38d801")
local helper_f58be482 = require("@lib/event/helper_f58be482")
local helper_fb78ba4a = require("@lib/event/helper_fb78ba4a")
local wait_frames = require("@lib/event/wait_frames")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_99() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local var1: s32 = 0
	local flag_2: s32 = 0
	local chara_id: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var1 = 0
		flag = event.get_save_flag(524) or flag
		if flag == 0 then
			var1 = 1
			event.add_inventory_item(354, 1)
			at = 1
			helper_b450afc0()
		end
		if helper_5a735084() ~= 0 then
			var1 = 1
			event.add_inventory_item(82, 1)
			at = 2
			helper_f58be482()
		end
		if var1 == 1 then
			return
		end
		flag_2 = event.get_save_flag(536) or flag_2
		if flag_2 ~= 0 then
			chara_id = event.get_character_slot_by_number(400) or chara_id
			event.set_character_active(0, chara_id)
		end
		event.set_character_position(0, 0.0, 30.0, -180.0)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.reset_follow_camera(1, 0.0, 10.0)
		event.fade_in_screen(15)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				local _ = helper_fb78ba4a()
				var1 = 1
				at = 2
				helper_f58be482()
				return vm.continue_with(function()
					if var1 == 1 then
						return
					end
					flag_2 = event.get_save_flag(536) or flag_2
					if flag_2 ~= 0 then
						chara_id = event.get_character_slot_by_number(400) or chara_id
						event.set_character_active(0, chara_id)
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
function script.key_open() end

--- Event 551, which map data, a script or the engine runs by number.
function script.event_551()
	event.fade_out_screen(15)
	wait_frames(15)
	event.jump_to_map_2(-1, "f04")
	vm.wait(2)
end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_dc38d801

--- Event 15240, which map data, a script or the engine runs by number.
script.event_15240 = helper_b450afc0

--- Event 15600, which map data, a script or the engine runs by number.
script.event_15600 = helper_f58be482

return script
