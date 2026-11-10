--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_057d91f6 = require("@lib/event/helper_057d91f6")
local helper_0e5d5e8f = require("@lib/event/helper_0e5d5e8f")
local helper_2d9985d4 = require("@lib/event/helper_2d9985d4")
local helper_37329f80 = require("@lib/event/helper_37329f80")
local helper_6e31b499 = require("@lib/event/helper_6e31b499")

--- Helper function.
local function helper_ad8682c4(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_057d91f6(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_0e5d5e8f(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 3) or var3
	if var3 == 0 then
		helper_2d9985d4(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_37329f80(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_6e31b499(arg0, arg1)
		return
	end
end

return helper_ad8682c4
