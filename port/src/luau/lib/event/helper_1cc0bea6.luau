--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_595f0b58 = require("@lib/event/helper_595f0b58")
local helper_61620bbc = require("@lib/event/helper_61620bbc")
local helper_95f4bdfa = require("@lib/event/helper_95f4bdfa")
local helper_d30d9e1f = require("@lib/event/helper_d30d9e1f")

--- Helper function.
local function helper_1cc0bea6(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_61620bbc(arg0, arg1)
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
		helper_61620bbc(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_95f4bdfa(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_d30d9e1f(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_595f0b58(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_1cc0bea6
