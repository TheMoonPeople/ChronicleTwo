--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_00ecae06 = require("@lib/event/helper_00ecae06")
local helper_84d0b877 = require("@lib/event/helper_84d0b877")
local helper_96b76280 = require("@lib/event/helper_96b76280")
local helper_9a53e7ea = require("@lib/event/helper_9a53e7ea")
local helper_ff89ac9c = require("@lib/event/helper_ff89ac9c")

--- Helper function.
local function helper_47ac04e8(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_9a53e7ea(arg0, arg1)
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
		helper_9a53e7ea(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_00ecae06(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_84d0b877(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_96b76280(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_ff89ac9c(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_47ac04e8
