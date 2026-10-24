--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_01e77860 = require("@lib/event/helper_01e77860")
local helper_127e8072 = require("@lib/event/helper_127e8072")
local helper_1e2cc126 = require("@lib/event/helper_1e2cc126")
local helper_25344864 = require("@lib/event/helper_25344864")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_2c2672e0 = require("@lib/event/helper_2c2672e0")
local helper_2cb50640 = require("@lib/event/helper_2cb50640")
local helper_3bad0658 = require("@lib/event/helper_3bad0658")
local helper_44cb2c2d = require("@lib/event/helper_44cb2c2d")
local helper_4d9a7999 = require("@lib/event/helper_4d9a7999")
local helper_5a276f97 = require("@lib/event/helper_5a276f97")
local helper_5b011eb5 = require("@lib/event/helper_5b011eb5")
local helper_74e84031 = require("@lib/event/helper_74e84031")
local helper_7746e479 = require("@lib/event/helper_7746e479")
local helper_86f2149f = require("@lib/event/helper_86f2149f")
local helper_899661d6 = require("@lib/event/helper_899661d6")
local helper_8e455f39 = require("@lib/event/helper_8e455f39")
local helper_8f5252f6 = require("@lib/event/helper_8f5252f6")
local helper_9af7df2e = require("@lib/event/helper_9af7df2e")
local helper_9ec16a27 = require("@lib/event/helper_9ec16a27")
local helper_a67d4aed = require("@lib/event/helper_a67d4aed")
local helper_bc50654d = require("@lib/event/helper_bc50654d")
local helper_be175d5e = require("@lib/event/helper_be175d5e")
local helper_c1734684 = require("@lib/event/helper_c1734684")
local helper_cc0bf002 = require("@lib/event/helper_cc0bf002")
local helper_fd353e83 = require("@lib/event/helper_fd353e83")

