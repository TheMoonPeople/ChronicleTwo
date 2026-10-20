--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_586df9ca = require("@lib/event/helper_586df9ca")
local helper_94365857 = require("@lib/event/helper_94365857")
local helper_b36d7735 = require("@lib/event/helper_b36d7735")
local helper_b5e70035 = require("@lib/event/helper_b5e70035")

--- Helper function.
local function helper_66015f0b(arg0: s32, arg1: s32)
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
		helper_94365857(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_b5e70035(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_b36d7735(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_586df9ca(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_66015f0b
