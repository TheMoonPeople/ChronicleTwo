--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_36cdca89 = require("@lib/event/helper_36cdca89")
local helper_6e6b3339 = require("@lib/event/helper_6e6b3339")
local helper_7539d31e = require("@lib/event/helper_7539d31e")
local helper_db53e986 = require("@lib/event/helper_db53e986")

--- Helper function.
local function helper_b234173d(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_36cdca89(arg0, arg1, 0)
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_7539d31e(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_6e6b3339(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_db53e986(arg0, arg1)
		return
	end
end

return helper_b234173d
