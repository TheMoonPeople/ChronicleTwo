--!strict
-- Shared monster helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_95828c6f()
	local gekirin: s32 = 0
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if gekirin > 0 then
		monster.set_model_lighting(0)
	else
		monster.set_model_lighting(1)
	end
end

return helper_95828c6f
