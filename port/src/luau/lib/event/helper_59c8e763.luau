--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local set_window_mode = require("@lib/event/set_window_mode")

--- Helper function.
local function helper_59c8e763(arg0: s32)
	local var1: s32 = 0
	local var2: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	event.apply_message_window_preset(1, 4)
	set_window_mode(1, 4)
	event.set_message_window_buffer(1, 1, 1)
	var2 = event.get_npc_message_number_3(arg0, 0) or var2
	event.set_message_item_system_message(1, 1, var2)
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	if true then
		var1 = 50
	else
		var4 = event.get_npc_message_number_3(now_party_chara_id, 0) or var4
		event.set_message_item_system_message(1, 2, var4)
		var1 = 51
	end
	helper_75684dd8(1, var1, 8, 0, 0)
	event.set_message_window_buffer(1, 1, 0)
end

return helper_59c8e763
