--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0b087f9e = require("@lib/event/helper_0b087f9e")
local helper_3e8b3667 = require("@lib/event/helper_3e8b3667")
local helper_ab42467c = require("@lib/event/helper_ab42467c")
local helper_fe698e0f = require("@lib/event/helper_fe698e0f")

--- Helper function.
local function helper_09e6e807(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_fe698e0f(arg0, arg1)
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
		helper_fe698e0f(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_3e8b3667(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_0b087f9e(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_ab42467c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_09e6e807
