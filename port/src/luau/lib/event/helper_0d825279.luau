--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_0d825279(arg0: s32)
	local var1: s32 = 0
	if arg0 ~= 0 then
		var1 = 0
		while var1 < 10 do
			event.set_character_active(1, 42 + var1)
			event.set_character_motion(42 + var1, "水晶にお辞儀", 4)
			var1 = var1 + 1
		end
		event.set_character_position(42, 112.7, 453.82, 410.32)
		event.set_character_rotation(42, 0.0, -2.4, 0.0)
		event.set_character_position(43, -128.56, 453.82, 417.45)
		event.set_character_rotation(43, 0.0, 2.37, 0.0)
		event.set_character_position(44, -316.94, 453.82, 298.96)
		event.set_character_rotation(44, 0.0, 2.4, 0.0)
		event.set_character_position(45, -415.03, 453.82, 114.12)
		event.set_character_rotation(45, 0.0, 1.68, 0.0)
		event.set_character_position(46, -428.97, 453.82, -76.2)
		event.set_character_rotation(46, 0.0, 1.32, 0.0)
		event.set_character_position(47, 421.58, 453.82, 122.95)
		event.set_character_rotation(47, 0.0, -1.8, 0.0)
		event.set_character_position(48, 422.72, 453.82, -107.04)
		event.set_character_rotation(48, 0.0, -1.32, 0.0)
		event.set_character_position(49, -303.33, 453.82, -301.24)
		event.set_character_rotation(49, 0.0, 0.72, 0.0)
		event.set_character_position(50, 123.16, 453.82, -418.07)
		event.set_character_rotation(50, 0.0, -0.24, 0.0)
		event.set_character_position(51, -108.32, 453.82, -423.81)
		event.set_character_rotation(51, 0.0, 0.24, 0.0)
	else
		var1 = 0
		while var1 < 10 do
			event.set_character_active(0, 42 + var1)
			var1 = var1 + 1
		end
	end
end

return helper_0d825279
