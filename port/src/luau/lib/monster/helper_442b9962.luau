--!strict
-- Shared monster helper used by 127 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_442b9962()
	local var1: f32 = 0
	do
		local _, out2, _ = monster.GetRot()
		var1 = out2 or var1
	end
	monster.SetNextRot(var1, 0)
end

return helper_442b9962
