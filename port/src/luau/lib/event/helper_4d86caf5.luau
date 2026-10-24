--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_68ff35bb = require("@lib/event/helper_68ff35bb")
local helper_7f06d917 = require("@lib/event/helper_7f06d917")
local helper_87385891 = require("@lib/event/helper_87385891")
local helper_e1781d4a = require("@lib/event/helper_e1781d4a")
local helper_f86d84f5 = require("@lib/event/helper_f86d84f5")

--- Helper function.
local function helper_4d86caf5(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_87385891(arg0, arg1)
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
		helper_87385891(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_7f06d917(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_f86d84f5(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_68ff35bb(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_e1781d4a(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_4d86caf5
