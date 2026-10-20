--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2323d15d = require("@lib/event/helper_2323d15d")
local helper_420d5ad2 = require("@lib/event/helper_420d5ad2")
local helper_da1445c9 = require("@lib/event/helper_da1445c9")
local helper_dd5838ed = require("@lib/event/helper_dd5838ed")

--- Helper function.
local function helper_d1b32f95(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_dd5838ed(arg0, arg1)
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
	flag = event.GetFlag(314) or flag
	if flag == 0 then
		helper_dd5838ed(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_420d5ad2(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_2323d15d(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_da1445c9(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_d1b32f95
