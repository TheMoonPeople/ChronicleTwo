--!strict
-- Shared event helper used by 235 scripts, translated by tools/luau/stb2luau.

local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_705b02bc = require("@lib/event/helper_705b02bc")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_2f8c501c(arg0: any, arg1: s32, arg2: any)
	helper_238b5abc(1)
	helper_f018b3c0(0, -1, 8, 0, 0)
	helper_705b02bc(0, arg1)
	local _ = arg2 > 0
	wait_frames_skipping(arg2)
	helper_d16eef1e(0)
end

return helper_2f8c501c
