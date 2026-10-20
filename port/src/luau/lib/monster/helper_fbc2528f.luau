--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_274f6d9a = require("@lib/monster/helper_274f6d9a")

--- Helper function.
local function helper_fbc2528f()
	local var0: s32 = 0
	while true do
		helper_274f6d9a()
		var0 = monster.CheckMosEnd() or var0
		if var0 ~= 0 then
			return
		end
	end
end

return helper_fbc2528f
