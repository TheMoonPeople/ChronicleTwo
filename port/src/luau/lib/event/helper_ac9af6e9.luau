--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_ac9af6e9(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: s32 = 0
	if arg3 <= 0 then
		return
	end
	event.apply_message_window_preset(1, 4)
	set_window_mode(1, 4)
	var4 = -1
	if arg0 == 0 then
		if arg1 == 1 then
			if arg3 == 1 then
				var4 = 14
			else
				var4 = 21
			end
		elseif arg3 == 1 then
			var4 = 15
		else
			var4 = 22
		end
	end
	if arg0 == 1 then
		if arg3 == 1 then
			var4 = 18
		else
			var4 = 23
		end
	end
	if var4 == -1 then
		return
	end
	event.set_message_number(1, 1, arg1)
	event.set_message_item_name(1, 1, arg2)
	event.set_message_number(1, 2, arg3)
	show_message(1, var4, 8, 0, 0)
end

return helper_ac9af6e9
