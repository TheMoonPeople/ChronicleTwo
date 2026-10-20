--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_661ab502()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadChara(5, "event/e700/e732/e732_sun.gltf", "info", 35)
	event.CharaActive(0, 35)
	event.EohSyncChara(4, 35)
	event.ObjsInit(2, 35)
	event.ObjsSyncObj(2, 4)
	event.LoadChara(5, "event/e700/e732/e732_andrea.gltf", "info", 33)
	event.CharaActive(0, 33)
	event.EohSyncChara(5, 33)
	event.ObjsInit(3, 33)
	event.ObjsSyncObj(3, 5)
	event.LoadChara(5, "event/e700/e728/kaisou_waku.gltf", "info", 34)
	event.CharaActive(0, 34)
	event.SetCharaType(34, 4)
	event.LoadMes(0, 5, "event/e700/e732/e732_1.txt")
end

return helper_661ab502
