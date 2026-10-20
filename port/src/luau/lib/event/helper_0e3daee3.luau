--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4c74a7b2 = require("@lib/event/helper_4c74a7b2")
local helper_d3ef2a2b = require("@lib/event/helper_d3ef2a2b")
local helper_dd2b740c = require("@lib/event/helper_dd2b740c")
local helper_f67016a9 = require("@lib/event/helper_f67016a9")

--- Helper function.
local function helper_0e3daee3(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_4c74a7b2(arg0, arg1)
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
	flag = event.GetFlag(424) or flag
	if var2 ~= 2 or flag == 0 then
		helper_4c74a7b2(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 16) or var2
	if var2 == 0 then
		helper_d3ef2a2b(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_dd2b740c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_f67016a9(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_0e3daee3
