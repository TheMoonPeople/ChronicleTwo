--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_332f3d3e = require("@lib/event/helper_332f3d3e")
local helper_d4d3f44f = require("@lib/event/helper_d4d3f44f")
local helper_eb41ef82 = require("@lib/event/helper_eb41ef82")
local helper_fbafd72a = require("@lib/event/helper_fbafd72a")

--- Helper function.
local function helper_e0c1e277(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_d4d3f44f(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_fbafd72a(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_332f3d3e(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_eb41ef82(arg0, arg1)
		return
	end
end

return helper_e0c1e277
