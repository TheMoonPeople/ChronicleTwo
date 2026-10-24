--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_d07bc9de = require("@lib/event/helper_d07bc9de")

--- Helper function.
local function helper_20e47713()
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
		event.DeleteChara(32)
		event.CharaActive(1, 0)
		event.SetFadeIn(30)
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadChara(5, "event/e100/e109/e109_starbre.gltf", "info", 32)
	event.EohSyncChara(0, 32)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.InitDramaScene()
	event.CharaActive(0, 0)
	event.CharaActive(1, 32)
	event.CmrsSetPos(2206.38, 45.78, 2788.73)
	event.CmrsSetRef(2151.7, 44.53, 2924.41)
	event.ObjsSetPos(0, 2105.62, 0.0, 2971.54)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.CmrsMove2(2585.56, 45.78, 2117.44, 2529.48, 44.53, 2252.55, 200, 2, 0.2)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 210)
	event.ObjsAddPas(0, 2105.62, 0.0, 2971.54)
	event.ObjsAddPas(0, 2089.82, 0.0, 3103.38)
	event.ObjsAddPas(0, 2075.37, 0.0, 3210.94)
	event.ObjsAddPas(0, 2068.3, 32.6, 3283.51)
	event.ObjsAddPas(0, 2053.56, 65.0, 3353.79)
	event.ObjsStartPas(0)
	event.CmrsFadeInit()
	event.CmrsFadeDelay(170)
	event.CmrsFadeOut(30)
	helper_d07bc9de()
	if vm.skipping() then
		return skip(1)
	end
	return part2()
end

return helper_20e47713
