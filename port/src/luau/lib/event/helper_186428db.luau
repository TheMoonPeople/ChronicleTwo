--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06ed6d94 = require("@lib/event/helper_06ed6d94")
local helper_27ed710c = require("@lib/event/helper_27ed710c")
local helper_6c76a9f4 = require("@lib/event/helper_6c76a9f4")
local helper_aaa24f64 = require("@lib/event/helper_aaa24f64")
local helper_dbd14b96 = require("@lib/event/helper_dbd14b96")

--- Helper function.
local function helper_186428db(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_dbd14b96(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_dbd14b96(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_dbd14b96(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_dbd14b96(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_27ed710c(44, 1)
		end
		if at <= 6 then
			helper_aaa24f64(1)
		end
		if at <= 7 then
			helper_6c76a9f4(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_6c76a9f4(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_06ed6d94(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "モニカって\n言ったっけ？<page>あんた、少しは剣が\n使えるらしいな。")
	helper_dbd14b96(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"けどな、剣は子供の\n遊び道具じゃないぜ。<page>そんな腕じゃ\n先が思いやられる。"
	)
	helper_dbd14b96(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"そうだな、剣を２回くらい\nビルドアップ出来たなら、\n腕を認めてやっても良いかな。"
	)
	helper_dbd14b96(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "とりあえず、\nこのグラディウスから\n初めてみな。")
	helper_dbd14b96(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(44)
	helper_27ed710c(44, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_aaa24f64(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]ミレーネに認めてもらうには、グラディウスを\n   ２段階ビルドアップさせるしかなさそうです。"
	)
	helper_6c76a9f4(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]買ったり、拾ったりしても良いでしょう。\n   とにかく、強い剣を手に入れない限り、\n   ミレーネは仲間になってくれなさそうです。"
	)
	helper_6c76a9f4(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 10, 1)
end

return helper_186428db
