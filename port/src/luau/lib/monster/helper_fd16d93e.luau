--!strict
-- Shared monster helper used by 42 scripts, translated by tools/luau/stb2luau.

local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")

--- Helper function.
local function helper_fd16d93e()
	monster.SetIntFlag(1, 1)
	monster.SetIntFlag(2, 1)
	monster.ResetMotion()
	monster.ResetMove()
	helper_442b9962()
	helper_93495fdf()
	helper_b9fff8e1()
	monster.SetActStatus(1)
end

return helper_fd16d93e
