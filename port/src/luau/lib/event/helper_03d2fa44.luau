--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_192be633 = require("@lib/event/helper_192be633")
local helper_42257f65 = require("@lib/event/helper_42257f65")
local helper_6287005c = require("@lib/event/helper_6287005c")
local helper_abe5f07e = require("@lib/event/helper_abe5f07e")

--- Helper function.
local function helper_03d2fa44(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_6287005c(arg0, arg1)
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
		helper_6287005c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_192be633(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_abe5f07e(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_42257f65(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_03d2fa44
