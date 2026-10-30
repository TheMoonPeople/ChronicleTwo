--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_6d5002db = require("@lib/monster/helper_6d5002db")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")

--- Helper function.
local function helper_3cc46fef()
	monster.set_motion("歩き", -1, 0)
	helper_890ee63a(3.0)
	monster.set_motion("攻撃２", -1, 2)
	helper_c3e8ae39(8)
	helper_6d5002db(4.5, 6.0, 1.0, 17)
	helper_c3e8ae39(9)
	monster.set_motion("立ち", -1, 0)
	helper_c3e8ae39(9)
end

return helper_3cc46fef
