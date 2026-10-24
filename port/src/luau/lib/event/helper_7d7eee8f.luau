--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_7d7eee8f(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	event.SetCharaPos(0, arg0, arg1, arg2)
	event.SetCharaRot(0, 0.0, arg3, 0.0)
	event.SetMotion(0, "立ち")
end

return helper_7d7eee8f
