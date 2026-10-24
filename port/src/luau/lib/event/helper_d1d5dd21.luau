--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_09d664a0 = require("@lib/event/helper_09d664a0")
local helper_37b85276 = require("@lib/event/helper_37b85276")
local helper_b46c8644 = require("@lib/event/helper_b46c8644")
local helper_ec4c240f = require("@lib/event/helper_ec4c240f")

--- Helper function.
local function helper_d1d5dd21(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_09d664a0(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_ec4c240f(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_b46c8644(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_37b85276(arg0, arg1)
		return
	end
end

return helper_d1d5dd21
