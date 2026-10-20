--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_32f36b2a = require("@lib/event/helper_32f36b2a")
local helper_7236feb8 = require("@lib/event/helper_7236feb8")
local helper_759b32b7 = require("@lib/event/helper_759b32b7")
local helper_ac6f21cb = require("@lib/event/helper_ac6f21cb")

--- Helper function.
local function helper_167cd45b(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_32f36b2a(arg0, arg1)
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
		helper_32f36b2a(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_759b32b7(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_7236feb8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_ac6f21cb(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_167cd45b
