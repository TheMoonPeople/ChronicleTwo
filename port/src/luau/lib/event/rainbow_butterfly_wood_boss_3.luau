--!strict
--- Debug and error messages of the Rainbow Butterfly Wood boss room 3.

local vm = require("@lib/vm")
local message = vm.module("@lib/event/message")

local rainbow_butterfly_wood_boss_3 = {}

--- Sets save flag 255 and shows the event 255a message.
function rainbow_butterfly_wood_boss_3.show_event_255a_message()
	event.set_save_flag(255, 1)
	event.open_message_window_2(0, "いべんと２５５ａ")
	message.show(0, -1, 8, 0, 0)
end

--- Sets save flag 255 and shows the event 255b message.
function rainbow_butterfly_wood_boss_3.show_event_255b_message()
	event.set_save_flag(255, 1)
	event.open_message_window_2(0, "いべんと２５５ｂ")
	message.show(0, -1, 8, 0, 0)
end

--- Shows the wrong item message.
function rainbow_butterfly_wood_boss_3.show_wrong_item_message()
	event.open_message_window_2(0, "あいてむまちがい")
	message.show(0, -1, 8, 0, 0)
end

return rainbow_butterfly_wood_boss_3
