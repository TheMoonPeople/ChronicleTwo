--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local close_message = require("@lib/event/close_message")
local helper_c45eb7de = require("@lib/event/helper_c45eb7de")
local open_message = require("@lib/event/open_message")

--- Helper function.
local function helper_c8c8b790(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _ = open_message(arg0, arg1, arg2, arg3, arg4)
	do
		local _: any
		_, var6 = helper_c45eb7de(arg0, 0, var6)
	end
	close_message(arg0)
end

return helper_c8c8b790
