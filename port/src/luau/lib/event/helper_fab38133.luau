--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_23ac133f = require("@lib/event/helper_23ac133f")
local helper_4337dd96 = require("@lib/event/helper_4337dd96")
local helper_5d2af1e9 = require("@lib/event/helper_5d2af1e9")
local helper_ad3cd17a = require("@lib/event/helper_ad3cd17a")
local helper_b79fe662 = require("@lib/event/helper_b79fe662")
local helper_fe3af31d = require("@lib/event/helper_fe3af31d")

--- Helper function.
local function helper_fab38133()
	local var0: s32 = 0
	var0 = event.get_chapter() or var0
	if var0 ~= 6 and var0 ~= 7 then
		helper_ad3cd17a()
	else
		helper_4337dd96()
	end
	helper_fe3af31d()
	helper_5d2af1e9()
	helper_23ac133f()
	helper_b79fe662()
end

return helper_fab38133
