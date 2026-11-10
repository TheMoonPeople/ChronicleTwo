--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_26352317 = require("@lib/event/helper_26352317")
local helper_56157b33 = require("@lib/event/helper_56157b33")
local helper_9b9d0c49 = require("@lib/event/helper_9b9d0c49")
local helper_f284af9a = require("@lib/event/helper_f284af9a")

--- Helper function.
local function helper_5de0482a(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_9b9d0c49(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 1) or var2
	if var2 == 0 then
		helper_26352317(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_56157b33(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_f284af9a(arg0, arg1)
		return
	end
end

return helper_5de0482a
