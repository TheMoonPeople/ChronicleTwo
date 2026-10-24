--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_8f5252f6 = require("@lib/event/helper_8f5252f6")
local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_020096c8(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: any = 0
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(0, "Ooh, Max! I've heard that\nyou've been going out of town recently.")
	else
		event.MesMake_2(0, "Ooh, Monica! I've heard that\nyou've been going out of town recently.")
	end
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "That's great! Why don't you\ntake me with you?")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"I bet you're thinking I won't be\nany use because I'm a girl.<page>But I actually bring people\na lot of luck."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"It never rains when I go out,\nand I've never seen a losing\nlottery ticket.<page>What do you think?"
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "OK then.\nNo, sorry.")
	var3 = helper_8f5252f6(0, -1, 5, 256, 208, 2, 1)
	event.SetMotion(arg0, "会話")
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var3 ~= 0 then
		event.MesMake_2(0, "Why! Don't be mean!\nYou're horrible!")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(0, "You're useless!<page>You fool!<page>You idiot!")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "You'll take me with you?<page>I didn't think you would!")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"But how come I'm the only one\nthat has to ask you, when you've\nbeen asking all these other people.<page>If you'd just asked, then of\ncourse I would have helped you."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "I know, if you can find me,\nthen I'll help you. What do you think?")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "In other words, let's play hide-and-seek!<page>Right, go!")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	helper_25abe6d2(30)
	event.SetFadeOut(30)
	helper_25abe6d2(30)
	event.SetAi(1, arg0)
	event.CharaActive(0, arg0)
	event.DeleteVillager(arg0)
	event.SetFadeIn(30)
	helper_25abe6d2(60)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Oh well... Looks like you'd better try\n   to find Corinne. She's probably hiding\n   somewhere in Palm Brinks."
	)
	helper_a3cc6850(0, -1, 8, 0, 0)
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 18, 1)
	event.SetCnt(11, 0)
end

return helper_020096c8
