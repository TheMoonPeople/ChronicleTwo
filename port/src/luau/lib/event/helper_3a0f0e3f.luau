--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_03ce30c9 = require("@lib/event/helper_03ce30c9")
local helper_4bed8505 = require("@lib/event/helper_4bed8505")
local helper_57f324d0 = require("@lib/event/helper_57f324d0")
local helper_c11b5b44 = require("@lib/event/helper_c11b5b44")

--- Helper function.
local function helper_3a0f0e3f(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_c11b5b44(arg0, arg1)
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
		helper_c11b5b44(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_57f324d0(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_03ce30c9(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_4bed8505(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_3a0f0e3f
