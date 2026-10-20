--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5ce89550 = require("@lib/event/helper_5ce89550")
local helper_a55c786e = require("@lib/event/helper_a55c786e")
local helper_bf8f39fa = require("@lib/event/helper_bf8f39fa")
local helper_f90b27b5 = require("@lib/event/helper_f90b27b5")
local helper_fcc918f4 = require("@lib/event/helper_fcc918f4")

--- Helper function.
local function helper_b6ded4eb(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_bf8f39fa(arg0, arg1)
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
		helper_bf8f39fa(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_f90b27b5(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_5ce89550(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_a55c786e(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_fcc918f4(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_b6ded4eb
