--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2d7a6877 = require("@lib/event/helper_2d7a6877")
local helper_5ca54f0e = require("@lib/event/helper_5ca54f0e")
local helper_6759dfa1 = require("@lib/event/helper_6759dfa1")
local helper_9a4d50a7 = require("@lib/event/helper_9a4d50a7")
local helper_f2ca7aa1 = require("@lib/event/helper_f2ca7aa1")

--- Helper function.
local function helper_8f66aa33(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_6759dfa1(arg0, arg1)
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
		helper_6759dfa1(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_f2ca7aa1(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_9a4d50a7(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_5ca54f0e(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_2d7a6877(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_8f66aa33
