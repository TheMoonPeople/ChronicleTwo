--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_95a21e48 = require("@lib/event/helper_95a21e48")
local helper_a01b0778 = require("@lib/event/helper_a01b0778")
local helper_b4714303 = require("@lib/event/helper_b4714303")
local helper_d2cd91ac = require("@lib/event/helper_d2cd91ac")

--- Helper function.
local function helper_19d3006e(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_d2cd91ac(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_95a21e48(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_a01b0778(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_b4714303(arg0, arg1)
		return
	end
end

return helper_19d3006e
