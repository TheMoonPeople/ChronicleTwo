--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_1946c790 = require("@lib/event/helper_1946c790")
local helper_59940d2c = require("@lib/event/helper_59940d2c")
local helper_ca9034d5 = require("@lib/event/helper_ca9034d5")
local helper_d394e1f6 = require("@lib/event/helper_d394e1f6")
local helper_f8b96169 = require("@lib/event/helper_f8b96169")

--- Helper function.
local function helper_290052af(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_d394e1f6(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_ca9034d5(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_1946c790(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_59940d2c(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_f8b96169(arg0, arg1)
		return
	end
end

return helper_290052af
