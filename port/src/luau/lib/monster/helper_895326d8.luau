--!strict
-- Shared monster helper used by 4 scripts, translated by tools/luau/stb2luau.

local helper_461f64ff = require("@lib/monster/helper_461f64ff")

--- Helper function.
local function helper_895326d8()
	local var0: s32 = 0
	while true do
		helper_461f64ff()
		var0 = monster.CheckMosEnd() or var0
		if var0 ~= 0 then
			return
		end
	end
end

return helper_895326d8
