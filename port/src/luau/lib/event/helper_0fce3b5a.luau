--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_2667d36d = require("@lib/event/helper_2667d36d")
local helper_50374467 = require("@lib/event/helper_50374467")
local helper_5cd2c2e6 = require("@lib/event/helper_5cd2c2e6")
local helper_a98f65f3 = require("@lib/event/helper_a98f65f3")
local helper_ee2177c3 = require("@lib/event/helper_ee2177c3")

--- Helper function.
local function helper_0fce3b5a(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_50374467(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_ee2177c3(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_5cd2c2e6(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_a98f65f3(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_2667d36d(arg0, arg1)
		return
	end
end

return helper_0fce3b5a
