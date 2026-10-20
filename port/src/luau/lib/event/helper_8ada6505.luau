--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")

--- Helper function.
local function helper_8ada6505()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_aafd6a80(30)
		end
		if at <= 2 then
			helper_aafd6a80(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.CmrsInit()
	event.CmrsSetPos(118.52, 56.61, 357.81)
	event.CmrsSetRef(114.8, 23.48, 466.86)
	event.SetCharaPos(0, 112.99, 3.46, 468.16)
	event.SetCharaRot(0, 0.0, -0.3215928, 0.0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSetFootSoundId(0, 16)
	event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
	event.ObjsMove(0, 47.34, -13.91, 606.83, 60, 1)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeOut(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(3)
	end
	event.EohSetFootSoundId(0, 0)
end

return helper_8ada6505
