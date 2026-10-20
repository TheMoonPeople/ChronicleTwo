--!strict
-- Shared monster helper used by 19 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_57b569a8(arg0: f32)
	local pos_y: f32 = 0
	local height: f32 = 0
	height = monster.GetHigh() or height
	do
		local _, out2, _ = monster.GetPos_3()
		pos_y = out2 or pos_y
	end
	arg0 = vm.f32(pos_y - height)
	return arg0
end

return helper_57b569a8
