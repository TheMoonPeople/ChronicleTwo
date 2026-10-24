--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_7746938c = require("@lib/event/helper_7746938c")
local helper_afb3d40c = require("@lib/event/helper_afb3d40c")
local helper_c4964883 = require("@lib/event/helper_c4964883")
local helper_d6caed55 = require("@lib/event/helper_d6caed55")

--- Helper function.
local function helper_be169fcb(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_afb3d40c(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_7746938c(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_c4964883(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_d6caed55(arg0, arg1)
		return
	end
end

return helper_be169fcb
