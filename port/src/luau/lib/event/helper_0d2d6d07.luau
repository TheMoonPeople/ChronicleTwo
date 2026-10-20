--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_29ffefe6 = require("@lib/event/helper_29ffefe6")
local helper_fb6fbabc = require("@lib/event/helper_fb6fbabc")

--- Helper function.
local function helper_0d2d6d07(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_fb6fbabc(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_fb6fbabc(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_fb6fbabc(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_fb6fbabc(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_fb6fbabc(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_fb6fbabc(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_fb6fbabc(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_29ffefe6(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "あ、坊ちゃん、ちょうど良い所へ。\nちょっと相談があるんですよ。")
	helper_fb6fbabc(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"僕が研究のために世界中の\nめずらしいお菓子を作って\nいるのはご存知ですよね。"
	)
	helper_fb6fbabc(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "なんでも、「カスタニャッチョ」\nというお菓子があるそうで、")
	helper_fb6fbabc(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "それは「カスターニャ」という\n物を使って作るらしいんです。")
	helper_fb6fbabc(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"いろいろ調べてみて、その\n「カスターニャ」ってのは、<page>どうも『とんがりマロン』と\n同じ種類の木の実らしいと\nいう所までは突き止めました。"
	)
	helper_fb6fbabc(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"そこで、とりあえず『とんがりマロン』を\n使って作って見ようと思ったのですが、<page>不思議な事に、町中の『とんがりマロン』が\n売り切れてしまっているのです。"
	)
	helper_fb6fbabc(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"なんでも、町長が\n買い占めてしまったとか。<page>坊ちゃん、なんとか\nなりませんか？"
	)
	helper_fb6fbabc(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(0, 3, 1)
end

return helper_0d2d6d07
