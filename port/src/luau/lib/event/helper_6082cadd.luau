--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_6082cadd()
	event.Initialize()
	event.SetCameraRef(225.0, 30.0, 280.0)
	event.SetCameraPos(225.0, 30.0, 160.0)
	event.SetCharaPos(0, 225.0, 0.0, 280.0)
	event.SetCharaRot(0, 0.0, -3.14, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
end

return helper_6082cadd
