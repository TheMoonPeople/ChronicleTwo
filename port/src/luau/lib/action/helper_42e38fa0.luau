--!strict
-- Shared action helper used by 17 scripts, translated by tools/luau/stb2luau.

local helper_9da84b8b = require("@lib/action/helper_9da84b8b")
local helper_bac4ec65 = require("@lib/action/helper_bac4ec65")

--- Helper function.
local function helper_42e38fa0()
	action.start_knockback(5.0, 0.0, 10)
	action.face_against_knockback()
	action.release_held_object(0)
	action.play_motion("吹っ飛び", -1, 6)
	helper_9da84b8b()
	helper_bac4ec65(8)
	action.play_motion("起き上がり", -1, 6)
	helper_9da84b8b()
	helper_bac4ec65(2)
	action.set_program_value(0)
end

return helper_42e38fa0
