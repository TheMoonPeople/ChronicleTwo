--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0abd2b26 = require("@lib/event/helper_0abd2b26")
local helper_389a65e6 = require("@lib/event/helper_389a65e6")
local helper_827187e7 = require("@lib/event/helper_827187e7")
local helper_84b9c8a2 = require("@lib/event/helper_84b9c8a2")
local helper_f8a1cee2 = require("@lib/event/helper_f8a1cee2")

--- Helper function.
local function helper_e8531010(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_827187e7(arg0, arg1)
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
		helper_827187e7(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_f8a1cee2(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_0abd2b26(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_389a65e6(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_84b9c8a2(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_e8531010
