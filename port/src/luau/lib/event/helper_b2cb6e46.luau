--!strict
-- Shared event helper used by 42 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_e91d3484 = require("@lib/event/helper_e91d3484")

--- Helper function.
local function helper_b2cb6e46()
	event.initialize_event()
	helper_e91d3484()
	event.fade_out_screen(0)
	vm.wait(1)
end

return helper_b2cb6e46
