--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_143e26ec = require("@lib/event/helper_143e26ec")
local helper_921858a1 = require("@lib/event/helper_921858a1")
local helper_b1a3ed13 = require("@lib/event/helper_b1a3ed13")
local helper_f23e743d = require("@lib/event/helper_f23e743d")

--- Helper function.
local function helper_14bffa77(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_921858a1(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 1) or var2
	if var2 == 0 then
		helper_b1a3ed13(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_143e26ec(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_f23e743d(arg0, arg1)
		return
	end
end

return helper_14bffa77
