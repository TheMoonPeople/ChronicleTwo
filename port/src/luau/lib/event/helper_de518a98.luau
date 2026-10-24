--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_a0450e0f = require("@lib/event/helper_a0450e0f")

--- Helper function.
local function helper_de518a98(arg0: any, arg1: s32)
	event.StreamOpen3(1, arg0)
	helper_9cbdc640(1)
	event.StreamPlay(1)
	helper_a0450e0f(0, arg1)
	event.StreamClose(1)
end

return helper_de518a98
