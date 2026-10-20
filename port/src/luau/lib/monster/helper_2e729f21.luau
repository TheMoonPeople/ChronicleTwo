--!strict
-- Shared monster helper used by 16 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_2e729f21()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.SetPos(pos_x, pos_y + 1.0, pos_z)
end

return helper_2e729f21
