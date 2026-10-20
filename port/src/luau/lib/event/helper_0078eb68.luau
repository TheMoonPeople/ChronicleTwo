--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_13cfc18f = require("@lib/event/helper_13cfc18f")
local helper_9082cb42 = require("@lib/event/helper_9082cb42")
local helper_c5810e5b = require("@lib/event/helper_c5810e5b")
local helper_f78f4c0c = require("@lib/event/helper_f78f4c0c")

--- Helper function.
local function helper_0078eb68(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_c5810e5b(arg0, arg1)
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
		helper_c5810e5b(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_9082cb42(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_13cfc18f(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_f78f4c0c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_0078eb68
