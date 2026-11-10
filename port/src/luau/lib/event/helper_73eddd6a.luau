--!strict
-- Shared event helper used by 8 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_366e5299 = require("@lib/event/helper_366e5299")
local helper_a530b474 = require("@lib/event/helper_a530b474")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local helper_fbd9683d = require("@lib/event/helper_fbd9683d")
local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_73eddd6a()
	local argc: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		argc = event.get_owned_item_count(355) or argc
		if argc <= 0 then
			set_window_mode(3, 1)
			event.open_message_window_2(3, "スクープメモを\n買ってくれ。")
			at = 1
			show_message(3, -1, 3, 256, 208)
			return 0
		end
		do
			local out1, out2 = event.get_menu_value_3(5)
			var1 = out1 or var1
			var2 = out2 or var2
		end
		if var1 == var2 then
			set_window_mode(3, 1)
			event.open_message_window_2(3, "もう、スクープは\nなさそうだな。")
			at = 2
			show_message(3, -1, 3, 256, 208)
			at = 3
			return helper_366e5299()
		end
		var3 = event.get_menu_value_2(3) or var3
		if 0 < var3 then
			set_window_mode(3, 8)
			event.set_message_number(3, 1, var3)
			event.open_message_window_2(3, "スクープ条件が、[数値１]個\n明らかになった。")
			event.set_message_draw_speed(3, 0)
			at = 4
			show_message(3, -1, 8, 0, 0)
		end
		set_window_mode(3, 1)
		var3 = event.get_menu_value_2(4) or var3
		if var3 <= 0 then
			event.open_message_window_2(3, "なんだよ、スクープなんて\n撮れてないじゃないか。")
		else
			event.set_message_number(3, 1, var3)
			event.open_message_window_2(3, "お、[数値１]枚もスクープが\n撮れてるじゃん。さすがだな。")
		end
		at = 5
		show_message(3, -1, 3, 256, 208)
		at = 6
		return helper_366e5299()
	end, function(received: { any })
		if at <= 1 then
			return 0
		end
		if at <= 3 then
			return helper_a530b474()
		end
		if at <= 6 then
			if at <= 4 then
				helper_fbd9683d(3, 1)
				helper_ee1c51d0(3, -1, 3, 256, 208)
			end
			return helper_a530b474()
		end
		return nil
	end)
end

return helper_73eddd6a
