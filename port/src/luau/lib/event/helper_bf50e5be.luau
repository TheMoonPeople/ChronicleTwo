--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_993850b3 = require("@lib/event/helper_993850b3")
local helper_fa032ba8 = require("@lib/event/helper_fa032ba8")

--- Helper function.
local function helper_bf50e5be()
	helper_fa032ba8(401, helper_993850b3())
	local _ = if helper_993850b3() == 0 then 1 else 0
	helper_fa032ba8(406, 0)
	local _ = if helper_993850b3() == 0 then 1 else 0
	helper_fa032ba8(407, 0)
end

return helper_bf50e5be
