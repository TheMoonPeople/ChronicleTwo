--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ea1a210 = require("@lib/event/helper_0ea1a210")
local helper_4681ac42 = require("@lib/event/helper_4681ac42")
local helper_7a60e4f3 = require("@lib/event/helper_7a60e4f3")
local helper_ada3093b = require("@lib/event/helper_ada3093b")

--- Helper function.
local function helper_86f2149f(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.GetFlag(314) or flag
	if flag == 0 then
		helper_ada3093b(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_7a60e4f3(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_0ea1a210(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_4681ac42(arg0, arg1)
		return
	end
end

return helper_86f2149f
