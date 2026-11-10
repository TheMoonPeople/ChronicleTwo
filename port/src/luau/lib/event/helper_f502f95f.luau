--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0882e282 = require("@lib/event/helper_0882e282")
local helper_3d1c05f8 = require("@lib/event/helper_3d1c05f8")
local helper_6b6f9fb2 = require("@lib/event/helper_6b6f9fb2")
local helper_ce92fe30 = require("@lib/event/helper_ce92fe30")
local helper_d4a10548 = require("@lib/event/helper_d4a10548")

--- Helper function.
local function helper_f502f95f(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_d4a10548(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_6b6f9fb2(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 3) or var3
	if var3 == 0 then
		helper_3d1c05f8(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_0882e282(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_ce92fe30(arg0, arg1)
		return
	end
end

return helper_f502f95f
