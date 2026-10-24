--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_983c5580(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.LoadChara(6, "event/e200/e250/e250_toryon.gltf", "info", 42)
	event.EohSyncChara(9, 42)
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.CharaActive(0, 42)
	event.EohSetSoundId(9, arg0)
	event.LoadChara(6, "event/lm/e250r/e250_tree.gltf", "info", 43)
	event.EohSyncChara(10, 43)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.CharaActive(0, 43)
	event.SetReference(42, "R_tree", 43)
	event.LoadChara(6, "event/lm/e250r/e250_tree.gltf", "info", 44)
	event.EohSyncChara(11, 44)
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.CharaActive(0, 44)
	event.SetReference(42, "L_tree", 44)
	event.LoadChara(6, "event/e200/e250/e250_konoha.gltf", "info", 46)
	event.CharaActive(0, 46)
	event.EohSyncChara(15, 46)
	event.ObjsInit(14)
	event.ObjsSyncObj(14, 15)
	event.LoadChara(6, "event/e200/e250/shuchusen.gltf", "info", 45)
	event.EohSyncChara(14, 45)
	event.ObjsInit(13)
	event.ObjsSyncObj(13, 14)
	event.CharaActive(0, 45)
end

return helper_983c5580
