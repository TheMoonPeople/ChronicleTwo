--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_17b025c5 = require("@lib/event/helper_17b025c5")
local helper_5f2ca2df = require("@lib/event/helper_5f2ca2df")
local helper_c764436a = require("@lib/event/helper_c764436a")
local helper_ef6cf799 = require("@lib/event/helper_ef6cf799")

--- Helper function.
local function helper_93338a9a(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_c764436a(arg0, arg1)
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
		helper_c764436a(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_17b025c5(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_ef6cf799(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_5f2ca2df(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_93338a9a
