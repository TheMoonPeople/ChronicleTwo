--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_7ca8a12f = require("@lib/monster/helper_7ca8a12f")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_c6577076 = require("@lib/monster/helper_c6577076")

--- Helper function.
local function helper_bf1e34ad()
	local argc: s32 = 0
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		argc = monster.GetRnd(100) or argc
		if argc < 50 then
			monster.SetMos("立ち", -1, 0)
			helper_890ee63a(10.0)
		end
		helper_c6577076()
	else
		monster.SetMos("立ち", -1, 0)
		helper_7ca8a12f(50.0, 45.0, 30)
	end
end

return helper_bf1e34ad
