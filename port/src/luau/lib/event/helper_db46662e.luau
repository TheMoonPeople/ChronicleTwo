--!strict
-- Shared event helper used by 15 scripts, translated by tools/luau/stb2luau.

local helper_194337c1 = require("@lib/event/helper_194337c1")
local helper_48c10ac3 = require("@lib/event/helper_48c10ac3")
local helper_5c559bd8 = require("@lib/event/helper_5c559bd8")
local helper_8ab07f4b = require("@lib/event/helper_8ab07f4b")
local helper_f8bbcc57 = require("@lib/event/helper_f8bbcc57")

--- Helper function.
local function helper_db46662e()
	local var0: s32 = 0
	local var9: f32 = 0
	local var10: s32 = 0
	helper_8ab07f4b(0, 1)
	var9 = helper_5c559bd8(var0, 0, 0)
	helper_48c10ac3(0, -1, var0, var10, 0)
	local _ = helper_f8bbcc57(0, -1, 5, 256, 208, 2, 0)
	helper_48c10ac3(0, -1, var0, var10, 0)
	helper_194337c1(var0, var9, 0, 0)
	return 1
end

return helper_db46662e
