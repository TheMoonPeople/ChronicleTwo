--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_55898ed6 = require("@lib/event/helper_55898ed6")
local helper_ac6ebf36 = require("@lib/event/helper_ac6ebf36")
local helper_b93febf8 = require("@lib/event/helper_b93febf8")
local helper_bbfd7641 = require("@lib/event/helper_bbfd7641")

--- Helper function.
local function helper_09b575ea(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_55898ed6(arg0, arg1)
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
		helper_55898ed6(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_ac6ebf36(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_b93febf8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_bbfd7641(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_09b575ea
