--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_473930cd = require("@lib/event/helper_473930cd")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local helper_59c8e763 = require("@lib/event/helper_59c8e763")

--- Helper function.
local function helper_ae33cc43(arg0: s32, arg1: s32)
	local item: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_4e93f9fc(arg0, 0, 0)
	event.open_message_window_2(
		0,
		"待ちくたびれたよ。<page>さぁ、早く絵に生命を\n宿らせる絵の具をくれ。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_use_item_menu(376)
	vm.wait(3)
	item = vmhost.used_item() or item
	if item <= 0 then
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	if item ~= 376 then
		event.open_message_window_2(
			0,
			"これは何の冗談なんだい？<page>僕が欲しいのは『金色の絵の具』だ。\n間違えないでくれ。"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(376)
	event.open_message_window_2(0, "これが『金色の絵の具』か・・・\n早速、使ってみるよ。")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"は、ははっ、本当に\n本物になった・・・<page>すばらしい、まさに\n完璧な女性だ！"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"ありがとう、ユリス。\n約束だったね。僕のこの能力、\nえんりょなく存分に使ってくれ。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_473930cd()
	event.set_npc_party_status(22, 130)
	helper_59c8e763(22)
	event.finish_event()
	event.set_quest_request(1, 1, 1)
end

return helper_ae33cc43
