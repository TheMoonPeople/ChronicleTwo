--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7ca8a12f = require("@lib/monster/helper_7ca8a12f")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_d8c5ceae = require("@lib/monster/helper_d8c5ceae")

--- Helper function.
local function helper_0fbe415e(arg0: s32)
	local var1: s32 = 0
	local argc: s32 = 0
	for var2 = 0, arg0 - 1 do
		vm.wait()
		monster.reset_motion()
		monster.set_motion("遊び", -1, 2)
		var1 = helper_7ca8a12f(49.0, 90.0, helper_9df6409a(56))
		if var1 == 1 then
			argc = monster.get_random(100) or argc
			if argc < 50 then
				monster.set_motion("歩き", 0.65, 0)
				helper_890ee63a(4.0)
				helper_d8c5ceae()
				monster.set_motion("歩き", 0.65, 0)
				helper_890ee63a(4.0)
				monster.set_motion("立ち", -1, 0)
			end
		end
		monster.set_motion("立ち", -1, 0)
		helper_7ca8a12f(49.0, 90.0, 30)
	end
end

return helper_0fbe415e
