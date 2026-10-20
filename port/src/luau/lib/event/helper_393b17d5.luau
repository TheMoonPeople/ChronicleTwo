--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_47171f2d = require("@lib/event/helper_47171f2d")
local helper_cb88c721 = require("@lib/event/helper_cb88c721")

--- Helper function.
local function helper_393b17d5(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			helper_cb88c721(arg0, arg1)
			if vm.skipping() then
				return skip(1)
			end
			return
		end
		event.SetMesPreset(0, 0)
		event.MesMake_2(
			0,
			"Ich fass es nicht. Ich habe nicht\ngedacht, dass du sie findest.<page>Das war echt gut, Max!"
		)
	else
		event.MesMake_2(0, "He! Wie l[UNI00e4]uft die Zelmit-Suche?\nWenn ich helfen kann,\nsag einfach Bescheid.")
	end
	helper_47171f2d(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_393b17d5
