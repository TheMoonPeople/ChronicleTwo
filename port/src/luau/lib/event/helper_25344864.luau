--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_1680542e = require("@lib/event/helper_1680542e")
local helper_5784baa0 = require("@lib/event/helper_5784baa0")
local helper_5cec003b = require("@lib/event/helper_5cec003b")
local helper_776d0009 = require("@lib/event/helper_776d0009")
local helper_b5252af7 = require("@lib/event/helper_b5252af7")

--- Helper function.
local function helper_25344864(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		helper_1680542e(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_5cec003b(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_776d0009(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_5784baa0(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_b5252af7(arg0, arg1)
		return
	end
end

return helper_25344864
