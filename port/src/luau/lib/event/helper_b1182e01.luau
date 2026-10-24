--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_26ae3ce1 = require("@lib/event/helper_26ae3ce1")
local helper_33244fcd = require("@lib/event/helper_33244fcd")
local helper_37500daa = require("@lib/event/helper_37500daa")
local helper_ae7eb055 = require("@lib/event/helper_ae7eb055")
local helper_c8b8f6e6 = require("@lib/event/helper_c8b8f6e6")
local helper_f4c66bb3 = require("@lib/event/helper_f4c66bb3")
local helper_f85ef24e = require("@lib/event/helper_f85ef24e")

--- Helper function.
local function helper_b1182e01(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_ae7eb055(arg0, arg1)
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
				helper_f85ef24e(arg0, arg1)
			end
			if at <= 6 then
				helper_33244fcd(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_ae7eb055(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_c8b8f6e6(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_37500daa(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_f4c66bb3(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_f85ef24e(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_33244fcd(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_26ae3ce1(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

return helper_b1182e01
