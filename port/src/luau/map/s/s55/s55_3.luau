--!strict
-- map/s/s55/s55_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0dadb783 = require("@lib/event/helper_0dadb783")
local helper_244e9ed8 = require("@lib/event/helper_244e9ed8")
local helper_34f2af89 = require("@lib/event/helper_34f2af89")
local helper_393ea807 = require("@lib/event/helper_393ea807")
local helper_574aec8b = require("@lib/event/helper_574aec8b")
local helper_aca6764d = require("@lib/event/helper_aca6764d")
local helper_baabee9d = require("@lib/event/helper_baabee9d")
local wait_frames = require("@lib/event/wait_frames")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_99() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
function script.default_event() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	local at: number = 0
	return vm.guard(function()
		at = 1
		wait_frames(30)
		at = 2
		helper_244e9ed8()
		at = 3
		helper_baabee9d()
		at = 4
		helper_34f2af89()
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				at = 2
				helper_244e9ed8()
				return vm.continue_with(function()
					at = 3
					helper_baabee9d()
					at = 4
					helper_34f2af89()
					return
				end)
			end
			if at <= 2 then
				at = 3
				helper_baabee9d()
				return vm.continue_with(function()
					at = 4
					helper_34f2af89()
					return
				end)
			end
			if at <= 3 then
				at = 4
				helper_34f2af89()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 600, which map data, a script or the engine runs by number.
function script.event_600()
	helper_393ea807()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "f30", 601)
end

--- Event 601, which map data, a script or the engine runs by number.
function script.event_601()
	helper_574aec8b()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "f30", 602)
end

--- Event 602, which map data, a script or the engine runs by number.
function script.event_602()
	helper_aca6764d()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "f30", 603)
end

--- Event 603, which map data, a script or the engine runs by number.
function script.event_603()
	helper_0dadb783()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "f30", 604)
end

return script
