--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ec688eb = require("@lib/event/helper_0ec688eb")
local helper_5459f84e = require("@lib/event/helper_5459f84e")
local helper_5b9b16a6 = require("@lib/event/helper_5b9b16a6")
local helper_8128d8c5 = require("@lib/event/helper_8128d8c5")
local helper_b5a79ba4 = require("@lib/event/helper_b5a79ba4")
local helper_e4590eb8 = require("@lib/event/helper_e4590eb8")
local helper_f8427811 = require("@lib/event/helper_f8427811")

--- Helper function.
local function helper_0b4ad783(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_5b9b16a6(arg0, arg1)
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
				helper_f8427811(arg0, arg1)
			end
			if at <= 6 then
				helper_0ec688eb(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_5b9b16a6(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_8128d8c5(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_5459f84e(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_e4590eb8(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_f8427811(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_0ec688eb(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_b5a79ba4(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

return helper_0b4ad783
