--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3ada0bfc = require("@lib/event/helper_3ada0bfc")
local helper_5949370a = require("@lib/event/helper_5949370a")
local helper_790155d6 = require("@lib/event/helper_790155d6")
local helper_ea7e4356 = require("@lib/event/helper_ea7e4356")

--- Helper function.
local function helper_92347b21(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_ea7e4356(arg0, arg1)
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
		helper_ea7e4356(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_3ada0bfc(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_790155d6(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_5949370a(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_92347b21
