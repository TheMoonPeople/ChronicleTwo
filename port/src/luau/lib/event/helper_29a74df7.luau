--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7f75e08e = require("@lib/event/helper_7f75e08e")
local helper_a2a9cc01 = require("@lib/event/helper_a2a9cc01")

--- Helper function.
local function helper_29a74df7(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f75e08e(15)
		end
		if at <= 2 then
			helper_a2a9cc01(2030090)
		end
		if at <= 3 then
			helper_a2a9cc01(2030100)
		end
		if at <= 4 then
			helper_7f75e08e(45)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "目パチ")
	event.ObjsSetMotion(0, "上見立ち", 4, -1.0, 1)
	event.ObjsSetColor(13, 0.0, 0.0, 0.0, 15)
	helper_7f75e08e(15)
	if vm.skipping() then
		return skip(2)
	end
	event.SpriteSetDraw(3, 0)
	event.CmrsMove2(10.91, 58.61, 33.87, 1.64, 58.99, 18.19, 300, 2, 0.4)
	helper_a2a9cc01(2030090)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsTexAnime(0, 1, "眉真剣")
	helper_a2a9cc01(2030100)
	if vm.skipping() then
		return skip(4)
	end
	event.StopBgm(0)
	event.SndSePlay(arg0, 5)
	event.CmrsQuake(0.0, 0.8, 0.0, 45)
	helper_7f75e08e(45)
	if vm.skipping() then
		return skip(5)
	end
end

return helper_29a74df7
