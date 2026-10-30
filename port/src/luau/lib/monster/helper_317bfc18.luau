--!strict
-- Shared monster helper used by 21 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_317bfc18(arg0: s32)
	if arg0 ~= 0 then
		monster.set_monster_attributes(4, 1)
		monster.set_monster_attributes(256, 1)
		monster.set_monster_attributes(8, 1)
	else
		monster.set_monster_attributes(4, 0)
		monster.set_monster_attributes(256, 0)
		monster.set_monster_attributes(8, 0)
	end
end

return helper_317bfc18
