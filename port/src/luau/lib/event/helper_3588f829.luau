--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3c5aaab0 = require("@lib/event/helper_3c5aaab0")
local helper_57150cc7 = require("@lib/event/helper_57150cc7")
local helper_691a9806 = require("@lib/event/helper_691a9806")
local helper_f487ed49 = require("@lib/event/helper_f487ed49")

--- Helper function.
local function helper_3588f829(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_57150cc7(arg0, arg1)
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
		helper_57150cc7(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_691a9806(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_f487ed49(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_3c5aaab0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_3588f829
