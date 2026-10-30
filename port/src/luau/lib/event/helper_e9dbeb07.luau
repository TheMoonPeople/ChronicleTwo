--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_138bee6e = require("@lib/event/helper_138bee6e")
local helper_88372fe7 = require("@lib/event/helper_88372fe7")
local helper_a85b2204 = require("@lib/event/helper_a85b2204")
local helper_ca4e5cc7 = require("@lib/event/helper_ca4e5cc7")
local helper_cb6c89f2 = require("@lib/event/helper_cb6c89f2")
local helper_efe130ea = require("@lib/event/helper_efe130ea")

--- Helper function.
local function helper_e9dbeb07(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_ca4e5cc7(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_88372fe7(arg0, arg1)
		return
	end
	do
		local out1, _, out3 = event.get_character_position(arg0)
		var4 = out1 or var4
		var6 = out3 or var6
	end
	if var4 < 1182.0 or 1183.0 < var4 or var6 < 210.0 or 211.0 < var6 then
		print("kokokokokokokokokoko\n")
		helper_138bee6e(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 9) or var3
	if var3 == 0 then
		helper_cb6c89f2(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_a85b2204(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_efe130ea(arg0, arg1)
		return
	end
end

return helper_e9dbeb07
