--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_5ef2ff27 = require("@lib/event/helper_5ef2ff27")
local helper_6b0de27f = require("@lib/event/helper_6b0de27f")
local helper_7d56f917 = require("@lib/event/helper_7d56f917")
local helper_911cb3e8 = require("@lib/event/helper_911cb3e8")

--- Helper function.
local function helper_0aceb7cd(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_911cb3e8(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_6b0de27f(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_5ef2ff27(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_7d56f917(arg0, arg1)
		return
	end
end

return helper_0aceb7cd
