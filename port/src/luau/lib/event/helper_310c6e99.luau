--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_310c6e99()
	local stage_id: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var1 = 0
		var1 = 110
		var1 = 111
		var1 = 112
		return var1
	end
	if vm.skipping() then
		return skip(1)
	end
	stage_id = event.DngGetStageId() or stage_id
	var1 = 0
	if stage_id == 0 or stage_id == 1 or stage_id == 6 then
		var1 = 110
	end
	if stage_id == 5 then
		var1 = 111
	end
	if stage_id == 2 or stage_id == 4 or stage_id == 3 then
		var1 = 112
	end
	return var1
end

return helper_310c6e99
