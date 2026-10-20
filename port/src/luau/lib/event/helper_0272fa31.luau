--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_22374509 = require("@lib/event/helper_22374509")
local helper_52d5a368 = require("@lib/event/helper_52d5a368")
local helper_6cc0ba53 = require("@lib/event/helper_6cc0ba53")
local helper_f7bdfb81 = require("@lib/event/helper_f7bdfb81")

--- Helper function.
local function helper_0272fa31(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_f7bdfb81(arg0, arg1)
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
		helper_f7bdfb81(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_6cc0ba53(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_52d5a368(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_22374509(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_0272fa31
