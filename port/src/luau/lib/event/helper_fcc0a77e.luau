--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_1750851a = require("@lib/event/helper_1750851a")
local helper_250c2ee9 = require("@lib/event/helper_250c2ee9")
local helper_76e63645 = require("@lib/event/helper_76e63645")
local helper_8db889b0 = require("@lib/event/helper_8db889b0")
local helper_a4c22326 = require("@lib/event/helper_a4c22326")

--- Helper function.
local function helper_fcc0a77e(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		helper_76e63645(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_8db889b0(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 10) or var3
	if var3 == 0 then
		helper_1750851a(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_250c2ee9(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_a4c22326(arg0, arg1)
		return
	end
end

return helper_fcc0a77e
