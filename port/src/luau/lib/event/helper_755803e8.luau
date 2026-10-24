--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_755803e8(arg0: s32, arg1: s32)
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.MesMake_2(0, "If there's anything you need,\nI'll do my best to help you.<page>Leave it to me.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "...")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "I don't know if you can help...<page>But just listen to this.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "I've spent some 30 years working\nhard in this house.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "That's all I do, but my one\nhobby is reading.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "There's a really valuable and rare book\nthat's up for auction at the moment.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "People are fighting over it.\nI believe a bid of about\n1000 Gilda would be enough.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"But I don't have those kind of funds, and if I were\nto ask my master, he'd be appalled and I'd probably\nhave to resign."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"So you're my only hope.<page>But that's not to say that\nif you can't help me I won't help you."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Despite what he says, Stewart probably\n   won't help unless you give him 1000 Gilda.\n   Oh well, better get some money together!"
	)
	helper_a3cc6850(0, -1, 8, 0, 0)
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 6, 1)
end

return helper_755803e8
