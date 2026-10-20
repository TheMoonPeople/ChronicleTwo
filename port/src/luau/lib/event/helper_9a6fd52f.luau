--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_184013af = require("@lib/event/helper_184013af")

--- Helper function.
local function helper_9a6fd52f()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			if vm.skip_end() then
				return skip(2)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.DeleteChara(32)
		event.CharaActive(1, 0)
		event.SetFadeIn(30)
	end
	event.Initialize()
	event.LoadSound(1240)
	event.SndLoadSound(1240)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadChara(5, "event/e100/e109/e109_starbre.gltf", "info", 32)
	event.EohSyncChara(0, 32)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.EohSyncObj(1, "p01_e03h03-0")
	event.EohSetShow(1, 0)
	event.InitDramaScene()
	event.SetFadeIn(30)
	event.CharaActive(0, 0)
	event.CharaActive(1, 32)
	event.CmrsSetPos(1992.97, 34.74, 2905.51)
	event.CmrsSetRef(2030.46, 40.14, 2965.77)
	event.ObjsSetPos(0, 2129.53, 0.0, 3073.66)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.CmrsMove2(1713.52, 39.48, 2489.48, 1730.42, 46.55, 2524.75, 150, 2, 0.4)
	event.ObjsSetMotion(0, "歩き２", 4)
	event.ObjsMove(0, 2128.59, 26.83, 3265.59, 150, 1)
	event.CmrsFadeInit()
	event.CmrsFadeDelay(120)
	event.CmrsFadeOut(30)
	helper_184013af()
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsInit()
	return part2()
end

return helper_9a6fd52f
