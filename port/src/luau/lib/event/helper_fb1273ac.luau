--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2f481f12 = require("@lib/event/helper_2f481f12")

--- Helper function.
local function helper_fb1273ac()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2f481f12(60)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.CmrsInit()
	event.CmrsSetPos(-2098.32, 112.9, 2914.62)
	event.CmrsSetRef(-2002.24, 24.33, 3103.52)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, -1953.35, -38.07, 3352.55)
	event.ObjsSetRot(0, 0.0, -2.4, 0.0)
	event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 60)
	event.ObjsAddPas(0, -1953.35, -38.07, 3352.55)
	event.ObjsAddPas(0, -1973.62, -28.53, 3308.18)
	event.ObjsAddPas(0, -1994.79, -9.95, 3175.09)
	event.ObjsAddPas(0, -2000.28, 0.23, 3105.85)
	event.ObjsStartPas(0)
	event.SetFadeIn(30)
	helper_2f481f12(60)
	if vm.skipping() then
		return skip(2)
	end
	event.EohSetFootSoundId(0, 0)
	event.ResetCamera(0)
end

return helper_fb1273ac
