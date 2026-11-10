--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")

--- Helper function.
local function helper_8696d396(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(
			0,
			"女の子が剣を振り回すなんて、\n私はあまり好きではないな。<page>例えばルネさんのような、\nおしとやかな女性が一番だよ。"
		)
	else
		event.open_message_window_2(0, "本官に頼みたいことがあったら、\nいつでも言ってくれ。")
	end
	helper_1c04a0eb(arg0, -1, 0, 0)
end

return helper_8696d396
