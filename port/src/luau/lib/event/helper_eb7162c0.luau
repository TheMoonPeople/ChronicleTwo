--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_225bbd1e = require("@lib/event/helper_225bbd1e")
local helper_58c088e0 = require("@lib/event/helper_58c088e0")
local helper_83248043 = require("@lib/event/helper_83248043")
local helper_baf66e1b = require("@lib/event/helper_baf66e1b")

--- Helper function.
local function helper_eb7162c0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_225bbd1e(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_83248043(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_baf66e1b(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_58c088e0(arg0, arg1)
		return
	end
end

return helper_eb7162c0
