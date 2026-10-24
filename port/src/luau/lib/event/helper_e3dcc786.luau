--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_036085d7 = require("@lib/event/helper_036085d7")
local helper_854490cb = require("@lib/event/helper_854490cb")
local helper_958681f3 = require("@lib/event/helper_958681f3")
local helper_dd7cb66b = require("@lib/event/helper_dd7cb66b")

--- Helper function.
local function helper_e3dcc786(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_854490cb(arg0, arg1, 0)
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_dd7cb66b(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_036085d7(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_958681f3(arg0, arg1)
		return
	end
end

return helper_e3dcc786
