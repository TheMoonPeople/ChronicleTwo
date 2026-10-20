--!strict
-- Shared monster helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_95828c6f()
	local gekirin: s32 = 0
	gekirin = vm.float_bits(monster.GetGekirin()) or gekirin
	if gekirin > 0 then
		monster.SetModelLightSwitch(0)
	else
		monster.SetModelLightSwitch(1)
	end
end

return helper_95828c6f
