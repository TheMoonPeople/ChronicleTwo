--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_249b75d1 = require("@lib/event/helper_249b75d1")
local helper_d793ae41 = require("@lib/event/helper_d793ae41")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_3d6e13c5()
	local var0: s32 = 0
	local var15: s32 = 0
	var0 = 13
	wait_frames_skipping(20)
	helper_249b75d1(0, -1, var0, 0, 0)
	helper_f018b3c0(0, -1, 5, 0, 0)
	local _ = var15 ~= 0
	local _ = var15 ~= 0
	var15 = helper_d793ae41(0, 2, 1, 0)
	wait_frames_skipping(30)
	return 1
end

return helper_3d6e13c5
