--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_03b4722e = require("@lib/event/helper_03b4722e")
local helper_24ef550e = require("@lib/event/helper_24ef550e")
local helper_a0b34752 = require("@lib/event/helper_a0b34752")
local helper_b20b2e7c = require("@lib/event/helper_b20b2e7c")
local helper_e05c3fdf = require("@lib/event/helper_e05c3fdf")

--- Helper function.
local function helper_448a9fc1(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_e05c3fdf(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_b20b2e7c(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_03b4722e(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_24ef550e(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_a0b34752(arg0, arg1)
		return
	end
end

return helper_448a9fc1
