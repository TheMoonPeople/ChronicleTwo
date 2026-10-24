--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_03ce7d81 = require("@lib/event/helper_03ce7d81")
local helper_4d9adc3a = require("@lib/event/helper_4d9adc3a")
local helper_7d35f245 = require("@lib/event/helper_7d35f245")
local helper_83ea1bf2 = require("@lib/event/helper_83ea1bf2")
local helper_a5799764 = require("@lib/event/helper_a5799764")

--- Helper function.
local function helper_5a5be399(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_03ce7d81(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_83ea1bf2(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_a5799764(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_7d35f245(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_4d9adc3a(arg0, arg1)
		return
	end
end

return helper_5a5be399
