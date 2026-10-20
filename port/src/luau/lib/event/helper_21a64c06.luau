--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_09c894f6 = require("@lib/event/helper_09c894f6")
local helper_64a8c542 = require("@lib/event/helper_64a8c542")
local helper_e24c898f = require("@lib/event/helper_e24c898f")
local helper_ffecb781 = require("@lib/event/helper_ffecb781")

--- Helper function.
local function helper_21a64c06(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
		if at <= 3 then
			return
		end
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_64a8c542(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_09c894f6(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_ffecb781(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_e24c898f(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_21a64c06
