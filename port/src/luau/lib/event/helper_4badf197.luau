--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1b63fc7b = require("@lib/event/helper_1b63fc7b")
local helper_9d9d7bb5 = require("@lib/event/helper_9d9d7bb5")
local helper_c2e7cf1e = require("@lib/event/helper_c2e7cf1e")
local helper_c48a6666 = require("@lib/event/helper_c48a6666")

--- Helper function.
local function helper_4badf197(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_9d9d7bb5(arg0, arg1)
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
		helper_9d9d7bb5(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_c48a6666(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_1b63fc7b(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_c2e7cf1e(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_4badf197
