--!strict
-- Shared event helper used by 35 scripts, translated by tools/luau/stb2luau.

local helper_672e9b88 = require("@lib/event/helper_672e9b88")
local helper_7c656a4f = require("@lib/event/helper_7c656a4f")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")
local helper_d793ae41 = require("@lib/event/helper_d793ae41")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")

--- Helper function.
local function helper_f77aacc5(arg0: s32)
	helper_f018b3c0(0, -1, 5, 0, 0)
	helper_f018b3c0(0, 2220, 5, 0, 0)
	local _ = helper_d793ae41(0, 3, 3, 0)
	helper_ee1c51d0(0, -1, 5, 0, 0)
	arg0 = helper_672e9b88(arg0, 2)
	helper_d3f20302(6)
	arg0 = helper_672e9b88(arg0, 2)
	helper_7c656a4f()
	helper_ee1c51d0(0, 2215, 5, 0, 0)
	helper_ee1c51d0(0, 2216, 5, 0, 0)
	helper_ee1c51d0(0, 2211, 5, 0, 0)
	helper_ee1c51d0(0, 2212, 5, 0, 0)
	local _ = bit32.band(arg0, 8)
	local _ = bit32.band(arg0, 16)
	local _ = bit32.band(arg0, 32)
	arg0 = helper_672e9b88(arg0, 2)
	return arg0
end

return helper_f77aacc5
