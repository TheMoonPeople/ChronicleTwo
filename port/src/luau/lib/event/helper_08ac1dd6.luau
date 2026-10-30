--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_08ac1dd6(arg0: f32, frame: s32)
	event.move_object_sequence_eased(2, 0.0, -24.0, -1000.0 + arg0, frame, 2, 0.4)
end

return helper_08ac1dd6
