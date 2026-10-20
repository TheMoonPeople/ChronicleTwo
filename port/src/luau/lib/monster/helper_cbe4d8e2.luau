--!strict
-- Shared monster helper used by 45 scripts, translated by tools/luau/stb2luau.

local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")

--- Helper function.
local function helper_cbe4d8e2()
	local var0: s32 = 0
	while true do
		helper_b9fff8e1()
		var0 = monster.CheckMosEnd() or var0
		if var0 ~= 0 then
			return
		end
	end
end

return helper_cbe4d8e2
