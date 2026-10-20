--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1e5d99d7 = require("@lib/event/helper_1e5d99d7")
local helper_2d433511 = require("@lib/event/helper_2d433511")
local helper_66460095 = require("@lib/event/helper_66460095")
local helper_900b4cd4 = require("@lib/event/helper_900b4cd4")

--- Helper function.
local function helper_ab98c049(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2d433511(arg0, arg1)
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
		helper_2d433511(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_66460095(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_1e5d99d7(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_900b4cd4(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_ab98c049
