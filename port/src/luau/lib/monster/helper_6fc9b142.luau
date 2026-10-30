--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_bee0409d = require("@lib/monster/helper_bee0409d")

--- Helper function.
local function helper_6fc9b142()
	local var0: s32 = 0
	while true do
		helper_bee0409d()
		var0 = monster.is_motion_finished() or var0
		if var0 ~= 0 then
			return
		end
	end
end

return helper_6fc9b142
