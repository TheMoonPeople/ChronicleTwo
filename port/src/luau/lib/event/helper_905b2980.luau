--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0b4ad783 = require("@lib/event/helper_0b4ad783")
local helper_1a42868c = require("@lib/event/helper_1a42868c")
local helper_3000b46a = require("@lib/event/helper_3000b46a")
local helper_30c30f62 = require("@lib/event/helper_30c30f62")
local helper_4d397cfd = require("@lib/event/helper_4d397cfd")
local helper_4d492cd9 = require("@lib/event/helper_4d492cd9")
local helper_51d43c22 = require("@lib/event/helper_51d43c22")
local helper_63c26c84 = require("@lib/event/helper_63c26c84")
local helper_6b4bde73 = require("@lib/event/helper_6b4bde73")
local helper_82478469 = require("@lib/event/helper_82478469")
local helper_84ed503e = require("@lib/event/helper_84ed503e")
local helper_8b06109f = require("@lib/event/helper_8b06109f")
local helper_9137368e = require("@lib/event/helper_9137368e")
local helper_9401ebd6 = require("@lib/event/helper_9401ebd6")
local helper_9670dbc2 = require("@lib/event/helper_9670dbc2")
local helper_9e12c98a = require("@lib/event/helper_9e12c98a")
local helper_aa0e6104 = require("@lib/event/helper_aa0e6104")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")
local helper_b2ec7ec9 = require("@lib/event/helper_b2ec7ec9")
local helper_c5242679 = require("@lib/event/helper_c5242679")
local helper_ca619fb1 = require("@lib/event/helper_ca619fb1")
local helper_d5eb71b2 = require("@lib/event/helper_d5eb71b2")
local helper_d68037b5 = require("@lib/event/helper_d68037b5")
local helper_d7258009 = require("@lib/event/helper_d7258009")
local helper_e7210099 = require("@lib/event/helper_e7210099")
local helper_fbf4335b = require("@lib/event/helper_fbf4335b")

