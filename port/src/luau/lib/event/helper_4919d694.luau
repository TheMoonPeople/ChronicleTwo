--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_40e84721 = require("@lib/event/helper_40e84721")
local helper_4337dd96 = require("@lib/event/helper_4337dd96")
local helper_ad3cd17a = require("@lib/event/helper_ad3cd17a")
local helper_fe3af31d = require("@lib/event/helper_fe3af31d")

--- Helper function.
local function helper_4919d694()
	local var0: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	event.initialize_event()
	event.set_save_flag(40, 1)
	var0 = event.get_chapter() or var0
	if var0 ~= 6 and var0 ~= 7 then
		helper_ad3cd17a()
	else
		helper_4337dd96()
	end
	helper_fe3af31d()
	flag = event.get_save_flag(9) or flag
	flag_2 = event.get_save_flag(202) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		event.attach_object_handle_to_map_part_2(0, "p01_train01")
		event.set_object_handle_visible(0, 0)
		helper_40e84721(2, 0)
	end
end

return helper_4919d694
