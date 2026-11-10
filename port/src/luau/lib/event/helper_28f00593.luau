--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_11f24581 = require("@lib/event/helper_11f24581")
local helper_1eb0e352 = require("@lib/event/helper_1eb0e352")
local helper_578fcd04 = require("@lib/event/helper_578fcd04")
local helper_645f59e7 = require("@lib/event/helper_645f59e7")
local helper_70100fa6 = require("@lib/event/helper_70100fa6")
local helper_b7004d1b = require("@lib/event/helper_b7004d1b")
local helper_f0912fee = require("@lib/event/helper_f0912fee")

--- Helper function.
local function helper_28f00593(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_f0912fee(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_70100fa6(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 7) or var3
	if var3 == 0 then
		helper_645f59e7(arg0, arg1)
		return
	end
	if var3 == 1 then
		var4 = event.get_save_counter(8) or var4
		if var4 == 0 then
			helper_578fcd04(arg0, arg1)
		end
		if var4 == 1 then
			helper_11f24581(arg0, arg1)
		end
		if var4 == 2 then
			helper_1eb0e352(arg0, arg1)
		end
		return
	end
	if var3 == 2 then
		helper_b7004d1b(arg0, arg1)
		return
	end
end

return helper_28f00593
