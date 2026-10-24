--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_46f8aa3e = require("@lib/event/helper_46f8aa3e")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")

--- Helper function.
local function helper_436789d0(arg0: s32, arg1: s32)
	event.StreamOpen3(1, arg0)
	helper_9cbdc640(1)
	event.StreamPlay(1)
	helper_46f8aa3e(0, arg1)
	event.StreamClose(1)
end

return helper_436789d0
