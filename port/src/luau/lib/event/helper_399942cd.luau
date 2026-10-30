--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_66b29fdb = require("@lib/event/helper_66b29fdb")
local helper_ae607693 = require("@lib/event/helper_ae607693")
local helper_b8de2d19 = require("@lib/event/helper_b8de2d19")
local helper_b94a19ee = require("@lib/event/helper_b94a19ee")
local helper_eab8a506 = require("@lib/event/helper_eab8a506")

--- Helper function.
local function helper_399942cd(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_b8de2d19(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_b94a19ee(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 8) or var3
	if var3 == 0 then
		helper_eab8a506(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_ae607693(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_66b29fdb(arg0, arg1)
		return
	end
end

return helper_399942cd
