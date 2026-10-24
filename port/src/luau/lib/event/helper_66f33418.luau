--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_33ada8ab = require("@lib/event/helper_33ada8ab")
local helper_3ec1870f = require("@lib/event/helper_3ec1870f")
local helper_e741e608 = require("@lib/event/helper_e741e608")
local helper_eb3276a1 = require("@lib/event/helper_eb3276a1")

--- Helper function.
local function helper_66f33418(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_e741e608(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_3ec1870f(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_eb3276a1(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_33ada8ab(arg0, arg1)
		return
	end
end

return helper_66f33418
