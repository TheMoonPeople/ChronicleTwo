--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_d4581b6b()
	event.Initialize()
	event.AssignStack(4)
	event.ClearStack(4)
	event.LoadCharaNpc(0, 4, 24, 28)
	event.SetCharaPos(28, 42.4, 123.8, -110.2)
	event.SetCharaRot(28, 0.0, -0.31, 0.0)
	event.SetMotion(28, "立ち", 4)
	event.SetCharaNo(28, 24)
	event.RegisterVillager(28, 24)
	event.CharaActive(28)
end

return helper_d4581b6b
