--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_194337c1 = require("@lib/event/helper_194337c1")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_249b75d1 = require("@lib/event/helper_249b75d1")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local helper_5014348d = require("@lib/event/helper_5014348d")
local helper_5d8e6e04 = require("@lib/event/helper_5d8e6e04")
local helper_7d54f41c = require("@lib/event/helper_7d54f41c")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_dae6aadb = require("@lib/event/helper_dae6aadb")
local set_window_mode = require("@lib/event/set_window_mode")

--- Helper function.
local function helper_ef001e52()
	local var0: s32 = 0
	local var1: s32 = 0
	local now_map_no: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local var9: f32 = 0
	local player_chara: s32 = 0
	local var11: any = 0
	local now_party_chara_id: s32 = 0
	local now_map_no_2: s32 = 0
	local flag_7: s32 = 0
	local flag_8: s32 = 0
	local flag_9: s32 = 0
	local var17: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var0 = event.get_triggered_event_data_2(13) or var0
		var1 = 0
		now_map_no = event.get_current_map() or now_map_no
		if now_map_no == 16 then
			flag = event.get_save_flag(280) or flag
			flag_2 = event.get_save_flag(283) or flag_2
			if flag ~= 0 and flag_2 == 0 then
				var1 = 1
			end
		end
		if now_map_no == 54 then
			flag_3 = event.get_save_flag(372) or flag_3
			flag_4 = event.get_save_flag(360) or flag_4
			if flag_3 ~= 0 and flag_4 == 0 then
				var1 = 1
			end
		end
		if now_map_no == 83 then
			flag_5 = event.get_save_flag(448) or flag_5
			flag_6 = event.get_save_flag(452) or flag_6
			if flag_5 ~= 0 and flag_6 == 0 then
				var1 = 1
			end
		end
		if var1 == 1 then
			set_window_mode(0, 1)
			at = 1
			var9 = helper_4e93f9fc(var0, 0, 0)
			player_chara = event.get_player_character_slot() or player_chara
			event.open_message_window_2(0, "出発するか？")
			at = 2
			helper_0ffc2526(0, -1, var0, player_chara, 0)
			event.set_character_motion(var0, "立ち")
			event.set_message_bubble_tail(0, 0)
			event.set_message_selection_top_line(0, 0)
			event.set_message_window_option(0, 0, 1)
			event.open_message_window_2(0, "うん！\nもう少しここにいるよ。")
			at = 3
			var11 = helper_bac0e30d(0, -1, 5, 256, 208, 2, 0)
			event.set_message_window_option(0, 0, 0)
			event.set_message_bubble_tail(0, 1)
			if var11 ~= 0 then
				event.set_character_motion(var0, "会話")
				event.open_message_window_2(0, "うむ、しっかりがんばるんじゃぞ。")
				at = 4
				helper_0ffc2526(0, -1, var0, player_chara, 0)
			end
			at = 5
			helper_5d8e6e04(var0, var9, 0, 0)
			if var11 == 0 then
				return 1
			else
				return 0
			end
		end
		now_party_chara_id = event.get_party_npc() or now_party_chara_id
		if now_party_chara_id == 1 then
			set_window_mode(0, 1)
			event.open_message_window_2(0, "二人とも気をつけてな。")
			now_map_no_2 = event.get_current_map() or now_map_no_2
			flag_7 = event.get_save_flag(300) or flag_7
			if now_map_no_2 == 16 and flag_7 == 0 then
				event.open_message_window_2(0, "まだ出発はできんなぁ・・・\nもう少し待ってくれ。")
			end
			flag_8 = event.get_save_flag(400) or flag_8
			if now_map_no_2 == 54 and flag_8 == 0 then
				event.open_message_window_2(0, "まだ出発はできんなぁ・・・\nもう少し待ってくれ。")
			end
			flag_9 = event.get_save_flag(500) or flag_9
			if now_map_no_2 == 83 and flag_9 == 0 then
				event.open_message_window_2(0, "まだ出発はできんなぁ・・・\nもう少し待ってくれ。")
			end
			at = 6
			helper_1c04a0eb(var0, -1, 0, 0)
		else
			var17 = event.get_triggered_event_data_2(13) or var17
			at = 7
			helper_dae6aadb(var17, 1)
		end
		return 0
	end, function(received: { any })
		if at <= 5 then
			if at == 1 then
				var9 = received[1] :: number
			end
			if at == 3 then
				var11 = received[1] :: number
			end
			if at <= 1 then
				helper_249b75d1(0, -1, var0, player_chara, 0)
			end
			if at <= 2 then
				var11 = helper_7d54f41c(0, -1, 5, 256, 208, 2, 0)
			end
			if at <= 3 then
				helper_249b75d1(0, -1, var0, player_chara, 0)
			end
			if at <= 4 then
				helper_194337c1(var0, var9, 0, 0)
			end
			return 1
		end
		if at <= 7 then
			if at <= 6 then
				helper_5014348d(var17, 1)
			end
			return 0
		end
		return nil
	end)
end

return helper_ef001e52
