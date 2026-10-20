--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3c066b19 = require("@lib/event/helper_3c066b19")
local helper_8f85c9fe = require("@lib/event/helper_8f85c9fe")
local helper_988d3a37 = require("@lib/event/helper_988d3a37")
local helper_b25d6e93 = require("@lib/event/helper_b25d6e93")

--- Helper function.
local function helper_8d3cdccb(arg0: s32, arg1: s32)
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
		helper_8f85c9fe(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_b25d6e93(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_988d3a37(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_3c066b19(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_8d3cdccb
