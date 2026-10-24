--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_bfd51d93()
	event.ChangeDir("chara/")
	event.LoadChara(5, "p03_37a.gltf", "info", 13)
	event.LoadChara(5, "p03_38a.gltf", "info", 14)
	event.LoadChara(5, "p03_39a.gltf", "info", 15)
	event.LoadChara(5, "p03_20a.gltf", "info", 16)
	event.LoadChara(5, "p03_22a.gltf", "info", 17)
	event.LoadChara(5, "p03_24a.gltf", "info", 18)
	event.ChangeDir("")
	for var0 = 0, 5 do
		event.CharaActive(1, 13 + var0)
		event.EohSyncChara(5 + var0, 13 + var0)
		event.ObjsInit(5 + var0)
		event.ObjsSyncObj(5 + var0, 5 + var0)
	end
end

return helper_bfd51d93
