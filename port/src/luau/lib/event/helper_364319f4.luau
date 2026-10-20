--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_364319f4()
	event.Initialize()
	event.AssignStack(4)
	event.ClearStack(4)
	event.LoadCharaNpc(0, 4, 24, 28)
	event.SetCharaPos(28, -69.3, 0.0, 124.6)
	event.SetCharaRot(28, 0.0, 2.97, 0.0)
	event.SetMotion(28, "立ち", 4)
	event.SetCharaNo(28, 24)
	event.RegisterVillager(28, 24)
	event.CharaActive(28)
end

return helper_364319f4
