--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_94971139 = require("@lib/event/helper_94971139")
local helper_a16d7bae = require("@lib/event/helper_a16d7bae")
local helper_b185339a = require("@lib/event/helper_b185339a")
local helper_fc98cd99 = require("@lib/event/helper_fc98cd99")

--- Helper function.
local function helper_bd07bb63(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_fc98cd99(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_94971139(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_b185339a(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_a16d7bae(arg0, arg1)
		return
	end
end

return helper_bd07bb63
