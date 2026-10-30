--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_70ea1671 = require("@lib/event/helper_70ea1671")
local helper_c436556b = require("@lib/event/helper_c436556b")
local helper_de96f74d = require("@lib/event/helper_de96f74d")
local helper_f526c22d = require("@lib/event/helper_f526c22d")

--- Helper function.
local function helper_1d33595a(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_f526c22d(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 14) or var2
	if var2 == 0 then
		helper_de96f74d(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_70ea1671(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_c436556b(arg0, arg1)
		return
	end
end

return helper_1d33595a
