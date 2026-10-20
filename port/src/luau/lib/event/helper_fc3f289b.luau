--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2cbcb34e = require("@lib/event/helper_2cbcb34e")
local helper_4cd06451 = require("@lib/event/helper_4cd06451")
local helper_6c6c646b = require("@lib/event/helper_6c6c646b")
local helper_b2c12f71 = require("@lib/event/helper_b2c12f71")
local helper_be7c47cf = require("@lib/event/helper_be7c47cf")
local helper_c8ea4d63 = require("@lib/event/helper_c8ea4d63")
local helper_ed9978bc = require("@lib/event/helper_ed9978bc")

--- Helper function.
local function helper_fc3f289b(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_c8ea4d63(arg0, arg1)
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
				helper_ed9978bc(arg0, arg1)
			end
			if at <= 6 then
				helper_be7c47cf(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_c8ea4d63(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_6c6c646b(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_4cd06451(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_b2c12f71(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_ed9978bc(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_be7c47cf(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_2cbcb34e(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

return helper_fc3f289b
