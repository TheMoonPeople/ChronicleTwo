--!strict
-- Shared monster helper used by 50 scripts, translated by tools/luau/stb2luau.

local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_408a011b = require("@lib/monster/helper_408a011b")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")

--- Helper function.
local function helper_83e135e0(arg0: f32)
	local var5: f32 = 0
	helper_82cb5588(helper_787df986(arg0))
	var5 = monster.GetTargetAngle() or var5
	local _ = helper_408a011b(helper_28452e16(var5), arg0, 360.0)
	helper_442b9962()
end

return helper_83e135e0
