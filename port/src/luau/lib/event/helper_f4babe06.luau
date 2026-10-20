--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3f53bee6 = require("@lib/event/helper_3f53bee6")
local helper_4399cf70 = require("@lib/event/helper_4399cf70")
local helper_598123e8 = require("@lib/event/helper_598123e8")
local helper_88147b70 = require("@lib/event/helper_88147b70")
local helper_8adac41a = require("@lib/event/helper_8adac41a")
local helper_a619d028 = require("@lib/event/helper_a619d028")
local helper_fc8187c8 = require("@lib/event/helper_fc8187c8")

--- Helper function.
local function helper_f4babe06(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_8adac41a(arg0, arg1)
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
				helper_fc8187c8(arg0, arg1)
			end
			if at <= 6 then
				helper_4399cf70(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_8adac41a(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_3f53bee6(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_a619d028(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_598123e8(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_fc8187c8(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_4399cf70(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_88147b70(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

return helper_f4babe06
