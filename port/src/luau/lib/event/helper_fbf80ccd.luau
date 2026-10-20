--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_34e8eecb = require("@lib/event/helper_34e8eecb")

--- Helper function.
local function helper_fbf80ccd(arg0: any, arg1: f32, arg2: any, arg3: any, sp: number)
	local junk = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_34e8eecb(arg0, arg1, sp + junk + 5)
			junk += 1
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg3 ~= 0 then
		helper_34e8eecb(arg0, arg1, sp + junk + 4)
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

return helper_fbf80ccd
