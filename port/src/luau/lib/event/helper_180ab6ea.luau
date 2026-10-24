--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_8f4669aa = require("@lib/event/helper_8f4669aa")
local helper_94984651 = require("@lib/event/helper_94984651")
local helper_c13b76f2 = require("@lib/event/helper_c13b76f2")
local helper_f6f12e84 = require("@lib/event/helper_f6f12e84")

--- Helper function.
local function helper_180ab6ea(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_94984651(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_8f4669aa(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_f6f12e84(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_c13b76f2(arg0, arg1)
		return
	end
end

return helper_180ab6ea
