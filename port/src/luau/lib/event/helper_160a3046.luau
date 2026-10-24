--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_160a3046()
	local flag: s32 = 0
	vm.section(function()
		event.Initialize()
		event.AssignStack(5)
		event.ClearStack(5)
		event.LoadChara(5, "event/e300/e372/e372_waku2.gltf", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMes(0, 5, "event/e300/e372/e372_1.txt")
		flag = event.GetFlag(43) or flag
		if flag ~= 0 then
			event.StopBgm(0)
			helper_25abe6d2(4)
			event.LoadBgm(59)
			event.PlayBgm(0)
			event.SetFlag(43, 0)
		end
		event.InitDramaScene()
		event.CharaActive(0, 0)
		event.CharaActive(1, 32)
		event.SetCrossfade(0, 0, 90)
		event.CmrsSetPos(-178.53, 128.12, 2185.49)
		event.CmrsSetRef(-546.76, 268.24, 1697.27)
		event.ObjsSetPos(0, -546.76, 268.24, 1697.27)
		event.CmrsCharaAttach(32, 608.78, 99999999)
		event.CmrsMove2(1177.44, 128.12, 1162.78, 809.21, 268.24, 674.57, 600, 2, 0.4)
		helper_e34416e2(3720190)
		helper_e34416e2(3720200)
		helper_e34416e2(3720210)
		helper_e34416e2(3720220)
		event.CmrsInit()
		event.SetFadeOut(30)
		helper_25abe6d2(30)
	end)
	event.CancelDramaScene()
	event.DeleteChara(32)
end

return helper_160a3046
