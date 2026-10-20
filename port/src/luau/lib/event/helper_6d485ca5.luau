--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4d64cf74 = require("@lib/event/helper_4d64cf74")
local helper_5a9b3e0b = require("@lib/event/helper_5a9b3e0b")
local helper_bd859615 = require("@lib/event/helper_bd859615")
local helper_dd931eae = require("@lib/event/helper_dd931eae")

--- Helper function.
local function helper_6d485ca5(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_5a9b3e0b(arg0, arg1)
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
		helper_5a9b3e0b(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_dd931eae(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_bd859615(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_4d64cf74(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_6d485ca5
