--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")

--- Helper function.
local function helper_a7a840ba()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_c1c32f84(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(15)
	event.CmrsSetPos(-564.69, 162.76, -362.47)
	event.CmrsSetRef(-556.95, 162.37, -243.12)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, -558.43, 132.37, -264.95)
	event.ObjsSetRot(0, 0.0, 0.13, 0.0)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsMove(0, -556.95, 132.37, -243.12, 30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetCamera(0)
end

return helper_a7a840ba
