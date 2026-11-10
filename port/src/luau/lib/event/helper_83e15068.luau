--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local helper_e787350a = require("@lib/event/helper_e787350a")

--- Helper function.
local function helper_83e15068(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "According to Cedric,\nyou've been off up to\nsomething recently.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "You're good at a lot of things,<page>but on the other hand you\nnever see anything through.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "So when you ask for help,\nit's hard for me to take you\nseriously just like that.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"I know, why don't you try to build-up\nthis Trumpet Gun to a Bell Trigger?<page>Think you can do it?"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.add_inventory_item(24)
	helper_e787350a(24, 1)
	helper_a87eb945(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]To get Gerald to accept you,\n   you'll have to bring\n   him a Bell Trigger.<page>[(!)]You can build-up the weapon you've\n   been given, or you can buy a weapon,\n   or bring one you find in the dungeons."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 11, 1)
end

return helper_83e15068
