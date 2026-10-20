--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3769bf75 = require("@lib/event/helper_3769bf75")
local helper_3a81ac2b = require("@lib/event/helper_3a81ac2b")
local helper_bd9b443b = require("@lib/event/helper_bd9b443b")
local helper_c9c9d8ac = require("@lib/event/helper_c9c9d8ac")

--- Helper function.
local function helper_8e7d2db5(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_c9c9d8ac(arg0, arg1)
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
		helper_c9c9d8ac(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_3769bf75(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_3a81ac2b(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_bd9b443b(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_8e7d2db5
