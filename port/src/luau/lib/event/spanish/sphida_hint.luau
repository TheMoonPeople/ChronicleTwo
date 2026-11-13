--!strict
--- Spanish hint message shown during a Sphida shot.

local vm = require("@lib/vm")
local message = vm.module("@lib/event/message")

local sphida_hint = {}

--- Opens a hint window explaining that the circle button stops the spinning character.
function sphida_hint.show_stop_hint()
	message.set_window_mode(1, 7)
	event.apply_message_window_preset(1, 2)
	event.open_message_window_2(1, "Se para con el bot[UNI00f3]n (O).")
	message.open(1, -1, 15, 0, 0)
end

return sphida_hint
