--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_6b4ee5b8()
	event.initialize_event()
	event.set_message_window_mode(0, 0)
	event.fade_in_screen(30)
	event.open_message_window_2(0, "Ｅ３５６　～ギルトーニ撃退・クレストとの別れ～(つづき)")
	helper_75684dd8(0, -1, 5, 0, 0)
	event.fade_out_screen(30)
	wait_frames(30)
	event.finish_event()
end

return helper_6b4ee5b8
