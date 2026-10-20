--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0e23866a = require("@lib/event/helper_0e23866a")
local helper_2a7ca4d6 = require("@lib/event/helper_2a7ca4d6")
local helper_c0572ce4 = require("@lib/event/helper_c0572ce4")
local helper_c52e9159 = require("@lib/event/helper_c52e9159")
local helper_e1a643b1 = require("@lib/event/helper_e1a643b1")

--- Helper function.
local function helper_19a54e0d(arg0: s32, arg1: s32)
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
		helper_c0572ce4(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_0e23866a(arg0, arg1)
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

return helper_19a54e0d
