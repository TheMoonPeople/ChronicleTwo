--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_51d1a1b4 = require("@lib/event/helper_51d1a1b4")
local helper_60dc2072 = require("@lib/event/helper_60dc2072")
local helper_65326342 = require("@lib/event/helper_65326342")
local helper_b1e5775f = require("@lib/event/helper_b1e5775f")

--- Helper function.
local function helper_70a08c7a(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_51d1a1b4(arg0, arg1)
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
		helper_51d1a1b4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_60dc2072(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_65326342(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_b1e5775f(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_70a08c7a
