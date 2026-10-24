--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_0b09d293 = require("@lib/event/helper_0b09d293")
local helper_12b44a9d = require("@lib/event/helper_12b44a9d")
local helper_7f81ec9c = require("@lib/event/helper_7f81ec9c")
local helper_ba0971d8 = require("@lib/event/helper_ba0971d8")

--- Helper function.
local function helper_8aea5e90(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_7f81ec9c(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_0b09d293(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_ba0971d8(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_12b44a9d(arg0, arg1)
		return
	end
end

return helper_8aea5e90
