--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_56a7b9b7 = require("@lib/event/helper_56a7b9b7")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_6b2c781b(arg0: any, arg1: s32)
	local var5: s32 = 0
	local var6: s32 = 0
	var5 = event.get_chapter() or var5
	if var5 >= 8 then
		return
	end
	event.set_message_window_mode(1, 8)
	event.set_character_motion(0, "立ち")
	var6 = 1050
	if helper_56a7b9b7() ~= 0 then
		var6 = 1051
	elseif arg0 ~= 0 then
		return
	end
	if arg1 ~= 0 then
		var6 = var6 + 10
	end
	event.open_message_window_2(1, var6)
	show_message(1, -1, 8, 0, 0)
end

return helper_6b2c781b
