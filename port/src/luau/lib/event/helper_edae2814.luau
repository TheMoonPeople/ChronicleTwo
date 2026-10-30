--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")

--- Helper function.
local function helper_edae2814(arg0: any)
	event.set_object_sequence_motion(0, "上見立ち", 4)
	event.reset_object_sequence_dynamic_animation(0)
	event.set_object_sequence_motion(2, "スコップ立ち", 4)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(2030010)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(2030015)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(2030020)
	event.reset_mouth_texture_animations()
end

return helper_edae2814
