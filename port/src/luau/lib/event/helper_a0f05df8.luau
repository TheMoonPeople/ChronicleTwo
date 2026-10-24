--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_508cbd1b = require("@lib/event/helper_508cbd1b")

--- Helper function.
local function helper_a0f05df8(arg0: s32, arg1: f32, arg2: f32)
	local var3: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	do
		local out1, _, out3 = event.GetCharaPos(arg0)
		var3 = out1 or var3
		var5 = out3 or var5
	end
	var6 = event.GetRotLookPos(arg1 - var3, arg2 - var5) or var6
	helper_508cbd1b(arg0, var6)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_a0f05df8
