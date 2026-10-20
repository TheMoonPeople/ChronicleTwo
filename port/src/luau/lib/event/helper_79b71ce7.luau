--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_45d8a369 = require("@lib/event/helper_45d8a369")
local helper_5419c2ac = require("@lib/event/helper_5419c2ac")
local helper_8ecb6320 = require("@lib/event/helper_8ecb6320")
local helper_a7d6a00a = require("@lib/event/helper_a7d6a00a")

--- Helper function.
local function helper_79b71ce7(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
		if at <= 3 then
			return
		end
	end
	flag = event.GetFlag(42) or flag
	if flag == 0 then
		helper_5419c2ac(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_8ecb6320(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_a7d6a00a(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_45d8a369(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_79b71ce7
