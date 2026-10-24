--!strict
-- Shared event helper used by 100 scripts, translated by tools/luau/stb2luau.

local helper_12257ba0 = require("@lib/event/helper_12257ba0")
local helper_35d1d03e = require("@lib/event/helper_35d1d03e")
local helper_b862d06f = require("@lib/event/helper_b862d06f")

--- Helper function.
local function helper_ae597c40(arg0: s32, arg1: s32)
	helper_12257ba0(arg0, arg1)
	helper_35d1d03e(arg0, arg1)
	local _ = helper_b862d06f(arg0, -1, 2, 0, 0, 0)
end

return helper_ae597c40
