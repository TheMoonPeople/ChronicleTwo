--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_7471d537()
	local life: s32 = 0
	while true do
		vm.wait()
		life = monster.get_life_int() or life
		if life ~= 0 then
			return
		end
	end
end

return helper_7471d537
