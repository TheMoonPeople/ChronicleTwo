--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")

--- Helper function.
local function helper_d041fc4b()
	monster.set_motion("歩き", -1, 0)
	helper_890ee63a(3.0)
	monster.set_motion("攻撃３", -1, 2)
	helper_c3e8ae39(28)
	monster.set_motion("立ち", -1, 0)
	helper_c3e8ae39(9)
end

return helper_d041fc4b
