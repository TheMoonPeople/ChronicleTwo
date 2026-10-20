--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_625100e6 = require("@lib/event/helper_625100e6")
local helper_8a208ded = require("@lib/event/helper_8a208ded")
local helper_dd64c1f2 = require("@lib/event/helper_dd64c1f2")
local helper_fae774bf = require("@lib/event/helper_fae774bf")

--- Helper function.
local function helper_c701229d(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_8a208ded(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_8a208ded(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_625100e6(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_fae774bf(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_dd64c1f2(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_c701229d
