--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_238b5abc = require("@lib/event/helper_238b5abc")

--- Helper function.
local function helper_bdaf51ab()
	helper_238b5abc(1)
	helper_038a2e4d(10)
	helper_038a2e4d(30)
	helper_038a2e4d(20)
	helper_238b5abc(0)
	helper_038a2e4d(10)
end

return helper_bdaf51ab
