--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_a0d546a7()
	event.Initialize()
	event.AssignStack(4)
	event.ClearStack(4)
	event.ChangeDir("event/e200/e209/")
	event.LoadChara(4, "e209_conda.gltf", "info", 8)
	event.SetCharaNo(8, 34)
	event.CharaActive(8)
	event.SetCharaPos(8, 59.82, 0.0, -98.58)
	event.SetCharaRot(8, 0.0, 0.0, 0.0)
	event.SetMotion(8, "座り")
	event.LoadChara(4, "e209_rococo.gltf", "info", 9)
	event.SetCharaNo(9, 151)
	event.CharaActive(9)
	event.SetCharaPos(9, 37.28, 0.0, -29.43)
	event.SetCharaRot(9, 0.0, 2.56, 0.0)
	event.SetMotion(9, "座り")
	event.LoadChara(4, "e209_tobo.gltf", "info", 10)
	event.SetCharaNo(10, 154)
	event.CharaActive(10)
	event.SetCharaPos(10, 21.3, 0.0, -61.73)
	event.SetCharaRot(10, 0.0, 1.32, 0.0)
	event.SetMotion(10, "座り")
	event.ChangeDir("")
end

return helper_a0d546a7
