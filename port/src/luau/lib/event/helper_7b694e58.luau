--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7f75e08e = require("@lib/event/helper_7f75e08e")
local helper_a2a9cc01 = require("@lib/event/helper_a2a9cc01")

--- Helper function.
local function helper_7b694e58(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f75e08e(15)
		end
		if at <= 2 then
			helper_a2a9cc01(2030060)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(0, 11)
	event.CharaActive(1, 33)
	event.SpriteSetPutsize(1, 512.0, 416.0)
	event.SpriteSetDraw(1, 1)
	event.ObjsSetPos(11, 256.0, 208.0, 10.0)
	event.ObjsSetColor(11, 128.0, 128.0, 128.0, 128.0, 15)
	helper_7f75e08e(15)
	if vm.skipping() then
		return skip(2)
	end
	event.SpriteSetDraw(0, 0)
	helper_a2a9cc01(2030060)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_7b694e58
