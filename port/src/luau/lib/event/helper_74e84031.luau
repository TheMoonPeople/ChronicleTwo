--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_12b44a9d = require("@lib/event/helper_12b44a9d")
local helper_6e06c8b1 = require("@lib/event/helper_6e06c8b1")
local helper_7f81ec9c = require("@lib/event/helper_7f81ec9c")
local helper_af721ffa = require("@lib/event/helper_af721ffa")

--- Helper function.
local function helper_74e84031(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_7f81ec9c(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_6e06c8b1(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_af721ffa(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_12b44a9d(arg0, arg1)
		return
	end
end

return helper_74e84031
