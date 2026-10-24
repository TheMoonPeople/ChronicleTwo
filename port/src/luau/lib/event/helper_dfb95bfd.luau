--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6a8c4425 = require("@lib/event/helper_6a8c4425")
local helper_9c775c50 = require("@lib/event/helper_9c775c50")
local helper_bd9875ac = require("@lib/event/helper_bd9875ac")
local helper_d210136a = require("@lib/event/helper_d210136a")

--- Helper function.
local function helper_dfb95bfd(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_6a8c4425(arg0, arg1)
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
		helper_6a8c4425(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_d210136a(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_bd9875ac(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_9c775c50(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_dfb95bfd
