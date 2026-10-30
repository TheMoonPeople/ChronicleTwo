--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_42079db3 = require("@lib/event/helper_42079db3")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_d793ae41 = require("@lib/event/helper_d793ae41")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_e7df8582()
	wait_frames_skipping(30)
	helper_238b5abc(1)
	helper_f018b3c0(0, -1, 8, 0, 0)
	helper_42079db3(0)
	helper_d16eef1e(0)
	helper_f018b3c0(0, -1, 5, 0, 0)
	local _ = helper_d793ae41(0, 2, 0, 1)
end

return helper_e7df8582
