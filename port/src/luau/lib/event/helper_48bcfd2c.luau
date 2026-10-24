--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0347c33d = require("@lib/event/helper_0347c33d")
local helper_22e96f02 = require("@lib/event/helper_22e96f02")
local helper_abdec2fb = require("@lib/event/helper_abdec2fb")
local helper_cb5998be = require("@lib/event/helper_cb5998be")

--- Helper function.
local function helper_48bcfd2c(arg0: s32, arg1: s32)
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
		helper_22e96f02(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_0347c33d(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_abdec2fb(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_cb5998be(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_48bcfd2c
