--!strict
-- map/m/m07/m07_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_14420026 = require("@lib/event/helper_14420026")
local wait_frames = require("@lib/event/wait_frames")

--- Event 151, which map data, a script or the engine runs by number.
local function event_151()
	local at: number = 0
	return vm.guard(function()
		at = 1
		vm.entry(1)
		event.fade_out_screen(0)
		at = 2
		vm.wait(2)
		event.set_save_flag(4, 1)
		at = 3
		helper_14420026()
		event.jump_to_map_3(-1, "s42", 500)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 2 then
				at = 3
				helper_14420026()
				return vm.continue_with(function()
					event.jump_to_map_3(-1, "s42", 500)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
function script.default_event() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_14420026

script.event_151 = event_151

--- Event 10010, which map data, a script or the engine runs by number.
function script.event_10010()
	local at: number = 0
	return vm.guard(function()
		event.stop_music(0)
		event.stop_environment_music()
		at = 1
		wait_frames(6)
		at = 2
		event_151()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				event_151()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

return script
