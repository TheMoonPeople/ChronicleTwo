--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0fea41e7 = require("@lib/event/helper_0fea41e7")
local helper_38effabc = require("@lib/event/helper_38effabc")
local helper_4cf41ffd = require("@lib/event/helper_4cf41ffd")
local helper_d2b5d0cb = require("@lib/event/helper_d2b5d0cb")

--- Helper function.
local function helper_09f03e07(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_0fea41e7(arg0, arg1)
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
		helper_0fea41e7(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_4cf41ffd(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_d2b5d0cb(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_38effabc(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_09f03e07
