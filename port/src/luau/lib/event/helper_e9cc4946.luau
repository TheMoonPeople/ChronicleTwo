--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_016bdc03 = require("@lib/event/helper_016bdc03")
local helper_271921f6 = require("@lib/event/helper_271921f6")
local helper_74c480d4 = require("@lib/event/helper_74c480d4")
local helper_c5685bb3 = require("@lib/event/helper_c5685bb3")
local helper_e7a627ab = require("@lib/event/helper_e7a627ab")

--- Helper function.
local function helper_e9cc4946(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_c5685bb3(arg0, arg1)
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
	if active_chr_no == 0 then
		helper_c5685bb3(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_e7a627ab(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_271921f6(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_016bdc03(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_74c480d4(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_e9cc4946
