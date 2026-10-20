--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3060583d = require("@lib/event/helper_3060583d")
local helper_37bae0f9 = require("@lib/event/helper_37bae0f9")
local helper_8a456003 = require("@lib/event/helper_8a456003")
local helper_f3d8a633 = require("@lib/event/helper_f3d8a633")

--- Helper function.
local function helper_f016ef9c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_3060583d(arg0, arg1)
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
		helper_3060583d(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_f3d8a633(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_8a456003(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_37bae0f9(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_f016ef9c
