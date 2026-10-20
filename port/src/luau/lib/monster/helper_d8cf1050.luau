--!strict
-- Shared monster helper used by 24 scripts, translated by tools/luau/stb2luau.

local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")

--- Helper function.
local function helper_d8cf1050()
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.ResetMotion()
	monster.ResetMove()
	helper_442b9962()
	helper_93495fdf()
	helper_0ba23e4e()
	monster.SetActStatus(1)
end

return helper_d8cf1050
