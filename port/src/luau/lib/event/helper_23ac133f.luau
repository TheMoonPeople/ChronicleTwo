--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_23ac133f()
	local var0: s32 = 0
	local flag: s32 = 0
	event.AssignStack(4)
	event.ClearStack(4)
	var0 = event.GetChapter() or var0
	if var0 ~= 6 and var0 ~= 7 then
		event.LoadChara(4, "chara/p01_03a.gltf", "info", 24)
		event.SetCharaPos(24, -123.0, 36.0, -68.0)
		event.SetCharaRot(24, 0.0, -1.57, 0.0)
		event.SetCharaNo(24, 1)
		event.RegisterVillager(24, 1)
	else
		event.LoadChara(4, "chara/p00_31a.gltf", "info", 24)
		event.SetCharaPos(24, -123.0, 36.0, -68.0)
		event.SetCharaRot(24, 0.0, -1.57, 0.0)
		event.SetCharaNo(24, 301)
		event.RegisterVillager(24, 301)
	end
	flag = event.GetFlag(500) or flag
	if flag == 0 then
		event.LoadChara(4, "chara/p01_06a.gltf", "info", 25)
		event.SetCharaPos(25, -99.9, 36.0, 456.5)
		event.SetCharaRot(25, 0.0, -1.5, 0.0)
		event.SetCharaNo(25, 2)
		event.RegisterVillager(25, 2)
		event.LoadChara(4, "chara/p01_07a.gltf", "info", 26)
		event.SetCharaPos(26, -99.6, 36.0, 855.2)
		event.SetCharaRot(26, 0.0, -2.37, 0.0)
		event.SetCharaNo(26, 13)
		event.RegisterVillager(26, 13)
	end
end

return helper_23ac133f
