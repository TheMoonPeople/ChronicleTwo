--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_10d6108d = require("@lib/event/helper_10d6108d")
local helper_5a735084 = require("@lib/event/helper_5a735084")
local helper_981c86d9 = require("@lib/event/helper_981c86d9")
local helper_d622cd71 = require("@lib/event/helper_d622cd71")

--- Helper function.
local function helper_56a7b9b7()
	if helper_d622cd71() ~= 0 then
		return 1
	end
	if helper_10d6108d() ~= 0 then
		return 1
	end
	if helper_981c86d9() ~= 0 then
		return 1
	end
	if helper_5a735084() ~= 0 then
		return 1
	end
	return 0
end

return helper_56a7b9b7
