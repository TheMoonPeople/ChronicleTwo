--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_c6124e13()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadChara(5, "event/e600/e616/e616_beam_f.gltf", "info", 40)
	event.CharaActive(0, 40)
	event.EohSyncChara(5, 40)
	event.ObjsInit(5, 40)
	event.ObjsSyncObj(5, 5)
	event.LoadChara(5, "event/e600/e616/e616_beam_h.gltf", "info", 41)
	event.CharaActive(0, 41)
	event.EohSyncChara(6, 41)
	event.ObjsInit(6, 41)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(5, "event/e600/e616/e616_tama.gltf", "info", 42)
	event.CharaActive(0, 42)
	event.EohSyncChara(7, 42)
	event.ObjsInit(7, 42)
	event.ObjsSyncObj(7, 7)
	event.EsmInitialize(5)
	event.EsmLoadBase("Ｅ６１６月花ビームＡ")
	event.EsmInitFix(5)
	event.EohSyncObj(4, "p01_s3202-0")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
end

return helper_c6124e13
