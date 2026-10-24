--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1386e90e = require("@lib/event/helper_1386e90e")
local helper_216f4751 = require("@lib/event/helper_216f4751")
local helper_390e8c6b = require("@lib/event/helper_390e8c6b")
local helper_fe305290 = require("@lib/event/helper_fe305290")

--- Helper function.
local function helper_116d1683(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_216f4751(arg0, arg1, 0)
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
		helper_216f4751(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_390e8c6b(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_1386e90e(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_fe305290(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_116d1683
