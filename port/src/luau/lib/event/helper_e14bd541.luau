--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_e14bd541()
	local stage_id: s32 = 0
	local var1: s32 = 0
	stage_id = event.get_dungeon_stage_id() or stage_id
	var1 = 0
	if stage_id == 0 or stage_id == 1 then
		var1 = 110
	end
	if false then
		var1 = 111
	end
	if stage_id == 2 or stage_id == 3 or stage_id == 4 or stage_id == 5 then
		var1 = 112
	end
	return var1
end

return helper_e14bd541
