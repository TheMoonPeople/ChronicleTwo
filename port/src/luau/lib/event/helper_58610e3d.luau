--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_58610e3d()
	event.Initialize()
	event.SetMesWindowMode(0, 0)
	event.SetCharaPos(0, -600.0, 0.0, -600.0)
	event.SetCharaRot(0, 0.0, -2.23, 0.0)
	event.ResetCamera(1, 3.14, 20.0)
	event.SetFadeIn(30)
	event.SetNpcStatus(26, 0)
	event.Finish()
end

return helper_58610e3d
