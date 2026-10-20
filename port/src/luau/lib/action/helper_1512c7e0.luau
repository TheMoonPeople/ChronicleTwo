--!strict
-- Shared action helper used by 17 scripts, translated by tools/luau/stb2luau.

local helper_bac4ec65 = require("@lib/action/helper_bac4ec65")

--- Helper function.
local function helper_1512c7e0()
	print("DAMAGE!\n")
	action.SetAccumeFlag(0)
	action.BlowStart(5.0, 0.0, 3)
	action.ReleaseObj(0)
	action.SetMos("ダメージ後", -1, 2)
	helper_bac4ec65(8)
	action.ProgSet(0)
end

return helper_1512c7e0
