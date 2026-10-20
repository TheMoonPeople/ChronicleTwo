--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06d53ec5 = require("@lib/event/helper_06d53ec5")

--- Helper function.
local function helper_30652181(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_06d53ec5(1080010)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -167.59, 50.0, 2.86)
	event.ObjsSetRot(0, 0.0, 1.77, 0.0)
	event.ObjsSetMotion(0, "勝利のポーズ", 4)
	event.CharaActive(1, 9)
	event.ObjsSetPos(1, -167.59, 50.0, 2.86)
	event.ObjsSetRot(1, 0.0, 1.77, 0.0)
	event.ObjsSetMotion(1, "勝利のポーズ", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_06d53ec5(1080010)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	event.SndSeStop(arg0, 0)
end

return helper_30652181
