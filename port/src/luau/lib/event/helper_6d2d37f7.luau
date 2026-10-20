--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7d4efdb1 = require("@lib/event/helper_7d4efdb1")
local helper_a25e45e2 = require("@lib/event/helper_a25e45e2")
local helper_c2373d02 = require("@lib/event/helper_c2373d02")
local helper_d2e07a14 = require("@lib/event/helper_d2e07a14")
local helper_e613d298 = require("@lib/event/helper_e613d298")

--- Helper function.
local function helper_6d2d37f7(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_7d4efdb1(arg0, arg1)
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
		helper_7d4efdb1(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_c2373d02(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_a25e45e2(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_e613d298(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_d2e07a14(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_6d2d37f7
