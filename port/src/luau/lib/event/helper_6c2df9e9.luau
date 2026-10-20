--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1e26b26a = require("@lib/event/helper_1e26b26a")
local helper_289bd6b1 = require("@lib/event/helper_289bd6b1")
local helper_9e15e4bf = require("@lib/event/helper_9e15e4bf")
local helper_9f5da53c = require("@lib/event/helper_9f5da53c")

--- Helper function.
local function helper_6c2df9e9(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_9f5da53c(arg0, arg1)
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
		helper_9f5da53c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_1e26b26a(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_289bd6b1(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_9e15e4bf(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_6c2df9e9
