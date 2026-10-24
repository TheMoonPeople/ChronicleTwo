--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")

--- Helper function.
local function helper_d743ebd8(arg0: s32)
	event.StreamOpen3(1, arg0)
	helper_9cbdc640(1)
	event.StreamPlay(1)
end

return helper_d743ebd8
