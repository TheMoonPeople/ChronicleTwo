--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")

--- Helper function.
local function helper_3c99e866()
	local var0: s32 = 0
	while true do
		helper_0ba23e4e()
		var0 = monster.CheckMosEnd() or var0
		if var0 ~= 0 then
			return
		end
	end
end

return helper_3c99e866
