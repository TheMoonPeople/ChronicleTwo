--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")

--- Helper function.
local function helper_7fe034b9(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"うちの店は刃物専門だよ。<page>一応、銃も扱ってはいるが、\nどうも飛び道具は\n性に合わなくってね。"
	)
	helper_1c04a0eb(arg0, -1, 0, 0)
end

return helper_7fe034b9
