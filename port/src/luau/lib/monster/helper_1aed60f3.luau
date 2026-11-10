--!strict
-- Shared monster helper used by 57 scripts, translated by tools/luau/stb2luau.

local helper_750bcfec = require("@lib/monster/helper_750bcfec")
local helper_799e0706 = require("@lib/monster/helper_799e0706")
local helper_eb5090a5 = require("@lib/monster/helper_eb5090a5")

--- Helper function.
local function helper_1aed60f3()
	local var0: s32 = 0
	local var1: s32 = 0
	var0 = helper_799e0706(var0)
	if var0 <= 0 then
		return 0
	end
	var1 = helper_750bcfec(var1)
	if var1 < var0 then
		helper_eb5090a5(var1 + 1)
		return 0
	end
	helper_eb5090a5(0)
	return 1
end

return helper_1aed60f3
