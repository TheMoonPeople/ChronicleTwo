--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_070407de = require("@lib/event/helper_070407de")

--- Helper function.
local function helper_bcc08366(arg0: any, arg1: f32, arg2: any, arg3: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_070407de(arg0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg3 ~= 0 then
		helper_070407de(arg0, arg1)
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

return helper_bcc08366