--- Helper function.
local function helper_9bb21c29(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local now_sub_map_no: s32 = 0
	local flag: s32 = 0
	local var7: any = 0
	local var8: any = 0
	local var9: s32 = 0
	local var10: s32 = 0
	local var11: any = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local var14: any = 0
	local var15: s32 = 0
	local var16: s32 = 0
	local var17: any = 0
	local var18: s32 = 0
	local active_chr_no: s32 = 0
	local var20: any = 0
	event.SetMesPreset(0, 0)
	event.SetMesShippo(0, 1)
	var2 = event.GetChapter() or var2
	var3 = event.GetEventData_2(14) or var3
	event.GetNowMapNo()
	now_sub_map_no = event.GetNowSubmapNo() or now_sub_map_no
	event.CtrlcStay()
	event.SetAi(0, arg0)
	if var3 == 3 then
		helper_7746e479(arg0, arg1)
	end
	if var3 == 5 then
		helper_01e77860(arg0, arg1)
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			event.MesMake_2(0, "Let me shop\nDig for a scoop")
			var7 = helper_5b011eb5(arg0, -1, 2, 0, 0, 0)
			if var7 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var7 == 1 then
				if helper_fd353e83(0) ~= 0 then
					event.SetFadeOut(25)
					helper_25abe6d2(30)
					event.GotoMenu(6, 33)
					vm.wait(6)
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_8e455f39()
			end
		else
			event.MesMake_2(0, "Be my friend!\nDig for a scoop")
			var8 = helper_5b011eb5(arg0, -1, 2, 0, 0, 0)
			if var8 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var8 == 1 then
				if helper_fd353e83(0) ~= 0 then
					event.SetFadeOut(25)
					helper_25abe6d2(30)
					event.GotoMenu(6, 33)
					vm.wait(11)
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_3bad0658(arg0, arg1)
			end
		end
	end
	if var3 == 7 then
		helper_1e2cc126(arg0, arg1)
	end
	if var3 == 8 then
		helper_9ec16a27(arg0, arg1)
	end
	if var3 == 10 then
		helper_9af7df2e(arg0, arg1)
	end
	if var3 == 11 then
		helper_be175d5e(arg0, arg1)
	end
	if var3 == 12 then
		var9 = event.GetQuestEtc(0, 0) or var9
		var10 = event.GetQuestEtc(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hello\nBe my friend!")
			var11 = helper_8f5252f6(0, -1, 5, 256, 208, 2, 1)
			if var11 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var11 == 1 then
				helper_2c2672e0(arg0, arg1)
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_8e455f39()
		else
			helper_2c2672e0(arg0, arg1)
		end
	end
	if var3 == 14 then
		helper_c1734684(arg0, arg1)
	end
	if var3 == 15 then
		var12 = event.GetQuestEtc(0, 0) or var12
		var13 = event.GetQuestEtc(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hello\nBe my friend!")
			var14 = helper_8f5252f6(0, -1, 5, 256, 208, 2, 1)
			if var14 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var14 == 1 then
				helper_25344864(arg0, arg1)
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_8e455f39()
		else
			helper_25344864(arg0, arg1)
		end
	end
	if var3 == 16 then
		helper_5a276f97(arg0, arg1)
	end
	if var3 == 17 then
		helper_cc0bf002(arg0, arg1)
	end
	if var3 == 18 then
		var15 = event.GetQuestEtc(0, 0) or var15
		var16 = event.GetQuestEtc(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hello\nBe my friend!")
			var17 = helper_8f5252f6(0, -1, 5, 256, 208, 2, 1)
			if var17 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var17 == 1 then
				helper_bc50654d(arg0, arg1)
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_8e455f39()
		else
			helper_bc50654d(arg0, arg1)
		end
	end
	if var3 == 19 then
		helper_a67d4aed(arg0, arg1)
	end
	if var3 == 20 then
		helper_44cb2c2d(arg0, arg1)
	end
	if var3 == 21 then
		helper_2cb50640(arg0, arg1)
	end
	if var3 == 23 then
		helper_86f2149f(arg0, arg1)
	end
	if var3 == 24 then
		helper_127e8072(arg0, arg1)
	end
	if var3 == 25 then
		helper_74e84031(arg0, arg1)
	end
	if var3 == 33 then
		var18 = event.GetQuestEtc(0, 8) or var18
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Let me shop\nHello")
			var20 = helper_8f5252f6(0, -1, 5, 256, 208, 2, 1)
			if var20 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var20 == 1 then
				helper_4d9a7999(arg0, arg1)
				event.SetAi(1, arg0)
				return
			end
		end
		helper_8e455f39()
	end
	if var3 == 1 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"Lately I've been having a hard time\nseeing all the tiny little parts.<page>Guess I'm gettin' a bit\nlong in the tooth..."
			)
		else
			event.MesMake_2(
				0,
				"Seeing the Blackstone Railroad\noperate all over the continent is a\ndream both Need and I share.<page>We can count on you to help, right?"
			)
		end
		helper_899661d6(arg0, -1, 0, 0)
	end
	if var3 == 2 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "If I don't have my hands in\nsomething at all times,\nI get real cranky.")
		else
			event.MesMake_2(
				0,
				"If they discover Zelmite I'll\nbe real busy too. That's right.\nI'd dig, dig and dig some more!!"
			)
		end
		helper_899661d6(arg0, -1, 0, 0)
	end
	if var3 == 6 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"You know, I have a lot of bugs\nin my feathers these days,\nand they make me itch terribly."
			)
		else
			event.MesMake_2(
				0,
				"It's fine if you spend your time\nhunting for Zelmite. Just don't\npush yourself too hard, kid."
			)
		end
		helper_899661d6(arg0, -1, 0, 0)
	end
	if var3 == 13 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"I love the smell of gunpowder!\nThis job is really made for me.<page>Then again, my boss is awfully\nstubborn and old-fashioned.\nOh, well."
			)
		else
			event.MesMake_2(0, "You really like all this\nadventure, don't ya.")
		end
		helper_899661d6(arg0, -1, 0, 0)
	end
	if var3 == 22 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"Apart from the fact that I started\nlife as a picture, I'm no different\nthan any other person."
			)
		else
			event.MesMake_2(0, "I've got a bad feeling about Zelmite Mine.\nJust be careful, okay?")
		end
		helper_899661d6(arg0, -1, 0, 0)
	end
	event.SetAi(1, arg0)
end

return helper_9bb21c29
