--!strict
-- Shared action helper used by 4 scripts, translated by tools/luau/stb2luau.

local helper_bac4ec65 = require("@lib/action/helper_bac4ec65")

--- Helper function.
local function helper_b1d92b97()
	local var0: s32 = 0
	local prog: s32 = 0
	prog = action.ProgGet() or prog
	if prog == 300 then
		action.SetMos("ダウン･剣", -1, 6)
		action.ProgSet(prog + 1)
	end
	if prog == 301 then
		var0 = action.GetMosStatus() or var0
		if var0 == 4 then
			action.ProgSet(0)
			helper_bac4ec65(3)
		end
		return
	end
end

return helper_b1d92b97
