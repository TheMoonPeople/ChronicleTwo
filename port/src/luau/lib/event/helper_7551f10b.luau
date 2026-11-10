--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local helper_9cc4383b = require("@lib/event/helper_9cc4383b")

--- Helper function.
local function helper_7551f10b(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var3: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_4e93f9fc(arg0, 0, 0)
	var2 = vm.bits_float(event.get_menu_value(2, 322)) or var2
	if var2 <= 0 then
		event.open_message_window_2(
			0,
			"おい、実はノンキーを釣ったこと\nないんじゃないのか？<page>ははーん、さてはオマエ、\n釣りがヘタクソだろう！"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	if var2 < vm.f32(0.6) then
		var3 = vm.ftoi(vm.f32(var2 * 100.0))
		event.set_message_number(0, 1, var3)
		event.open_message_window_2(0, "ぷぷっ、[数値１]センチのしか\n釣れてないでやんの。")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"そんな腕前で\n俺様を使おうなんて\n１００年早い！<page>顔を洗って\n出直してきやがれ。"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "・・・お、おみそれしました。")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "よし、俺も男だ。\n男に二言はない。<page>約束通り\n言う事を聞くぜ。")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "さぁ、煮るなり焼くなり\n好きにしやがれ！")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_9cc4383b()
	event.finish_event()
	event.set_quest_request(1, 15, 1)
end

return helper_7551f10b
