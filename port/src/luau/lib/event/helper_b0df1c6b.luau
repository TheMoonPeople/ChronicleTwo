--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3bd223b8 = require("@lib/event/helper_3bd223b8")
local helper_950f9fa8 = require("@lib/event/helper_950f9fa8")
local helper_9544170f = require("@lib/event/helper_9544170f")
local helper_dd6d738f = require("@lib/event/helper_dd6d738f")

--- Helper function.
local function helper_b0df1c6b(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_950f9fa8(arg0, arg1)
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
		helper_950f9fa8(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_dd6d738f(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_9544170f(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_3bd223b8(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_b0df1c6b
