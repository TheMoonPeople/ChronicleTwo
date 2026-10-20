--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7f056fc0 = require("@lib/event/helper_7f056fc0")
local helper_94e93915 = require("@lib/event/helper_94e93915")
local helper_b5976652 = require("@lib/event/helper_b5976652")
local helper_d94b8926 = require("@lib/event/helper_d94b8926")
local helper_e0bb886e = require("@lib/event/helper_e0bb886e")

--- Helper function.
local function helper_875208e8(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_d94b8926(arg0, arg1)
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
	if active_chr_no == 0 then
		helper_d94b8926(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_e0bb886e(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_7f056fc0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_b5976652(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_94e93915(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_875208e8
