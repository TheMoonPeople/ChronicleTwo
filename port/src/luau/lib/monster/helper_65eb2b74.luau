--!strict
-- Shared monster helper used by 57 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_65eb2b74(arg0: s32)
	monster.VPush2(5, arg0)
	if arg0 == 0 then
		monster.SetEscapeRate(-1, 1.0)
		monster.SetGuardRate(-1, 1.0)
	end
end

return helper_65eb2b74
