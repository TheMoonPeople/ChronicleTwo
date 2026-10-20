--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2737c7ac = require("@lib/event/helper_2737c7ac")
local helper_5b4ebdf3 = require("@lib/event/helper_5b4ebdf3")
local helper_d581415c = require("@lib/event/helper_d581415c")
local helper_f0e34665 = require("@lib/event/helper_f0e34665")

--- Helper function.
local function helper_aa0e6104(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_d581415c(arg0, arg1, 0)
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
		helper_d581415c(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_2737c7ac(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_f0e34665(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_5b4ebdf3(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_aa0e6104
