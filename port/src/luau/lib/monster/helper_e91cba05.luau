--!strict
-- Shared monster helper used by 57 scripts, translated by tools/luau/stb2luau.

local helper_0fc74885 = require("@lib/monster/helper_0fc74885")
local helper_a25c5b2e = require("@lib/monster/helper_a25c5b2e")
local helper_c94eec30 = require("@lib/monster/helper_c94eec30")
local helper_e00d263f = require("@lib/monster/helper_e00d263f")

--- Helper function.
local function helper_e91cba05()
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	var2 = helper_0fc74885()
	if var2 == 2 then
		var3, var4 = helper_c94eec30(var3, var4)
		var5 = helper_e00d263f(var5)
		if helper_a25c5b2e() == 0 and var4 > var5 then
			print("dmg=", var4, "------------------\n")
			monster.VPush2(5, 1)
		end
	end
end

return helper_e91cba05
