--!strict
-- Shared monster helper used by 21 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_317bfc18(arg0: s32)
	if arg0 ~= 0 then
		monster.SetAttrib(4, 1)
		monster.SetAttrib(256, 1)
		monster.SetAttrib(8, 1)
	else
		monster.SetAttrib(4, 0)
		monster.SetAttrib(256, 0)
		monster.SetAttrib(8, 0)
	end
end

return helper_317bfc18
