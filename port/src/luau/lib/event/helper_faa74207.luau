--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_38443164 = require("@lib/event/helper_38443164")
local helper_473930cd = require("@lib/event/helper_473930cd")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local helper_d7d2c87b = require("@lib/event/helper_d7d2c87b")

--- Helper function.
local function helper_faa74207(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.apply_message_window_preset(0, 0)
		at = 1
		helper_4e93f9fc(arg0, 0, 0)
		var2 = event.get_menu_value_2(0) or var2
		var3 = event.get_save_counter(19) or var3
		print("start=", var3, ",now=", var2, ",clear=", vm.i32(var2 - var3), "\n")
		if vm.i32(var2 - var3) < 10 then
			event.open_message_window_2(0, "まだ体調はすぐれないわ。")
			at = 2
			helper_0ffc2526(0, -1, arg0, arg1, 0)
			event.open_message_window_2(
				0,
				"もしかして、\n悪い病気なんじゃ\nないかしら？<page>ダック先生がああ言う\nのも、もう手おくれ\nだからなのかも・・・"
			)
			at = 3
			helper_0ffc2526(0, -1, arg0, arg1, 0)
			event.set_character_motion(arg0, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "こんにちは。<page>身体の調子？\n快調よ！")
		at = 4
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"最近、うそみたいに\n楽になったわ。<page>なんていうか、世界が\nしっかりしてる感じ。"
		)
		at = 5
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"そう言えば、何か\n頼み事があったのよね。<page>私に出来る事なら\n協力するわ。<page>助けてもらったんだもの。\n助けてあげなきゃね。"
		)
		at = 6
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		at = 7
		helper_473930cd()
		event.finish_event()
		event.set_quest_request(1, 17, 1)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				print("start=", var3, ",now=", var2, ",clear=", var2 - var3, "\n")
				helper_38443164(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_38443164(0, -1, arg0, arg1, 0)
			end
			return 0
		end
		if at <= 7 then
			if at <= 4 then
				helper_38443164(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				helper_38443164(0, -1, arg0, arg1, 0)
			end
			if at <= 6 then
				helper_d7d2c87b()
			end
			return 0
		end
		return nil
	end)
end

return helper_faa74207
