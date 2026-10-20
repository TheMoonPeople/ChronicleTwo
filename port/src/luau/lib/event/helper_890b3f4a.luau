--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b33603c6 = require("@lib/event/helper_b33603c6")

--- Helper function.
local function helper_890b3f4a(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b33603c6(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Du hast mich im Zirkus gesehen?\nNicht schlecht, was?<page>Es ist weniger mein Beruf\nals mein Hobby."
		)
	else
		event.MesMake_2(0, "Na, wie steht's? Bist du in der\nMine schon Fieslingen begegnet?")
	end
	helper_b33603c6(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_890b3f4a
