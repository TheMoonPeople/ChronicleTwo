--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0fdfd875 = require("@lib/monster/helper_0fdfd875")
local helper_12864d2e = require("@lib/monster/helper_12864d2e")
local helper_695eddd8 = require("@lib/monster/helper_695eddd8")
local helper_7b704f81 = require("@lib/monster/helper_7b704f81")
local helper_99918cd5 = require("@lib/monster/helper_99918cd5")

--- Helper function.
local function helper_4b32ee99()
	local value: s32 = 0
	value = monster.VPop(1) or value
	if value == 8 then
		helper_695eddd8()
	end
	if value == 9 then
		helper_7b704f81()
	end
	if value == 1 then
		helper_0fdfd875()
	end
	if value == 2 then
		helper_99918cd5()
	end
	if value == 7 then
		monster.SetMos("立ち")
		helper_12864d2e()
	end
end

return helper_4b32ee99
