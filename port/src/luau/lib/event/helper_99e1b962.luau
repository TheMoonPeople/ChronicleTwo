--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02e82df3 = require("@lib/event/helper_02e82df3")
local helper_595f0b58 = require("@lib/event/helper_595f0b58")
local helper_61620bbc = require("@lib/event/helper_61620bbc")
local helper_fc8b6ed8 = require("@lib/event/helper_fc8b6ed8")

--- Helper function.
local function helper_99e1b962(arg0: s32, arg1: s32)
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
		helper_fc8b6ed8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_02e82df3(arg0, arg1)
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

return helper_99e1b962
