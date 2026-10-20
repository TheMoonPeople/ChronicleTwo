--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3ac1fc43 = require("@lib/event/helper_3ac1fc43")
local helper_9b454bee = require("@lib/event/helper_9b454bee")
local helper_ca63057f = require("@lib/event/helper_ca63057f")
local helper_dfcc264a = require("@lib/event/helper_dfcc264a")

--- Helper function.
local function helper_198ae6c4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_dfcc264a(arg0, arg1)
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
	flag = event.GetFlag(424) or flag
	if var2 ~= 2 or flag == 0 then
		helper_dfcc264a(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 16) or var2
	if var2 == 0 then
		helper_9b454bee(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_ca63057f(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_3ac1fc43(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_198ae6c4
