--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2ebe49ea = require("@lib/event/helper_2ebe49ea")
local helper_3163b0d7 = require("@lib/event/helper_3163b0d7")
local helper_89667681 = require("@lib/event/helper_89667681")
local helper_e799d57b = require("@lib/event/helper_e799d57b")

--- Helper function.
local function helper_64b0c307(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_3163b0d7(arg0, arg1)
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
		helper_3163b0d7(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_e799d57b(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_89667681(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2ebe49ea(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_64b0c307
