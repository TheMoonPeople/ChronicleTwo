--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_05b4ff54 = require("@lib/event/helper_05b4ff54")
local helper_88adb870 = require("@lib/event/helper_88adb870")
local helper_9cd127d4 = require("@lib/event/helper_9cd127d4")
local helper_df84c9b6 = require("@lib/event/helper_df84c9b6")
local helper_e9499a26 = require("@lib/event/helper_e9499a26")

--- Helper function.
local function helper_ff5038da(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_05b4ff54(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_05b4ff54(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_df84c9b6(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_9cd127d4(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_88adb870(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_e9499a26(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_ff5038da
