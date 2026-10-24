--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a257284d = require("@lib/event/helper_a257284d")
local helper_d1f6cdc2 = require("@lib/event/helper_d1f6cdc2")
local helper_e1f02949 = require("@lib/event/helper_e1f02949")
local helper_f2dd5068 = require("@lib/event/helper_f2dd5068")

--- Helper function.
local function helper_7044c034(arg0: s32, arg1: s32)
	local var2: s32 = 0
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
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_d1f6cdc2(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_f2dd5068(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_a257284d(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_e1f02949(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_7044c034
