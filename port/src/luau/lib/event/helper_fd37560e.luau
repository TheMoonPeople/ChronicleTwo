--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_40e84721 = require("@lib/event/helper_40e84721")
local helper_47ab4f2e = require("@lib/event/helper_47ab4f2e")
local helper_7fed7304 = require("@lib/event/helper_7fed7304")
local helper_de8ac2af = require("@lib/event/helper_de8ac2af")

--- Helper function.
local function helper_fd37560e()
	helper_40e84721(401, helper_7fed7304())
	if helper_de8ac2af() == 0 then
		helper_40e84721(406, 0)
	end
	if helper_47ab4f2e() == 0 then
		helper_40e84721(407, 0)
	end
end

return helper_fd37560e
