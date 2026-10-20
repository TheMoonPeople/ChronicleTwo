--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_17f286f8 = require("@lib/event/helper_17f286f8")
local helper_426f164a = require("@lib/event/helper_426f164a")
local helper_88434c36 = require("@lib/event/helper_88434c36")
local helper_91765f1b = require("@lib/event/helper_91765f1b")
local helper_b5762dc1 = require("@lib/event/helper_b5762dc1")

--- Helper function.
local function helper_27fbc645(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_17f286f8(arg0, arg1)
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
		helper_17f286f8(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_91765f1b(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_88434c36(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_b5762dc1(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_426f164a(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_27fbc645
