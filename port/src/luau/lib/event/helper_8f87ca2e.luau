--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_1316614d = require("@lib/event/helper_1316614d")
local helper_1aecd45d = require("@lib/event/helper_1aecd45d")
local helper_5d307286 = require("@lib/event/helper_5d307286")
local helper_7dbf3461 = require("@lib/event/helper_7dbf3461")
local helper_dd375b4e = require("@lib/event/helper_dd375b4e")

--- Helper function.
local function helper_8f87ca2e(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_7dbf3461(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_5d307286(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 8) or var3
	if var3 == 0 then
		helper_1aecd45d(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_dd375b4e(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_1316614d(arg0, arg1)
		return
	end
end

return helper_8f87ca2e
