--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a2a9cc01 = require("@lib/event/helper_a2a9cc01")

--- Helper function.
local function helper_c2c70878(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a2a9cc01(2030050)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SpriteSetPutsize(0, 512.0, 416.0)
	event.SpriteSetDraw(0, 1)
	event.ObjsSetPos(10, 256.0, 208.0, 10.0)
	event.ObjsSetColor(10, 128.0, 128.0, 128.0, 128.0, 30)
	helper_a2a9cc01(2030050)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_c2c70878
