--!strict
-- Shared action helper used by 17 scripts, translated by tools/luau/stb2luau.

local helper_9da84b8b = require("@lib/action/helper_9da84b8b")
local helper_bac4ec65 = require("@lib/action/helper_bac4ec65")

--- Helper function.
local function helper_42e38fa0()
	action.BlowStart(5.0, 0.0, 10)
	action.SetBlowAngle()
	action.ReleaseObj(0)
	action.SetMos("吹っ飛び", -1, 6)
	helper_9da84b8b()
	helper_bac4ec65(8)
	action.SetMos("起き上がり", -1, 6)
	helper_9da84b8b()
	helper_bac4ec65(2)
	action.ProgSet(0)
end

return helper_42e38fa0
