--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_2e3cb168 = require("@lib/event/helper_2e3cb168")
local helper_4681ac42 = require("@lib/event/helper_4681ac42")
local helper_6a601edc = require("@lib/event/helper_6a601edc")
local helper_ada3093b = require("@lib/event/helper_ada3093b")

--- Helper function.
local function helper_98567367(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.GetFlag(314) or flag
	if flag == 0 then
		helper_ada3093b(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_2e3cb168(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_6a601edc(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_4681ac42(arg0, arg1)
		return
	end
end

return helper_98567367
