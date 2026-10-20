--!strict
-- Shared event helper used by 8 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_29ffefe6 = require("@lib/event/helper_29ffefe6")
local helper_d82a052e = require("@lib/event/helper_d82a052e")
local helper_fb6fbabc = require("@lib/event/helper_fb6fbabc")

--- Helper function.
local function helper_315861e5(arg0: s32, arg1: s32)
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
			helper_d82a052e(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_29ffefe6(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"そうですね・・・坊ちゃんの\nお願いですし、お引き受け\nしたいのはやまやまなんですけど、<page>私、自分に自信がないんです。"
	)
	helper_fb6fbabc(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"なんでも途中で投げ出してしまって、\n何かをやりとげた事がないんです。<page>小さい頃、洋服屋になるのが夢で、\n自分で何度も作ってみたんですけど、\n一着も完成させられなかったんです。"
	)
	helper_fb6fbabc(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"こんな私がいっしょにいると、\nきっとめいわくをかけて\nしまうでしょう。<page>だから、ごめんなさい。"
	)
	helper_fb6fbabc(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]あらら、ルネは完全に自信をなくしている\n   みたいですね。このままではいけません。\n   もう一度、洋服を作ってもらいましょう。"
	)
	helper_d82a052e(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 7, 1)
end

return helper_315861e5
