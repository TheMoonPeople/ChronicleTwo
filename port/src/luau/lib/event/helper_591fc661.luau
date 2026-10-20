--!strict
-- Shared event helper used by 8 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_cc7603b9 = require("@lib/event/helper_cc7603b9")
local helper_e2203e72 = require("@lib/event/helper_e2203e72")
local helper_e5219064 = require("@lib/event/helper_e5219064")
local helper_eb560126 = require("@lib/event/helper_eb560126")
local helper_f39cfbfe = require("@lib/event/helper_f39cfbfe")

--- Helper function.
local function helper_591fc661(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				var3 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 6 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 7 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 9 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 10 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 11 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 12 then
			helper_e2203e72(30)
		end
		if at <= 13 then
			helper_e2203e72(30)
		end
		if at <= 14 then
			helper_e2203e72(60)
		end
		if at <= 15 then
			helper_cc7603b9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(0, "Ooh, Max! I've heard that\nyou've been going out of town recently.")
	else
		event.MesMake_2(0, "Ooh, Monica! I've heard that\nyou've been going out of town recently.")
	end
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "That's great! Why don't you\ntake me with you?")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"I bet you're thinking I won't be\nany use because I'm a girl.<page>But I actually bring people\na lot of luck."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"It never rains when I go out,\nand I've never seen a losing\nlottery ticket.<page>What do you think?"
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "OK then.\nNo, sorry.")
	var3 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "会話")
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var3 ~= 0 then
		event.MesMake_2(0, "Why! Don't be mean!\nYou're horrible!")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.MesMake_2(0, "You're useless!<page>You fool!<page>You idiot!")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "You'll take me with you?<page>I didn't think you would!")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"But how come I'm the only one\nthat has to ask you, when you've\nbeen asking all these other people.<page>If you'd just asked, then of\ncourse I would have helped you."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(0, "I know, if you can find me,\nthen I'll help you. What do you think?")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(0, "In other words, let's play hide-and-seek!<page>Right, go!")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.SetMotion(arg0, "立ち")
	helper_e2203e72(30)
	if vm.skipping() then
		return skip(13)
	end
	event.SetFadeOut(30)
	helper_e2203e72(30)
	if vm.skipping() then
		return skip(14)
	end
	event.SetAi(1, arg0)
	event.CharaActive(0, arg0)
	event.DeleteVillager(arg0)
	event.SetFadeIn(30)
	helper_e2203e72(60)
	if vm.skipping() then
		return skip(15)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Oh well... Looks like you'd better try\n   to find Corinne. She's probably hiding\n   somewhere in Palm Brinks."
	)
	helper_cc7603b9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 18, 1)
	event.SetCnt(11, 0)
end

return helper_591fc661
