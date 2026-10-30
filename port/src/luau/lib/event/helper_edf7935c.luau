--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0364b046 = require("@lib/event/helper_0364b046")
local helper_22b1633f = require("@lib/event/helper_22b1633f")
local helper_3cccfb27 = require("@lib/event/helper_3cccfb27")
local helper_61d4ffb7 = require("@lib/event/helper_61d4ffb7")
local helper_6740f0c2 = require("@lib/event/helper_6740f0c2")
local helper_c125d8f5 = require("@lib/event/helper_c125d8f5")

--- Helper function.
local function helper_edf7935c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_c125d8f5(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_61d4ffb7(arg0, arg1)
		return
	end
	do
		local out1, _, out3 = event.get_character_position(arg0)
		var4 = out1 or var4
		var6 = out3 or var6
	end
	if var4 < 1182.0 or 1183.0 < var4 or var6 < 210.0 or 211.0 < var6 then
		print("kokokokokokokokokoko\n")
		helper_3cccfb27(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 9) or var3
	if var3 == 0 then
		helper_0364b046(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_22b1633f(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_6740f0c2(arg0, arg1)
		return
	end
end

return helper_edf7935c
