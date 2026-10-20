--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_23bda4ba = require("@lib/event/helper_23bda4ba")

--- Helper function.
local function helper_5df8cf36(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_23bda4ba(3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-185.33, 99.15, 43.77)
	event.CmrsSetRef(13.63, 115.02, 19.38)
	event.CharaActive(0, 0)
	event.CharaActive(0, 9)
	event.CharaActive(1, 10)
	event.ObjsSetPos(2, 10.66, 50.0, -0.04)
	event.ObjsSetRot(2, 0.0, -1.32, 0.0)
	event.ObjsSetScale(2, 1.2, 1.2, 1.2)
	event.ObjsSetMotion(2, "立ち", 4)
	event.CharaActive(1, 11)
	event.ObjsSetPos(3, 35.03, 189.68, 41.92)
	event.ObjsSetRot(3, 0.0, -1.56, 0.0)
	event.SndSePlay(arg0, 6)
	event.ObjsSetMotion(3, "浮遊", 4)
	event.ObjsMove(3, 35.03, 137.05, 41.92, 100)
	helper_23bda4ba(3)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_5df8cf36
