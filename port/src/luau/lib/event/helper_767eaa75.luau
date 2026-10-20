--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b00d0a6d = require("@lib/event/helper_b00d0a6d")

--- Helper function.
local function helper_767eaa75(arg0: s32, arg1: f32, arg2: s32, arg3: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b00d0a6d(arg0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg3 ~= 0 then
		helper_b00d0a6d(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
	if arg2 ~= 0 then
		event.SetCrossfade(10)
	end
end

return helper_767eaa75
