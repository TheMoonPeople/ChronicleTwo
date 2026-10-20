--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_15643f4e = require("@lib/event/helper_15643f4e")
local helper_d74c7d9a = require("@lib/event/helper_d74c7d9a")
local helper_ecccca83 = require("@lib/event/helper_ecccca83")
local helper_ed2605e6 = require("@lib/event/helper_ed2605e6")
local helper_f2a71364 = require("@lib/event/helper_f2a71364")

--- Helper function.
local function helper_e8c0ad9d(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_d74c7d9a(arg0, arg1)
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
		helper_d74c7d9a(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_ed2605e6(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_ecccca83(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_15643f4e(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_f2a71364(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_e8c0ad9d
