--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1c60679c = require("@lib/event/helper_1c60679c")
local helper_5c3c6a10 = require("@lib/event/helper_5c3c6a10")
local helper_e04ab7f3 = require("@lib/event/helper_e04ab7f3")
local helper_e7d2f362 = require("@lib/event/helper_e7d2f362")

--- Helper function.
local function helper_2528fc40(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_5c3c6a10(arg0, arg1)
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
		helper_5c3c6a10(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_1c60679c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_e7d2f362(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_e04ab7f3(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_2528fc40
