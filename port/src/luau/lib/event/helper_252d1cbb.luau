--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0b63318d = require("@lib/event/helper_0b63318d")
local helper_451ae739 = require("@lib/event/helper_451ae739")
local helper_6b90b243 = require("@lib/event/helper_6b90b243")
local helper_ac7f505d = require("@lib/event/helper_ac7f505d")
local helper_d3fcf719 = require("@lib/event/helper_d3fcf719")
local helper_eca754f1 = require("@lib/event/helper_eca754f1")

--- Helper function.
local function helper_252d1cbb(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_0b63318d(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_eca754f1(arg0, arg1)
		return
	end
	do
		local out1, _, out3 = event.get_character_position(arg0)
		var4 = out1 or var4
		var6 = out3 or var6
	end
	if var4 < 1182.0 or 1183.0 < var4 or var6 < 210.0 or 211.0 < var6 then
		print("kokokokokokokokokoko\n")
		helper_ac7f505d(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 9) or var3
	if var3 == 0 then
		helper_d3fcf719(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_6b90b243(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_451ae739(arg0, arg1)
		return
	end
end

return helper_252d1cbb
