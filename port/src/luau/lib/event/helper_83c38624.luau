--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_149febde = require("@lib/event/helper_149febde")
local helper_1631f97a = require("@lib/event/helper_1631f97a")
local helper_435a176a = require("@lib/event/helper_435a176a")
local helper_757abb02 = require("@lib/event/helper_757abb02")
local helper_884017f3 = require("@lib/event/helper_884017f3")
local helper_8a92ba20 = require("@lib/event/helper_8a92ba20")
local helper_cc16f936 = require("@lib/event/helper_cc16f936")

--- Helper function.
local function helper_83c38624(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_149febde(arg0, arg1)
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
				helper_435a176a(arg0, arg1)
			end
			if at <= 6 then
				helper_884017f3(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_149febde(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_cc16f936(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_757abb02(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_8a92ba20(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_435a176a(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_884017f3(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_1631f97a(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

return helper_83c38624
