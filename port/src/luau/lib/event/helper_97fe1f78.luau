--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2a7ca4d6 = require("@lib/event/helper_2a7ca4d6")
local helper_5a142ba6 = require("@lib/event/helper_5a142ba6")
local helper_c52e9159 = require("@lib/event/helper_c52e9159")
local helper_d781e982 = require("@lib/event/helper_d781e982")
local helper_e1a643b1 = require("@lib/event/helper_e1a643b1")

--- Helper function.
local function helper_97fe1f78(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_e1a643b1(arg0, arg1)
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
		helper_e1a643b1(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_c52e9159(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_d781e982(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_5a142ba6(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_2a7ca4d6(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_97fe1f78
