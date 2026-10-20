--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_29ffefe6 = require("@lib/event/helper_29ffefe6")
local helper_4cacbc41 = require("@lib/event/helper_4cacbc41")
local helper_fb6fbabc = require("@lib/event/helper_fb6fbabc")

--- Helper function.
local function helper_65aacac5(arg0: s32, arg1: s32)
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
			helper_4cacbc41(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_29ffefe6(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"ファブリースの民は、\n自分より秀でた人でないと、\nたのみを聞く事はありません。"
	)
	helper_fb6fbabc(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "私も魚については、\nいささか自信があります。")
	helper_fb6fbabc(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"聞く所によると、人間は\n魚に競争をさせて\nいるとかいないとか。<page>あなたも魚を飼って\nいるのなら、それで\n一番になってみなさい。<page>そうすれば、\n私もあなたを認め、\n力になりましょう。"
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
		"[(!)]彼女はどうやらギョレースの事を言っているようです。\n   さしあたり、ビギナークラスで優勝してみましょう。\n   彼女の態度も変わるかも知れません。"
	)
	helper_4cacbc41(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 16, 1)
end

return helper_65aacac5
