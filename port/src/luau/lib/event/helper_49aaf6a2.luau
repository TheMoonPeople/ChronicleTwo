--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_002aadf3 = require("@lib/event/helper_002aadf3")
local helper_15a714cb = require("@lib/event/helper_15a714cb")
local helper_192a35c6 = require("@lib/event/helper_192a35c6")
local helper_2d4d5d3b = require("@lib/event/helper_2d4d5d3b")
local helper_39af59c5 = require("@lib/event/helper_39af59c5")
local helper_5a4034b0 = require("@lib/event/helper_5a4034b0")
local helper_680663c1 = require("@lib/event/helper_680663c1")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_ce85b54c = require("@lib/event/helper_ce85b54c")
local helper_d1956ae2 = require("@lib/event/helper_d1956ae2")
local helper_d793ae41 = require("@lib/event/helper_d793ae41")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local open_message = require("@lib/event/open_message")

--- Helper function.
local function helper_49aaf6a2()
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
				event.open_message_window_2(
					0,
					"[UNI00bf]Eh? [UNI00a1]Espera! [UNI00a1]Huele raro!\n      [UNI00a1]Cuidado! Creo que es un Mimic."
				)
				at = 1
				helper_75684dd8(0, -1, 5, 0, 0)
				event.set_message_selection_top_line(0, 1)
				event.set_message_bubble_tail(0, 0)
				event.set_message_window_option(0, 0, 1)
				event.set_message_window_option(0, 1, 1)
				event.open_message_window_2(0, "[UNI00bf]Todav[UNI00ed]a quieres abrirlo?\nS[UNI00ed].\nNo.")
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
					return 0
				end
			end
			at = 3
			helper_5a4034b0(item_x, num_x)
			return 0
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
			t0, flags = helper_d1956ae2(flags)
			if t0 ~= 0 then
				event.set_dungeon_pause_flags(513, 0)
				event.finish_event()
				return 0
			end
		end
		if bit32.band(flags, 4) ~= 0 then
			at = 5
			local t1: s32
			t1, flags = helper_680663c1(flags)
			if t1 ~= 0 then
				event.set_dungeon_pause_flags(513, 0)
				event.finish_event()
				return 0
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
			helper_002aadf3(-1, -1)
			var8 = 1
		end
		if bit32.band(flags, 128) ~= 0 then
			at = 7
			helper_192a35c6(item_x, num_x, item_y, num_y)
			var8 = 1
		end
		if var8 == 0 then
			at = 8
			helper_002aadf3(item_x, num_x)
			var8 = 1
		end
		event.show_dungeon_status_bar(1, 0.16666667)
		return item_x
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
				helper_2d4d5d3b(item_x, num_x, item_y, num_y)
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

return helper_49aaf6a2
