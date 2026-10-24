--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_278438ff()
	local flag: s32 = 0
	flag = event.GetFlag(536) or flag
	event.GetFlag(540)
	if flag == 1 then
		event.AssignStack(4)
		event.ClearStack(4)
		event.LoadChara(4, "chara/p00_05a.gltf", "info", 8)
		event.CharaActive(8)
		event.SetCharaPos(8, 0.0, 70.0, -80.0)
		event.SetCharaRot(8, 0.0, 0.0, 0.0)
		event.SetMotion(8, "立ち", 4)
		event.SetCharaNo(8, 400)
	end
end

return helper_278438ff
