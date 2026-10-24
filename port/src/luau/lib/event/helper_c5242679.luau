--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0d0d75cb = require("@lib/event/helper_0d0d75cb")
local helper_641f09a8 = require("@lib/event/helper_641f09a8")
local helper_8ad38df8 = require("@lib/event/helper_8ad38df8")
local helper_a26d4396 = require("@lib/event/helper_a26d4396")

--- Helper function.
local function helper_c5242679(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_8ad38df8(arg0, arg1)
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
		helper_8ad38df8(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_a26d4396(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_641f09a8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_0d0d75cb(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_c5242679
