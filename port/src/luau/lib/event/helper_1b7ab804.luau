--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6c76a9f4 = require("@lib/event/helper_6c76a9f4")
local helper_dbd14b96 = require("@lib/event/helper_dbd14b96")

--- Helper function.
local function helper_1b7ab804(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_6c76a9f4(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	event.SetMotion(arg1, "立ち")
	event.MesMake_2(0, "この木は・・・イカンな。\nなんとかせねば。")
	helper_dbd14b96(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]ユリスが話しかけないと、グリンは\n   取り合ってくれないようです。"
	)
	helper_6c76a9f4(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
end

return helper_1b7ab804
