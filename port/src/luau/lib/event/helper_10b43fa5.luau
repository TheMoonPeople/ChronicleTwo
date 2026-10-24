--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_26af5a76 = require("@lib/event/helper_26af5a76")
local helper_4f522505 = require("@lib/event/helper_4f522505")
local helper_8c289419 = require("@lib/event/helper_8c289419")
local helper_aa9cd292 = require("@lib/event/helper_aa9cd292")

--- Helper function.
local function helper_10b43fa5(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_aa9cd292(arg0, arg1)
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
		helper_aa9cd292(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_4f522505(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_26af5a76(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_8c289419(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_10b43fa5
