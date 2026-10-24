--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_6982de90 = require("@lib/event/helper_6982de90")
local helper_8f5252f6 = require("@lib/event/helper_8f5252f6")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_45160785(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local money: s32 = 0
	local var4: any = 0
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var2 = event.GetCnt(9) or var2
	money = event.GetMoney() or money
	if var2 == 0 then
		if money < 1000 then
			event.MesMake_2(
				0,
				"That kind of money won't\nget me into the auction.<page>I need 1000 Gilda.\nPlease get it right!"
			)
			helper_b5a98ffa(0, -1, arg0, arg1, 0)
		else
			event.MesMake_2(0, "You won't believe this!<page>The price has gone up to\n1200 Gilda.")
			helper_b5a98ffa(0, -1, arg0, arg1, 0)
			event.MesMake_2(0, "I'm terribly sorry, but could you\npossibly get hold a of 1500 Gilda?")
			helper_b5a98ffa(0, -1, arg0, arg1, 0)
			event.SetCnt(9, 1)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 == 1 then
		if money < 1500 then
			event.MesMake_2(
				0,
				"We mustn't mess about otherwise\nit'll be sold to someone else.<page>Get me 1500 Gilda as quick as you can!"
			)
			helper_b5a98ffa(0, -1, arg0, arg1, 0)
		else
			event.MesMake_2(
				0,
				"This is terrible!\nThere's someone who'll pay 1800 Gilda!<page>If I don't bid about 2000 Gilda,\nthere's no way I'll win."
			)
			helper_b5a98ffa(0, -1, arg0, arg1, 0)
			event.SetCnt(9, 2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 == 2 then
		if money < 2000 then
			event.MesMake_2(
				0,
				"We mustn't mess about otherwise\nit'll be sold to someone else.<page>Get me 2000 Gilda as quick as you can!"
			)
			helper_b5a98ffa(0, -1, arg0, arg1, 0)
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "Sonny, did you manage to get\nmy 2000 Gilders together?")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.SetMotion(arg0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "What can I do, it's yours.\nIt does seem a bit of a waste.")
		var4 = helper_8f5252f6(0, -1, 5, 256, 208, 2, 1)
		event.SetMesShippo(0, 1)
		event.SetMesEtc(0, 0, 0)
		if var4 ~= 0 then
			event.MesMake_2(
				0,
				"I see... well, 2000 Gilda is a lot of money.\nso it must be hard to part with.\nEven for a well-off young lad like you...<page>Okay then, never mind!\nBut the auction isn't over yet.\nI'll wait, no matter how long it takes..."
			)
			helper_b5a98ffa(0, -1, arg0, arg1, 0)
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "Thank you so much.<page>I'll get straight down to the auction!")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.AddMoney(-2000)
		event.SetCnt(9, 3)
		event.SetFadeOut(30)
		helper_25abe6d2(30)
		event.SetAi(1, arg0)
		event.CharaActive(0, arg0)
		event.DeleteVillager(arg0)
		event.SetFadeIn(30)
		event.Finish()
		return
	end
	event.MesMake_2(0, "Thank you very much.\nI managed to make a successful bid.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "I bid strong and everyone else dropped out really\nquickly, so I got it for 1400 Gilda!")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "So now I can give you 600 back.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.AddMoney(600)
	event.MesMake_2(0, "And I'll work hard from now on to repay\nyou the rest of the money I borrowed.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "I know I put you to a lot of trouble.\nI'll repay the favour anytime.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	helper_6982de90()
	event.Finish()
	event.SetQuestEtc(1, 6, 1)
end

return helper_45160785
