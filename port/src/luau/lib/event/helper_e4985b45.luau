--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_46f8aa3e = require("@lib/event/helper_46f8aa3e")
local helper_6992f518 = require("@lib/event/helper_6992f518")
local helper_82705ce2 = require("@lib/event/helper_82705ce2")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")

--- Helper function.
local function helper_e4985b45(arg0: s32)
	event.StreamOpen3(1, arg0)
	helper_9cbdc640(1)
	event.MesMake_2(0, arg0)
	helper_82705ce2(0, -1, 5, 0, 0)
	event.StreamPlay(1)
	helper_46f8aa3e(0, -1)
	helper_6992f518(0)
	event.StreamClose(1)
end

return helper_e4985b45
