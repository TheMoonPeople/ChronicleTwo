--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a2a9cc01 = require("@lib/event/helper_a2a9cc01")

--- Helper function.
local function helper_6616289e(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a2a9cc01(2030030)
		end
		if at <= 2 then
			helper_a2a9cc01(2030040)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(0, 33)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "ぼうぜん顔")
	event.ObjsTexAnime(0, 1, "まばたき目パチ")
	event.CmrsSetPos(8.87, 61.22, 40.34)
	event.CmrsSetRef(2.69, 59.0, 20.67)
	event.CmrsMove2(7.72, 61.22, 36.68, 2.69, 59.0, 20.67, 450, 2, 0.4)
	helper_a2a9cc01(2030030)
	if vm.skipping() then
		return skip(2)
	end
	helper_a2a9cc01(2030040)
	if vm.skipping() then
		return skip(3)
	end
	event.PlayBgm(0)
end

return helper_6616289e
