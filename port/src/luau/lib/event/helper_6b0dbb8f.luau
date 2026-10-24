--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_09d664a0 = require("@lib/event/helper_09d664a0")
local helper_195e210f = require("@lib/event/helper_195e210f")
local helper_37b85276 = require("@lib/event/helper_37b85276")
local helper_97f8e744 = require("@lib/event/helper_97f8e744")

--- Helper function.
local function helper_6b0dbb8f(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_09d664a0(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_195e210f(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_97f8e744(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_37b85276(arg0, arg1)
		return
	end
end

return helper_6b0dbb8f
