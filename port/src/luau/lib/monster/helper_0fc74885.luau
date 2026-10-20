--!strict
-- Shared monster helper used by 57 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_270cad62 = require("@lib/monster/helper_270cad62")

--- Helper function.
local function helper_0fc74885()
	local life: s32 = 0
	local value: s32 = 0
	value = monster.VPop2(4) or value
	life = monster.GetActiveMonsLifei(-1) or life
	if life <= 0 then
		monster.VPush2(4, life)
		return 1
	end
	if vm.i32(life - value) < 0 then
		monster.VPush2(4, life)
		helper_270cad62(life, value)
		return 2
	end
	monster.VPush2(4, life)
	return 0
end

return helper_0fc74885
