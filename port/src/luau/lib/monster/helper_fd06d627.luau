--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_64fbd1fc = require("@lib/monster/helper_64fbd1fc")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_79d6eaca = require("@lib/monster/helper_79d6eaca")
local helper_f50d89ab = require("@lib/monster/helper_f50d89ab")

--- Helper function.
local function helper_fd06d627(arg0: f32)
	local var5: f32 = 0
	helper_f50d89ab(helper_787df986(arg0))
	monster.call_command(75, var5) -- retail: the handler rejects 1 arguments
	local _ = helper_64fbd1fc(helper_28452e16(var5), arg0, 360.0)
	helper_79d6eaca()
end

return helper_fd06d627
