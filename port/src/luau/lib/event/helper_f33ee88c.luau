--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7f75e08e = require("@lib/event/helper_7f75e08e")
local helper_a2a9cc01 = require("@lib/event/helper_a2a9cc01")

--- Helper function.
local function helper_f33ee88c(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f75e08e(15)
		end
		if at <= 2 then
			helper_a2a9cc01(2030070)
		end
		if at <= 3 then
			helper_a2a9cc01(2030073)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SpriteSetPutsize(2, 512.0, 416.0)
	event.SpriteSetDraw(2, 1)
	event.ObjsSetPos(12, 256.0, 208.0, 10.0)
	event.ObjsSetColor(12, 128.0, 128.0, 128.0, 128.0, 15)
	helper_7f75e08e(15)
	if vm.skipping() then
		return skip(2)
	end
	event.SpriteSetDraw(1, 0)
	helper_a2a9cc01(2030070)
	if vm.skipping() then
		return skip(3)
	end
	helper_a2a9cc01(2030073)
	if vm.skipping() then
		return skip(4)
	end
end

return helper_f33ee88c
