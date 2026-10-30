--!strict
-- map/i/i03/h02/i03h02_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_bcc35d7c = require("@lib/event/helper_bcc35d7c")
local helper_c50beb15 = require("@lib/event/helper_c50beb15")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
function script.default_event() end

--- Event 151, which map data, a script or the engine runs by number.
function script.event_151()
	local at: number = 0
	return vm.guard(function()
		at = 1
		helper_c50beb15()
		at = 2
		helper_bcc35d7c()
		event.load_event_script("i03h02/i03h02_2.stb", 151)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_bcc35d7c()
				return vm.continue_with(function()
					event.load_event_script("i03h02/i03h02_2.stb", 151)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

return script
