--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0f666b1b = require("@lib/event/helper_0f666b1b")
local helper_3c2b01a8 = require("@lib/event/helper_3c2b01a8")
local helper_4f44bfb4 = require("@lib/event/helper_4f44bfb4")
local helper_55283927 = require("@lib/event/helper_55283927")

--- Helper function.
local function helper_4addf2d5(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_55283927(arg0, arg1)
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
		helper_55283927(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 16) or var2
	if var2 == 0 then
		helper_0f666b1b(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_3c2b01a8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_4f44bfb4(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_4addf2d5
