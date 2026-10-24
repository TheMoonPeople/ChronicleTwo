--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_739ca91d = require("@lib/event/helper_739ca91d")
local helper_97cc43dc = require("@lib/event/helper_97cc43dc")
local helper_bafdd0ef = require("@lib/event/helper_bafdd0ef")
local helper_d0ac0f9c = require("@lib/event/helper_d0ac0f9c")

--- Helper function.
local function helper_7c856587(arg0: s32, arg1: s32)
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
		helper_97cc43dc(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_d0ac0f9c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_bafdd0ef(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_739ca91d(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_7c856587
