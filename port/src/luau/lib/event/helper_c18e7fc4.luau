--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_2b372cd3 = require("@lib/event/helper_2b372cd3")
local helper_33e383c4 = require("@lib/event/helper_33e383c4")
local helper_c0f63309 = require("@lib/event/helper_c0f63309")
local helper_dc9fabe4 = require("@lib/event/helper_dc9fabe4")

--- Helper function.
local function helper_c18e7fc4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_33e383c4(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_dc9fabe4(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_c0f63309(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_2b372cd3(arg0, arg1)
		return
	end
end

return helper_c18e7fc4
