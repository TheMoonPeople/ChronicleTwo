--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_284f5aeb = require("@lib/event/helper_284f5aeb")
local helper_928b4276 = require("@lib/event/helper_928b4276")
local helper_ae9443d8 = require("@lib/event/helper_ae9443d8")
local helper_c7abbcc0 = require("@lib/event/helper_c7abbcc0")
local helper_d2512598 = require("@lib/event/helper_d2512598")
local helper_efebcda2 = require("@lib/event/helper_efebcda2")

--- Helper function.
local function helper_40ec7a31(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_c7abbcc0(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_ae9443d8(arg0, arg1)
		return
	end
	do
		local out1, _, out3 = event.get_character_position(arg0)
		var4 = out1 or var4
		var6 = out3 or var6
	end
	if var4 < 1182.0 or 1183.0 < var4 or var6 < 210.0 or 211.0 < var6 then
		print("kokokokokokokokokoko\n")
		helper_efebcda2(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 9) or var3
	if var3 == 0 then
		helper_d2512598(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_928b4276(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_284f5aeb(arg0, arg1)
		return
	end
end

return helper_40ec7a31
