--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_e6998a9e()
	event.Initialize()
	event.SetCameraRef(225.0, 30.0, 280.0)
	event.SetCameraPos(225.0, 30.0, 160.0)
	event.SetCharaPos(0, 200.0, 0.0, -20.8)
	event.SetCharaRot(0, 0.0, 1.89, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
end

return helper_e6998a9e
