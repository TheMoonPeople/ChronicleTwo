--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_5e28cd9d = require("@lib/event/helper_5e28cd9d")

--- Helper function.
local function helper_2a26ecc0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 1 then
			helper_5e28cd9d(arg0, arg1)
			return
		end
		event.open_message_window_2(0, "あまり危ないところには\n行かないでね。")
	else
		event.open_message_window_2(0, "いよいよ、バース鉄道が\n世界中に広がるのね。楽しみだわ。")
	end
	helper_1c04a0eb(arg0, -1, 0, 0)
end

return helper_2a26ecc0
