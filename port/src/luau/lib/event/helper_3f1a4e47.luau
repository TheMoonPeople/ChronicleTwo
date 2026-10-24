--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_3f1a4e47()
	local var0: s32 = 0
	local flag: s32 = 0
	event.AssignStack(4)
	event.ClearStack(4)
	var0 = event.GetChapter() or var0
	if var0 ~= 6 and var0 ~= 7 then
		event.LoadChara(4, "chara/p01_03a.gltf", "info", 8)
		event.CharaActive(8)
		event.SetCharaPos(8, -2030.0, 30.0, -100.0)
		event.SetCharaRot(8, 0.0, 3.14, 0.0)
		event.SetCharaNo(8, 1)
		event.RegisterVillager(8, 1)
	else
		event.LoadChara(4, "chara/p00_31a.gltf", "info", 8)
		event.CharaActive(8)
		event.SetCharaPos(8, -2030.0, 30.0, -100.0)
		event.SetCharaRot(8, 0.0, 3.14, 0.0)
		event.SetCharaNo(8, 301)
		event.RegisterVillager(8, 301)
	end
	flag = event.GetFlag(500) or flag
	if flag == 0 then
		event.LoadChara(4, "chara/p01_06a.gltf", "info", 9)
		event.CharaActive(9)
		event.SetCharaPos(9, -1045.1, 29.2, -103.3)
		event.SetCharaRot(9, 0.0, 3.1415927, 0.0)
		event.SetCharaNo(9, 2)
		event.RegisterVillager(9, 2)
		event.LoadChara(4, "chara/p01_07a.gltf", "info", 10)
		event.CharaActive(10)
		event.SetCharaPos(10, -707.6, -10.0, -172.5)
		event.SetCharaRot(10, 0.0, 0.0, 0.0)
		event.SetCharaNo(10, 13)
		event.RegisterVillager(10, 13)
	end
end

return helper_3f1a4e47
