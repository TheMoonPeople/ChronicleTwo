--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_9d142a11 = require("@lib/event/helper_9d142a11")
local helper_dbd14b96 = require("@lib/event/helper_dbd14b96")

--- Helper function.
local function helper_3dcaa55a(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_9d142a11(arg0, -1, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMotion(arg1, "立ち")
		event.MesMake_2(0, "この木は・・・イカンな。\nなんとかせねば。")
		helper_dbd14b96(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(1)
		end
	else
		event.MesMake_2(
			0,
			"おぉ、坊ちゃんでしたか、驚いた。\nちょうど木についた悪い虫を取っていたところです。<page>植物は勝手に育つ物ばかりじゃなく、こんな風に\n世話をしないと枯れてしまうのもあるんですよ。"
		)
		helper_9d142a11(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
end

return helper_3dcaa55a
