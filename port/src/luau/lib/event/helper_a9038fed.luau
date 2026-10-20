--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_bc77b237 = require("@lib/event/helper_bc77b237")

--- Helper function.
local function helper_a9038fed()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bc77b237(60)
		end
		if at <= 2 then
			helper_bc77b237(2)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 1)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 2492.28, 5.66, 457.27)
	event.ObjsSetRot(0, 0.0, -2.76, 0.0)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsMove(0, 2466.56, 6.63, 395.9, 60)
	event.CmrsSetRef(2466.56, 36.63, 395.98)
	event.CmrsSetPos(2513.1, 56.63, 506.94)
	event.SetFadeIn(30)
	helper_bc77b237(60)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_bc77b237(2)
	if vm.skipping() then
		return skip(3)
	end
	event.EohSetFootSoundId(0, 0)
end

return helper_a9038fed
