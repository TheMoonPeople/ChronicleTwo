--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1c113c0e = require("@lib/event/helper_1c113c0e")
local helper_40de9d0d = require("@lib/event/helper_40de9d0d")
local helper_4d046256 = require("@lib/event/helper_4d046256")
local helper_8696d396 = require("@lib/event/helper_8696d396")
local helper_a87ff5fe = require("@lib/event/helper_a87ff5fe")
local helper_c7753849 = require("@lib/event/helper_c7753849")

--- Helper function.
local function helper_c09a5ddc(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_8696d396(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_a87ff5fe(arg0, arg1)
		return
	end
	do
		local out1, _, out3 = event.get_character_position(arg0)
		var4 = out1 or var4
		var6 = out3 or var6
	end
	if var4 ~= vm.f32(1182.3) or var6 ~= vm.f32(210.6) then
		helper_1c113c0e(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 9) or var3
	if var3 == 0 then
		helper_40de9d0d(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_4d046256(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_c7753849(arg0, arg1)
		return
	end
end

return helper_c09a5ddc
