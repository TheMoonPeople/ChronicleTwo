--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0b62b9aa = require("@lib/event/helper_0b62b9aa")
local helper_0ed154ae = require("@lib/event/helper_0ed154ae")
local helper_376d7eaf = require("@lib/event/helper_376d7eaf")
local helper_4a8da25e = require("@lib/event/helper_4a8da25e")
local helper_7189c5d4 = require("@lib/event/helper_7189c5d4")
local helper_d6728a76 = require("@lib/event/helper_d6728a76")
local helper_f82c313f = require("@lib/event/helper_f82c313f")

--- Helper function.
local function helper_ff6f040f(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_0b62b9aa(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 7 then
			if at <= 5 then
				helper_0ed154ae(arg0, arg1)
			end
			if at <= 6 then
				helper_376d7eaf(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_0b62b9aa(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_4a8da25e(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_7189c5d4(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_d6728a76(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_0ed154ae(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_376d7eaf(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_f82c313f(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

return helper_ff6f040f
