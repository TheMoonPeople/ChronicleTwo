--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_2b01dbd7()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadChara(5, "event/e200/e209/e209_minchu.gltf", "info", 32)
	event.EohSyncChara(0, 32)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CharaActive(0, 32)
	event.LoadChara(5, "event/e200/e209/e209_eina.gltf", "info", 33)
	event.EohSyncChara(1, 33)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.CharaActive(0, 33)
	event.LoadChara(5, "event/e200/e209/e209_pai_b.gltf", "info", 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CharaActive(0, 34)
	event.LoadChara(5, "event/e200/e209/e209_pai_s.gltf", "info", 36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.CharaActive(0, 36)
	event.LoadChara(5, "event/e200/e209/e209_osara.gltf", "info", 35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.CharaActive(0, 35)
	event.LoadMes(0, 5, "event/e200/e209/e209.txt")
	event.CharaActive(0, 0)
end

return helper_2b01dbd7
