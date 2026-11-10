--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_50786c75 = require("@lib/event/helper_50786c75")
local helper_8d361990 = require("@lib/event/helper_8d361990")
local helper_af0d548f = require("@lib/event/helper_af0d548f")
local helper_bf93b0e8 = require("@lib/event/helper_bf93b0e8")

--- Helper function.
local function helper_20c00eaf(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_af0d548f(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 2) or var2
	if var2 == 0 then
		helper_8d361990(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_50786c75(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_bf93b0e8(arg0, arg1)
		return
	end
end

return helper_20c00eaf
