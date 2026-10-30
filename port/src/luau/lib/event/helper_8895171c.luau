--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_15a714cb = require("@lib/event/helper_15a714cb")
local helper_15dad56e = require("@lib/event/helper_15dad56e")
local helper_3534ee42 = require("@lib/event/helper_3534ee42")
local helper_39af59c5 = require("@lib/event/helper_39af59c5")
local helper_45856b66 = require("@lib/event/helper_45856b66")
local helper_5a4034b0 = require("@lib/event/helper_5a4034b0")
local helper_680663c1 = require("@lib/event/helper_680663c1")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_ce85b54c = require("@lib/event/helper_ce85b54c")
local helper_d793ae41 = require("@lib/event/helper_d793ae41")
local helper_e84599ef = require("@lib/event/helper_e84599ef")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local open_message = require("@lib/event/open_message")

--- Helper function.
local function helper_8895171c()
	local flags: s32 = 0
	local item_x: s32 = 0
	local item_y: s32 = 0
	local num_x: s32 = 0
	local num_y: s32 = 0
	local now_party_chara_id: s32 = 0
	local var6: any = 0
	local var8: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		do
			local out1, out2, out3, out4, out5 = event.get_nearest_treasure_box_contents()
			flags = out1 or flags
			item_x = out2 or item_x
			item_y = out3 or item_y
			num_x = out4 or num_x
			num_y = out5 or num_y
		end
		print("-----------------------------------------------------------------------------------------\n")
		print("tbox type = ", flags, "\n")
		print("item1 = ", item_x, ", ", num_x, "\n")
		print("item2 = ", item_y, ", ", num_y, "\n")
		print("-----------------------------------------------------------------------------------------\n")
		if bit32.band(flags, 256) ~= 0 then
			now_party_chara_id = event.get_party_npc() or now_party_chara_id
			if now_party_chara_id == 9 then
				event.set_dungeon_pause_flags(513, 1)
				helper_ce85b54c()
				event.set_message_window_mode(0, 1)
				event.set_message_bubble_tail(0, 0)
				event.open_message_window_2(0, "Huh? Hold on! I smell something funny!\n　　　Be careful! I think it's a Mimic.")
				at = 1
				helper_75684dd8(0, -1, 5, 0, 0)
				event.set_message_selection_top_line(0, 1)
				event.set_message_bubble_tail(0, 0)
				event.set_message_window_option(0, 0, 1)
				event.set_message_window_option(0, 1, 1)
				event.open_message_window_2(0, "You still want to open it?\nYes.\nNo.")
				open_message(0, -1, 5, 0, 0)
				at = 2
				var6 = helper_39af59c5(0, 2, 2, 0)
				event.set_message_selection_top_line(0, 0)
				event.set_message_bubble_tail(0, 1)
				event.set_message_window_option(0, 0, 0)
				event.set_message_window_option(0, 1, 0)
				event.set_dungeon_pause_flags(513, 0)
				if var6 == 1 then
				else
					return
				end
			end
			at = 3
			helper_5a4034b0(item_x, num_x)
			return
		end
		event.set_dungeon_pause_flags(513, 1)
		helper_ce85b54c()
		event.set_message_window_mode(0, 1)
		event.set_message_selection_top_line(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.set_message_window_option(0, 1, 1)
		if bit32.band(flags, 2) ~= 0 then
			at = 4
			local t0: s32
			t0, flags = helper_3534ee42(flags)
			if t0 ~= 0 then
				event.set_dungeon_pause_flags(513, 0)
				event.finish_event()
				return
			end
		end
		if bit32.band(flags, 4) ~= 0 then
			at = 5
			local t1: s32
			t1, flags = helper_680663c1(flags)
			if t1 ~= 0 then
				event.set_dungeon_pause_flags(513, 0)
				event.finish_event()
				return
			end
		end
		event.set_message_selection_top_line(0, 0)
		event.set_message_bubble_tail(0, 1)
		event.set_message_window_option(0, 0, 0)
		event.set_message_window_option(0, 1, 0)
		event.set_dungeon_pause_flags(513, 0)
		event.start_crossfade(30)
		event.show_dungeon_status_bar(0, 0.16666667)
		event.set_character_active(0, 0)
		var8 = 0
		if bit32.band(flags, 512) ~= 0 then
			at = 6
			helper_45856b66(-1, -1)
			var8 = 1
		end
		if bit32.band(flags, 128) ~= 0 then
			at = 7
			helper_e84599ef(item_x, num_x, item_y, num_y)
			var8 = 1
		end
		if var8 == 0 then
			at = 8
			helper_45856b66(item_x, num_x)
			var8 = 1
		end
		event.show_dungeon_status_bar(1, 0.16666667)
		return
	end, function(received: { any })
		if at <= 2 then
			if at == 2 then
				var6 = received[1] :: number
			end
			if at <= 1 then
				helper_f018b3c0(0, -1, 5, 0, 0)
				var6 = helper_d793ae41(0, 2, 2, 0)
			end
			return 0
		end
		if at <= 3 then
			return 0
		end
		if at <= 4 then
			if at == 4 then
				local _ = received[1] :: number
				flags = received[2] :: number
			end
			return 0
		end
		if at <= 5 then
			if at == 5 then
				local _ = received[1] :: number
				flags = received[2] :: number
			end
			return 0
		end
		if at <= 8 then
			if at <= 6 then
				var8 = 1
				helper_15dad56e(item_x, num_x, item_y, num_y)
			end
			if at <= 7 then
				var8 = 1
				helper_15a714cb(item_x, num_x)
			end
			local _ = var8 == 0
			var8 = 1
			return item_x
		end
		return nil
	end)
end

return helper_8895171c
