--!strict
-- Shared monster helper used by 35 scripts, translated by tools/luau/stb2luau.

local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")
local helper_b823bc2c = require("@lib/monster/helper_b823bc2c")

--- Helper function.
local function helper_890ee63a(arg0: f32)
	local var5: f32 = 0
	local var8: f32 = 0
	helper_82cb5588(helper_787df986(arg0))
	var5 = monster.GetTargetAngle() or var5
	var8 = helper_b823bc2c(helper_28452e16(var5), arg0, 360.0)
	helper_442b9962()
	return var8
end

return helper_890ee63a
