--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1b4b9b0a = require("@lib/event/helper_1b4b9b0a")
local helper_915a2cb5 = require("@lib/event/helper_915a2cb5")
local helper_ac244706 = require("@lib/event/helper_ac244706")
local helper_d597165a = require("@lib/event/helper_d597165a")

--- Helper function.
local function helper_fcfeb4d8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_915a2cb5(arg0, arg1)
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
		helper_915a2cb5(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_d597165a(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_ac244706(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_1b4b9b0a(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_fcfeb4d8
