--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_40e413d4 = require("@lib/event/helper_40e413d4")
local helper_6969002b = require("@lib/event/helper_6969002b")
local helper_83661254 = require("@lib/event/helper_83661254")
local helper_e8088d5d = require("@lib/event/helper_e8088d5d")

--- Helper function.
local function helper_11dbc26a(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_6969002b(arg0, arg1)
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
		helper_6969002b(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_40e413d4(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_e8088d5d(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_83661254(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_11dbc26a
