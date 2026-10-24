--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0268b93b = require("@lib/event/helper_0268b93b")
local helper_67c0b4b9 = require("@lib/event/helper_67c0b4b9")
local helper_68a4f475 = require("@lib/event/helper_68a4f475")
local helper_7b2d618d = require("@lib/event/helper_7b2d618d")

--- Helper function.
local function helper_13573ec5(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_7b2d618d(arg0, arg1, 0)
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
		helper_7b2d618d(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_67c0b4b9(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_0268b93b(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_68a4f475(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_13573ec5
