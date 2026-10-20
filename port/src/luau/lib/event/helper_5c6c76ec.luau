--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3fa1a5f1 = require("@lib/event/helper_3fa1a5f1")
local helper_78a6a7dc = require("@lib/event/helper_78a6a7dc")
local helper_88494be1 = require("@lib/event/helper_88494be1")
local helper_cdca61a4 = require("@lib/event/helper_cdca61a4")

--- Helper function.
local function helper_5c6c76ec(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_3fa1a5f1(arg0, arg1)
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
		helper_3fa1a5f1(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_78a6a7dc(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_cdca61a4(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_88494be1(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_5c6c76ec
