--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a8b5d854 = require("@lib/event/helper_a8b5d854")

--- Helper function.
local function helper_7cd6d4b5()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a8b5d854(60)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 1858.52, -189.52, 1308.84)
	event.ObjsSetRot(0, 0.0, -2.22, 0.0)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.CmrsSetPos(1910.24, -159.5, 1350.91)
	event.CmrsSetRef(1816.64, -159.5, 1274.78)
	event.ObjsMove(0, 1816.64, -189.5, 1274.78, 60)
	event.SetFadeIn(30)
	helper_a8b5d854(60)
	if vm.skipping() then
		return skip(2)
	end
	event.EohSetFootSoundId(0, -1)
	event.ResetCamera(0)
	event.Finish()
end

return helper_7cd6d4b5
