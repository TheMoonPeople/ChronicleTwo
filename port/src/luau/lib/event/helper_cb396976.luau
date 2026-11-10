--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_28a75358 = require("@lib/event/helper_28a75358")
local helper_8fd048b7 = require("@lib/event/helper_8fd048b7")
local helper_aaf63e58 = require("@lib/event/helper_aaf63e58")
local helper_bc15478d = require("@lib/event/helper_bc15478d")
local helper_c2f7081f = require("@lib/event/helper_c2f7081f")

--- Helper function.
local function helper_cb396976(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_c2f7081f(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_bc15478d(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 11) or var3
	if var3 == 0 then
		helper_aaf63e58(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_8fd048b7(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_28a75358(arg0, arg1)
		return
	end
end

return helper_cb396976
