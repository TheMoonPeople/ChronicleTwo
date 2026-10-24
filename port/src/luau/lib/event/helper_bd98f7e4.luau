--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_020096c8 = require("@lib/event/helper_020096c8")
local helper_149c02cc = require("@lib/event/helper_149c02cc")
local helper_2626ccdd = require("@lib/event/helper_2626ccdd")
local helper_2e24b503 = require("@lib/event/helper_2e24b503")

--- Helper function.
local function helper_bd98f7e4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_2626ccdd(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_020096c8(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_149c02cc(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_2e24b503(arg0, arg1)
		return
	end
end

return helper_bd98f7e4
