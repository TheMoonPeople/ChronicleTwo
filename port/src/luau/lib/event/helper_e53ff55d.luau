--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7f75e08e = require("@lib/event/helper_7f75e08e")

--- Helper function.
local function helper_e53ff55d(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f75e08e(23)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(0, 11)
	event.CharaActive(1, 35)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おどろき顔")
	event.ObjsTexAnime(0, 1, "おどろき目パチ")
	event.SndSePlay(arg0, 6)
	event.ObjsSetMotion(0, "振り返る", 6)
	event.ObjsResetDaPosition(0)
	event.ObjsNextMotion(0, "振り返るL", 0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(3, "立ち", 4)
	helper_7f75e08e(23)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_e53ff55d
