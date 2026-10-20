--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ae935f0 = require("@lib/monster/helper_1ae935f0")
local helper_7ca8a12f = require("@lib/monster/helper_7ca8a12f")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_c6577076 = require("@lib/monster/helper_c6577076")

--- Helper function.
local function helper_c4b4113f()
	local argc: s32 = 0
	vm.wait()
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		monster.SetMos("立ち", -1, 0)
		helper_890ee63a(10.0)
		helper_1ae935f0(9.0, 45.0, 0.5, 27)
		monster.SetMos("立ち", -1, 0)
		helper_c3e8ae39(3)
	else
		argc = monster.GetRnd(100) or argc
		if argc < 50 then
			monster.SetMos("立ち", -1, 0)
			helper_7ca8a12f(100.0, 45.0, 30)
		else
			monster.SetMos("立ち", -1, 0)
			helper_890ee63a(10.0)
			helper_c6577076()
		end
	end
end

return helper_c4b4113f
