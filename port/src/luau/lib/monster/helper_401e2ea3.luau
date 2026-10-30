--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")
local helper_b44fbfb2 = require("@lib/monster/helper_b44fbfb2")

--- Helper function.
local function helper_401e2ea3(arg0: f32)
	local var5: f32 = 0
	helper_82cb5588(helper_787df986(arg0))
	var5 = monster.get_target_angle() or var5
	local _ = helper_b44fbfb2(helper_28452e16(var5), arg0, 360.0)
	helper_442b9962()
end

return helper_401e2ea3
