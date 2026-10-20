--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_05232125 = require("@lib/event/helper_05232125")
local helper_38f16b68 = require("@lib/event/helper_38f16b68")
local helper_5d19b163 = require("@lib/event/helper_5d19b163")
local helper_905df00c = require("@lib/event/helper_905df00c")

--- Helper function.
local function helper_2ff3346b(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_05232125(arg0, arg1)
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
		helper_05232125(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_905df00c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_38f16b68(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_5d19b163(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_2ff3346b
