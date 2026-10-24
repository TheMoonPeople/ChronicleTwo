--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_6421a704 = require("@lib/event/helper_6421a704")
local helper_7e02c221 = require("@lib/event/helper_7e02c221")
local helper_8a2e7e5e = require("@lib/event/helper_8a2e7e5e")
local helper_c0067c2e = require("@lib/event/helper_c0067c2e")

--- Helper function.
local function helper_6aa74a0b(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_6421a704(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_8a2e7e5e(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_c0067c2e(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_7e02c221(arg0, arg1)
		return
	end
end

return helper_6aa74a0b
