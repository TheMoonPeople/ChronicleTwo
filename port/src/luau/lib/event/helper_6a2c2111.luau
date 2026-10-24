--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_6a2c2111()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadChara(5, "event/e600/e616/e616_toryon.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.EohSyncChara(3, 39)
	event.ObjsInit(3, 39)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "event/e600/e616/e616_iwa.gltf", "info", 40)
	event.CharaActive(0, 40)
	event.EohSyncChara(4, 40)
	event.ObjsInit(4, 40)
	event.ObjsSyncObj(4, 4)
	event.CopyChara(5, 40, 41)
	event.CharaActive(0, 41)
	event.EohSyncChara(5, 41)
	event.ObjsInit(5, 41)
	event.ObjsSyncObj(5, 5)
end

return helper_6a2c2111
