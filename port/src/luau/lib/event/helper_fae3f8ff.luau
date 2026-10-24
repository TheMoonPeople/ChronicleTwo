--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0b2d2c09 = require("@lib/event/helper_0b2d2c09")
local helper_12faac92 = require("@lib/event/helper_12faac92")
local helper_2a1bffe9 = require("@lib/event/helper_2a1bffe9")
local helper_5a0ec7cf = require("@lib/event/helper_5a0ec7cf")
local helper_5faf1d96 = require("@lib/event/helper_5faf1d96")
local helper_d688a7ba = require("@lib/event/helper_d688a7ba")

--- Helper function.
local function helper_fae3f8ff(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_5faf1d96(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_d688a7ba(arg0, arg1)
		return
	end
	do
		local out1, _, out3 = event.GetCharaPos(arg0)
		var4 = out1 or var4
		var6 = out3 or var6
	end
	if var4 ~= vm.f32(1182.3) or var6 ~= vm.f32(210.6) then
		helper_0b2d2c09(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 9) or var3
	if var3 == 0 then
		helper_12faac92(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_5a0ec7cf(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_2a1bffe9(arg0, arg1)
		return
	end
end

return helper_fae3f8ff
