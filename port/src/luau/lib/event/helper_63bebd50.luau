--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_63bebd50()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.ChangeDir("event/e200/e207/")
	event.LoadChara(5, "e207_starbre.gltf", "info", 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CharaActive(1, 34)
	event.LoadChara(5, "e207_vorneo.gltf", "info", 35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.CharaActive(1, 35)
	event.EohSyncObj(5, "p01_train01")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ChangeDir("")
	event.LoadChara(5, "event/e200/e280/e280_tom.gltf", "info", 36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.CharaActive(1, 36)
	event.EohSyncObj(6, "p01_s0201", "s0208-m0")
	event.EohSetShow(6, 0)
	event.EohSyncObj(7, "p01_s0201", "s0208-m1")
	event.EohSetShow(7, 0)
	event.EohSyncObj(8, "p01_s0201", "s0208-m2")
	event.EohSetShow(8, 0)
	event.EohSyncObj(9, "p01_s0201", "s0208-m3")
	event.EohSetShow(9, 0)
	event.EohSyncObj(10, "p01_s0201", "s0213-m0")
	event.EohSetShow(10, 0)
	event.CharaActive(0, 8)
	event.CharaActive(0, 9)
	event.CharaActive(0, 10)
	event.LoadMes(0, 5, "event/e200/e280/e280c_1.txt")
end

return helper_63bebd50
