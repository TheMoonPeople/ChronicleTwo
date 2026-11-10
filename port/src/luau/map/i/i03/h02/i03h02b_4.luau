--!strict
-- map/i/i03/h02/i03h02b_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_c0c9270e = require("@lib/event/helper_c0c9270e")
local helper_e254bc23 = require("@lib/event/helper_e254bc23")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_c0c9270e

--- Event 151, which map data, a script or the engine runs by number.
function script.event_151()
	local at: number = 0
	return vm.guard(function()
		at = 1
		helper_e254bc23()
		at = 2
		helper_c0c9270e()
		event.jump_to_map_3(-1, "m06", 153)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_c0c9270e()
				return vm.continue_with(function()
					event.jump_to_map_3(-1, "m06", 153)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

return script
