--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_1459198e = require("@lib/event/helper_1459198e")
local helper_4247fd51 = require("@lib/event/helper_4247fd51")
local helper_7518fb0c = require("@lib/event/helper_7518fb0c")
local helper_cb767b2f = require("@lib/event/helper_cb767b2f")
local helper_e07f4edb = require("@lib/event/helper_e07f4edb")

--- Helper function.
local function helper_7a73586f(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		helper_7518fb0c(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_1459198e(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_cb767b2f(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_4247fd51(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_e07f4edb(arg0, arg1)
		return
	end
end

return helper_7a73586f
