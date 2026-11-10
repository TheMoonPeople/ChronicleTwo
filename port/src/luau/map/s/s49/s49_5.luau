--!strict
-- map/s/s49/s49_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2b8f531b = require("@lib/event/helper_2b8f531b")
local helper_99e8cb63 = require("@lib/event/helper_99e8cb63")
local wait_frames = require("@lib/event/wait_frames")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local at: number = 0
	return vm.guard(function()
		at = 1
		wait_frames(30)
		at = 2
		helper_2b8f531b()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_2b8f531b()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_2b8f531b

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_2b8f531b()
	event.skip_next_music_load()
	event.load_dungeon_map("d05b01")
	event.load_event_script("d05b01/d05b01.stb", 561)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	helper_99e8cb63()
	event.skip_next_music_load()
	event.load_dungeon_map("d05b01")
	event.load_event_script("d05b01/d05b01.stb", 571)
end

return script
