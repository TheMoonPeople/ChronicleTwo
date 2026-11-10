--!strict
-- Shared event helper used by 11 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_39af59c5 = require("@lib/event/helper_39af59c5")
local helper_5fb66cb1 = require("@lib/event/helper_5fb66cb1")
local helper_672e9b88 = require("@lib/event/helper_672e9b88")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_7c656a4f = require("@lib/event/helper_7c656a4f")
local helper_af712f29 = require("@lib/event/helper_af712f29")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local open_message = require("@lib/event/open_message")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_3534ee42(arg0: s32)
	local var1: any = 0
	local var2: s32 = 0
	local now_party_chara_id: s32 = 0
	local item: s32 = 0
	local active_chr_no: s32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: s32 = 0
	local at: number = 0
	return vm.guard(function()
		now_party_chara_id = event.get_party_npc() or now_party_chara_id
		if now_party_chara_id == 4 then
			event.open_message_window_2(
				0,
				"The treasure chest seems to be locked.\nHave Donny open it.\nForce it open.\nGive up on it."
			)
			open_message(0, -1, 5, 0, 0)
		else
			open_message(0, 2220, 5, 0, 0)
		end
		at = 1
		var1 = helper_39af59c5(0, 3, 3, 0)
		if var1 == 1 then
			if now_party_chara_id == 4 then
				event.open_message_window_2(0, "Alright! Leave it to me!")
				at = 2
				helper_75684dd8(0, -1, 5, 0, 0)
				arg0 = helper_af712f29(arg0, 2)
				var2 = 0
			else
				event.show_dungeon_status_bar(0, 0.16666667)
				at = 3
				wait_frames(6)
				event.open_use_item_menu(297)
				at = 4
				vm.wait(4)
				item = vmhost.used_item() or item
				if item == 297 then
					arg0 = helper_af712f29(arg0, 2)
					var2 = 0
				elseif item <= 0 then
					var2 = 1
				else
					at = 5
					helper_5fb66cb1()
					var2 = 1
				end
				event.show_dungeon_status_bar(1, 0.16666667)
			end
		end
		if var1 == 2 then
			event.play_system_sound_effect(24)
			event.set_message_selection_top_line(0, 0)
			if bit32.band(arg0, 8) ~= 0 then
				active_chr_no = event.get_playable_character() or active_chr_no
				if active_chr_no == 0 or active_chr_no == 2 then
					at = 6
					helper_75684dd8(0, 2215, 5, 0, 0)
					event.set_character_status(0, 1, 0)
					event.add_character_hp_by_rate(0, -0.7)
				else
					at = 7
					helper_75684dd8(0, 2216, 5, 0, 0)
					event.set_character_status(1, 1, 0)
					event.add_character_hp_by_rate(1, -0.7)
				end
				var2 = 0
			end
			if bit32.band(arg0, 16) ~= 0 then
				at = 8
				helper_75684dd8(0, 2211, 5, 0, 0)
				event.set_nearest_treasure_box_state(0)
				do
					local out1, out2, out3, _ = event.get_dungeon_event_point(1)
					var6 = out1 or var6
					var7 = out2 or var7
					var8 = out3 or var8
				end
				var10 = event.get_sound_id(4) or var10
				event.play_sound_effect(var10, 11)
				event.create_dungeon_effect("爆発", var6, var7 + 4.0, var8, 5)
				var2 = 1
			end
			if bit32.band(arg0, 32) ~= 0 then
				at = 9
				helper_75684dd8(0, 2212, 5, 0, 0)
				event.add_battle_weapon_durability(0, -999)
				event.add_battle_weapon_durability(1, -999)
				var2 = 0
			end
			arg0 = helper_af712f29(arg0, 2)
		end
		if var1 == -1 or var1 == 3 then
			var2 = 1
		end
		return var2, arg0
	end, function(received: { any })
		if at <= 9 then
			if at == 1 then
				var1 = received[1] :: number
			end
			if at <= 1 then
				helper_ee1c51d0(0, -1, 5, 0, 0)
			end
			if at <= 2 then
				arg0 = helper_672e9b88(arg0, 2)
				var2 = 0
				wait_frames_skipping(6)
			end
			if at <= 4 then
				arg0 = helper_672e9b88(arg0, 2)
				var2 = 0
				var2 = 1
				helper_7c656a4f()
			end
			if at <= 5 then
				var2 = 1
				helper_ee1c51d0(0, 2215, 5, 0, 0)
			end
			if at <= 6 then
				helper_ee1c51d0(0, 2216, 5, 0, 0)
			end
			if at <= 7 then
				var2 = 0
				helper_ee1c51d0(0, 2211, 5, 0, 0)
			end
			if at <= 8 then
				var2 = 1
				helper_ee1c51d0(0, 2212, 5, 0, 0)
			end
			var2 = 0
			local _ = bit32.band(arg0, 8)
			local _ = bit32.band(arg0, 16)
			local _ = bit32.band(arg0, 32)
			arg0 = helper_672e9b88(arg0, 2)
			var2 = 1
			return var2, arg0
		end
		return nil, arg0
	end)
end

return helper_3534ee42