--- Helper function.
local function helper_905b2980(arg0: s32, arg1: s32)
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
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_9137368e(arg0, arg1)
			end
			if at <= 2 then
				var7 = helper_4d397cfd(arg0, -1, 2, 0, 0, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				helper_aafd6a80(30)
			end
			return
		end
		if at <= 8 then
			if at <= 7 then
				var8 = helper_4d397cfd(arg0, -1, 2, 0, 0, 0)
			end
			return
		end
		if at <= 11 then
			if at <= 9 then
				helper_aafd6a80(30)
			end
			return
		end
		if at <= 17 then
			if at <= 12 then
				helper_d68037b5(arg0, arg1)
			end
			if at <= 13 then
				helper_9e12c98a(arg0, arg1)
			end
			if at <= 14 then
				helper_9401ebd6(arg0, arg1)
			end
			if at <= 15 then
				helper_0b4ad783(arg0, arg1)
			end
			if at <= 16 then
				var11 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 18 then
			return
		end
		if at <= 22 then
			if at <= 19 then
				helper_9670dbc2(arg0, arg1)
			end
			if at <= 20 then
				helper_82478469(arg0, arg1)
			end
			if at <= 21 then
				var14 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 23 then
			return
		end
		if at <= 28 then
			if at <= 24 then
				helper_b2ec7ec9(arg0, arg1)
			end
			if at <= 25 then
				helper_fbf4335b(arg0, arg1)
			end
			if at <= 26 then
				helper_ca619fb1(arg0, arg1)
			end
			if at <= 27 then
				var17 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 29 then
			return
		end
		if at <= 38 then
			if at <= 30 then
				helper_aa0e6104(arg0, arg1)
			end
			if at <= 31 then
				helper_d5eb71b2(arg0, arg1)
			end
			if at <= 32 then
				helper_e7210099(arg0, arg1)
			end
			if at <= 33 then
				helper_6b4bde73(arg0, arg1)
			end
			if at <= 34 then
				helper_d7258009(arg0, arg1)
			end
			if at <= 35 then
				helper_4d492cd9(arg0, arg1)
			end
			if at <= 36 then
				helper_c5242679(arg0, arg1)
			end
			if at <= 37 then
				var20 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 39 then
			return
		end
		if at <= 40 then
			helper_30c30f62(arg0, -1, 0, 0)
		end
		if at <= 41 then
			helper_30c30f62(arg0, -1, 0, 0)
		end
		if at <= 42 then
			helper_30c30f62(arg0, -1, 0, 0)
		end
		if at <= 43 then
			helper_30c30f62(arg0, -1, 0, 0)
		end
		if at <= 44 then
			helper_30c30f62(arg0, -1, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	event.SetMesShippo(0, 1)
	var2 = event.GetChapter() or var2
	var3 = event.GetEventData_2(14) or var3
	event.GetNowMapNo()
	now_sub_map_no = event.GetNowSubmapNo() or now_sub_map_no
	event.CtrlcStay()
	event.SetAi(0, arg0)
	if var3 == 3 then
		helper_63c26c84(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
	end
	if var3 == 5 then
		helper_9137368e(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			event.MesMake_2(0, "Let me shop\nDig for a scoop")
			var7 = helper_4d397cfd(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(3)
			end
			if var7 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var7 == 1 then
				local t0 = helper_8b06109f(0)
				if vm.skipping() then
					return skip(4)
				end
				if t0 ~= 0 then
					event.SetFadeOut(25)
					helper_aafd6a80(30)
					if vm.skipping() then
						return skip(5)
					end
					event.GotoMenu(6, 33)
					if vm.wait() then
						return skip(6)
					end
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_84ed503e()
				if vm.skipping() then
					return skip(7)
				end
			end
		else
			event.MesMake_2(0, "Be my friend!\nDig for a scoop")
			var8 = helper_4d397cfd(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			if var8 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var8 == 1 then
				local t1 = helper_8b06109f(0)
				if vm.skipping() then
					return skip(9)
				end
				if t1 ~= 0 then
					event.SetFadeOut(25)
					helper_aafd6a80(30)
					if vm.skipping() then
						return skip(10)
					end
					event.GotoMenu(6, 33)
					if vm.wait() then
						return skip(11)
					end
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_1a42868c(arg0, arg1)
				if vm.skipping() then
					return skip(12)
				end
			end
		end
	end
	if var3 == 7 then
		helper_d68037b5(arg0, arg1)
		if vm.skipping() then
			return skip(13)
		end
	end
	if var3 == 8 then
		helper_9e12c98a(arg0, arg1)
		if vm.skipping() then
			return skip(14)
		end
	end
	if var3 == 10 then
		helper_9401ebd6(arg0, arg1)
		if vm.skipping() then
			return skip(15)
		end
	end
	if var3 == 11 then
		helper_0b4ad783(arg0, arg1)
		if vm.skipping() then
			return skip(16)
		end
	end
	if var3 == 12 then
		var9 = event.GetQuestEtc(0, 0) or var9
		var10 = event.GetQuestEtc(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hello\nBe my friend!")
			var11 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(17)
			end
			if var11 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var11 == 1 then
				helper_9670dbc2(arg0, arg1)
				if vm.skipping() then
					return skip(18)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_84ed503e()
			if vm.skipping() then
				return skip(19)
			end
		else
			helper_9670dbc2(arg0, arg1)
			if vm.skipping() then
				return skip(20)
			end
		end
	end
	if var3 == 14 then
		helper_82478469(arg0, arg1)
		if vm.skipping() then
			return skip(21)
		end
	end
	if var3 == 15 then
		var12 = event.GetQuestEtc(0, 0) or var12
		var13 = event.GetQuestEtc(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hello\nBe my friend!")
			var14 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(22)
			end
			if var14 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var14 == 1 then
				helper_b2ec7ec9(arg0, arg1)
				if vm.skipping() then
					return skip(23)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_84ed503e()
			if vm.skipping() then
				return skip(24)
			end
		else
			helper_b2ec7ec9(arg0, arg1)
			if vm.skipping() then
				return skip(25)
			end
		end
	end
	if var3 == 16 then
		helper_fbf4335b(arg0, arg1)
		if vm.skipping() then
			return skip(26)
		end
	end
	if var3 == 17 then
		helper_ca619fb1(arg0, arg1)
		if vm.skipping() then
			return skip(27)
		end
	end
	if var3 == 18 then
		var15 = event.GetQuestEtc(0, 0) or var15
		var16 = event.GetQuestEtc(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hello\nBe my friend!")
			var17 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(28)
			end
			if var17 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var17 == 1 then
				helper_aa0e6104(arg0, arg1)
				if vm.skipping() then
					return skip(29)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_84ed503e()
			if vm.skipping() then
				return skip(30)
			end
		else
			helper_aa0e6104(arg0, arg1)
			if vm.skipping() then
				return skip(31)
			end
		end
	end
	if var3 == 19 then
		helper_d5eb71b2(arg0, arg1)
		if vm.skipping() then
			return skip(32)
		end
	end
	if var3 == 20 then
		helper_e7210099(arg0, arg1)
		if vm.skipping() then
			return skip(33)
		end
	end
	if var3 == 21 then
		helper_6b4bde73(arg0, arg1)
		if vm.skipping() then
			return skip(34)
		end
	end
	if var3 == 23 then
		helper_d7258009(arg0, arg1)
		if vm.skipping() then
			return skip(35)
		end
	end
	if var3 == 24 then
		helper_4d492cd9(arg0, arg1)
		if vm.skipping() then
			return skip(36)
		end
	end
	if var3 == 25 then
		helper_c5242679(arg0, arg1)
		if vm.skipping() then
			return skip(37)
		end
	end
	if var3 == 33 then
		var18 = event.GetQuestEtc(0, 8) or var18
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Let me shop\nHello")
			var20 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(38)
			end
			if var20 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var20 == 1 then
				helper_51d43c22(arg0, arg1)
				if vm.skipping() then
					return skip(39)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		helper_84ed503e()
		if vm.skipping() then
			return skip(40)
		end
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
		helper_30c30f62(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(41)
		end
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
		helper_30c30f62(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(42)
		end
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
		helper_30c30f62(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(43)
		end
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
		helper_30c30f62(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(44)
		end
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
		helper_30c30f62(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(45)
		end
	end
	event.SetAi(1, arg0)
end

return helper_905b2980
