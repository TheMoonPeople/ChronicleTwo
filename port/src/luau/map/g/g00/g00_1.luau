--!strict
-- map/g/g00/g00_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4005e7b5 = require("@lib/event/helper_4005e7b5")
local helper_62059bfe = require("@lib/event/helper_62059bfe")
local helper_7e2956fd = require("@lib/event/helper_7e2956fd")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")
local helper_b8950300 = require("@lib/event/helper_b8950300")
local helper_bf8a16c2 = require("@lib/event/helper_bf8a16c2")
local helper_c6c63376 = require("@lib/event/helper_c6c63376")
local helper_d1353c5b = require("@lib/event/helper_d1353c5b")
local helper_dc39b923 = require("@lib/event/helper_dc39b923")

--- Helper function.
local function helper_be7c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	if arg1 == 1 then
		event.MesMake_2(
			arg0,
			"Seeing the Blackstone Railroad\noperate all over the continent is a\ndream both Need and I share.<page>We can count on you to help, right?"
		)
	end
	if arg1 == 2 then
		event.MesMake_2(
			arg0,
			"If they discover Zelmite I'll\nbe real busy too. That's right.\nI'd dig, dig and dig some more!!"
		)
	end
	if arg1 == 3 then
		event.MesMake_2(arg0, "There must be so many plants out\nthere we haven't even seen yet.")
	end
	if arg1 == 4 then
		event.MesMake_2(arg0, "Hey! How goes the Zelmite hunt?\nIf there's anything I can do,\njust gimme a holler.")
	end
	if arg1 == 5 then
		event.MesMake_2(
			arg0,
			"The world of pictures is very deep.\nIt may take me a lifetime to master\nbut the journey is well worth it."
		)
	end
	if arg1 == 6 then
		event.MesMake_2(
			arg0,
			"It's fine if you spend your time\nhunting for Zelmite. Just don't\npush yourself too hard, kid."
		)
	end
	if arg1 == 7 then
		event.MesMake_2(
			arg0,
			"I'm going to be the world's best\nchef someday, and when I do,\nyou can eat free anytime."
		)
	end
	if arg1 == 8 then
		event.MesMake_2(arg0, "At long last the Blackstone\nRailroad takes on the world.\nIt's so exciting!")
	end
	if arg1 == 9 then
		event.MesMake_2(arg0, "Hey, how ya doin'? I'm doin' great!")
	end
	if arg1 == 10 then
		event.MesMake_2(arg0, "Zelmite Mine is a very scary place.\nYou must be sure to never let\nyour guard down.")
	end
	if arg1 == 11 then
		event.MesMake_2(arg0, "I pray for your safety...")
	end
	if arg1 == 12 then
		event.MesMake_2(arg0, "If you're ever in the mood for\nbread, you know where to find me.")
	end
	if arg1 == 13 then
		event.MesMake_2(arg0, "You really like all this\nadventure, don't ya.")
	end
	if arg1 == 14 then
		event.MesMake_2(arg0, "If there's anything I can help you\nwith, don't you hesitate to ask.")
	end
	if arg1 == 15 then
		event.MesMake_2(arg0, "So, what's the scoop? Come across\nany tough guys in that mine yet?")
	end
	if arg1 == 16 then
		event.MesMake_2(
			arg0,
			"From now on I'm going to be helping\nNeed and Cedric rebuild the world.\nWe have to work together on this."
		)
	end
	if arg1 == 17 then
		event.MesMake_2(
			arg0,
			"Just on a personal note here, I\nknow Zelmite Mine is a dangerous\nplace. Don't do anything foolish."
		)
	end
	if arg1 == 18 then
		event.MesMake_2(arg0, "I pray that the world will\nfrom today forever be at peace.")
	end
	if arg1 == 19 then
		event.MesMake_2(
			arg0,
			"If the Blackstone Railroad goes all\nover the world, we'll be able to\nvisit lots of cool new places."
		)
	end
	if arg1 == 20 then
		event.MesMake_2(
			arg0,
			"I can't wait to check out all the\nnew fishing spots all over the\nworld. It's gonna be so fun."
		)
	end
	if arg1 == 21 then
		event.MesMake_2(
			arg0,
			"I just wish that Fabio would have\na bit of an interest in something\noutside of fishing, too."
		)
	end
	if arg1 == 22 then
		event.MesMake_2(arg0, "I've got a bad feeling about Zelmite Mine.\nJust be careful, okay?")
	end
	if arg1 == 23 then
		event.MesMake_2(
			arg0,
			"If the Blackstone Railroad spreads\nall around the world, maybe I'll\nhave to go around the world too."
		)
	end
	if arg1 == 24 then
		event.MesMake_2(
			arg0,
			"You can't fool me. I know you've\nbeen off doing all sorts of fun\nstuff. Tell me about it sometime!"
		)
	end
	if arg1 == 25 then
		event.MesMake_2(
			arg0,
			'When the Blackstone Railroad is\nall done, I\'d just love to \ngo to the "Ends of the Earth".'
		)
	end
end

--- Helper function.
local function helper_205d8(arg0: s32, arg1: s32, sp: number)
	local junk = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bf8a16c2(var4, -1, 0, 0, sp + junk + 8)
			junk += 3
		end
		helper_be7c(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		if arg1 == 1 then
			flag = event.GetFlag(57) or flag
			if flag == 0 then
				event.SetFlag(57, 1)
				event.MesMake_2(
					arg0,
					"I'm livin' here now,\nbut I'm more worried\nabout Blackstone One.<page>I'm the one who'll be\nkeepin' the train runnin',\njust like old times."
				)
				var4 = event.GetEventData_2(13) or var4
				helper_bf8a16c2(var4, -1, 0, 0, sp + junk + 5)
				if vm.skipping() then
					return skip(2)
				end
				event.MesMake_2(
					arg0,
					"Borneo's a bit heavy-handed,\nand Erik's just a kid.<page>Nothing but home, work,\nhome and work again every\nday for the likes of me.<page>But that's life, eh..."
				)
			else
				event.MesMake_2(arg0, "How's Steve doin'?")
			end
		end
		if arg1 == 2 then
			event.MesMake_2(arg0, "I can't handle just sitting in my\nroom, twiddlin' my thumbs.")
		end
		if arg1 == 3 then
			event.MesMake_2(
				arg0,
				"Plants and flowers only grow as\nwell as you look after them. I\ncould never neglect my babies."
			)
		end
		if arg1 == 4 then
			event.MesMake_2(
				arg0,
				"Wonder if the secret base is okay.\nI wish I could ask someone to check\nit out, but it's a secret, you know?"
			)
		end
		if arg1 == 5 then
			event.MesMake_2(
				arg0,
				"Purple's a great colour.\nIt's got a warm kinda coolness,\nand a bright kinda darkness."
			)
		end
		if arg1 == 6 then
			event.MesMake_2(arg0, "If someone's sick\nI'll go anywhere to help.")
		end
		if arg1 == 7 then
			event.MesMake_2(arg0, "Only a top chef can \nmake delicious food \neverywhere he goes.")
		end
		if arg1 == 8 then
			event.MesMake_2(arg0, "When it comes to houses, the\nsturdier the better, right?")
		end
		if arg1 == 9 then
			event.MesMake_2(
				arg0,
				"Nuts are pretty good, but those red\nthings were simply scrumptious.\nThink you could bring me some more?"
			)
		end
		if arg1 == 10 then
			event.MesMake_2(
				arg0,
				"Damp air is a book's worst enemy.\nI don't think I could ever tolerate\nliving near water."
			)
		end
		if arg1 == 11 then
			event.MesMake_2(arg0, "They're not cute or trendy, but I\nmake clothes that no one else in\nthe world can.")
		end
		if arg1 == 12 then
			event.MesMake_2(arg0, "A new place, a new me.\nI feel like a young baker again.")
		end
		if arg1 == 13 then
			event.MesMake_2(arg0, "I don't care what,\nI just wanna smash something\ninto millions of tiny pieces!")
		end
		if arg1 == 14 then
			event.MesMake_2(arg0, "If you discover a new monster,\nbe sure to report it right away.")
		end
		if arg1 == 15 then
			event.MesMake_2(
				arg0,
				"Some say it's not for women,\nbut the sword does not care who\nholds it. May the best fighter win."
			)
		end
		if arg1 == 16 then
			event.MesMake_2(arg0, "This little house might not be a\nbad place to raise a family.")
		end
		if arg1 == 17 then
			event.MesMake_2(arg0, "I wonder if Morton's staying on the\nball. He has me a bit worried...")
		end
		if arg1 == 18 then
			event.MesMake_2(arg0, "If you know of a town in need of a\nchurch, I'm your priest. Just let\nme know.")
		end
		if arg1 == 19 then
			event.MesMake_2(
				arg0,
				"I haven't been thinking about the\nmoon much lately anymore. It must\nbe because of all my new friends."
			)
		end
		if arg1 == 20 then
			event.MesMake_2(
				arg0,
				"Different place, different fish.\nYou have to change your thinking\nto match the territory."
			)
		end
		if arg1 == 21 then
			event.MesMake_2(arg0, "This water looks perfect for fish.")
		end
		if arg1 == 22 then
			event.MesMake_2(
				arg0,
				"Parn's started on another picture\nof a woman. Says this time she'll\nbe prettier than even me."
			)
		end
		if arg1 == 23 then
			event.MesMake_2(arg0, "I wonder why insects look\nso revolting...")
		end
		if arg1 == 24 then
			event.MesMake_2(arg0, "Can you make my house any cuter?\nA house can never be too cute,\nyou know!")
		end
		if arg1 == 25 then
			event.MesMake_2(arg0, "I never imagined I'd be\nmoving at this age.")
		end
	else
		helper_be7c(arg0, arg1)
	end
end

--- Helper function.
local function helper_21b24(sp: number)
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bf8a16c2(var1, -1, 0, 0, sp + 3)
		end
	end
	event.GetControlChrid()
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Hello there.\nGreat weather, isn't it.")
	helper_205d8(0, var2, sp + 3)
	if vm.skipping() then
		return skip(1)
	end
	helper_bf8a16c2(var1, -1, 0, 0, sp + 3)
	if vm.skipping() then
		return skip(2)
	end
	event.SetAi(1, var1)
end

--- Helper function.
local function helper_21e28()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_7e2956fd(1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(0)
	event.SetMesEtc(1, 4, -1, -1, -1, -1)
	event.SetMesEtc(1, 9, -1, -1)
	helper_7e2956fd(1)
	event.Finish()
end

--- Helper function.
local function helper_21fd4(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b0211f82(30)
		end
		helper_21e28()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(25)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoMenu(6, arg0)
	if vm.wait() then
		return skip(3)
	end
	helper_21e28()
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_e434(arg0: s32)
	local var1: s32 = 0
	local player_chara: s32 = 0
	local now_map_no: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return 1
		end
		if at <= 2 then
			helper_d1353c5b(arg0, -1, 3, 256, 208)
		end
		if at <= 3 then
			helper_4005e7b5(arg0, 1)
			helper_b8950300(arg0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_d1353c5b(arg0, -1, 3, 256, 208)
		end
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	do
		local out1, out2 = event.GetMenuEtc_3(6)
		var4 = out1 or var4
		var5 = out2 or var5
	end
	if 0 < var4 then
		return 1
	end
	if var5 == 1 then
		helper_4005e7b5(arg0, 1)
		event.MesMake_2(arg0, "If you don't bring me more scoops,\nI can't give ya nothin'!")
		if now_map_no == 22 then
			helper_b8950300(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			helper_d1353c5b(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(3)
			end
		end
	end
	if var5 == 2 then
		helper_4005e7b5(arg0, 1)
		event.MesMake_2(
			arg0,
			"Your Photography level's determined\nby the number of ideas and scoops\nyou have.<page>And as your level goes up, you get\nmore cool items as rewards."
		)
		if now_map_no == 22 then
			helper_b8950300(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(4)
			end
		else
			helper_d1353c5b(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(5)
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_ea7c(arg0: s32)
	local var1: s32 = 0
	local player_chara: s32 = 0
	local now_map_no: s32 = 0
	local argc: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_d1353c5b(arg0, -1, 3, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				helper_d1353c5b(arg0, -1, 3, 256, 208)
			end
			return helper_e434(arg0)
		end
		if at <= 5 then
			helper_4005e7b5(arg0, 1)
			helper_b8950300(arg0, -1, var1, player_chara, 0)
		end
		if at <= 6 then
			helper_d1353c5b(arg0, -1, 3, 256, 208)
		end
		return helper_e434(arg0)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	argc = event.GetItemHaveNum(355) or argc
	if argc <= 0 then
		helper_4005e7b5(arg0, 1)
		event.MesMake_2(arg0, "Go get me a\nScoop Memo, will ya?")
		if now_map_no == 22 then
			helper_b8950300(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_d1353c5b(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		return 0
	end
	do
		local out1, out2 = event.GetMenuEtc_3(5)
		var5 = out1 or var5
		var6 = out2 or var6
	end
	if var5 == var6 then
		helper_4005e7b5(arg0, 1)
		event.MesMake_2(arg0, "Looks like there's\nno more scoops to be had.")
		if now_map_no == 22 then
			helper_b8950300(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(3)
			end
		else
			helper_d1353c5b(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(4)
			end
		end
		return helper_e434(arg0)
	end
	var7 = event.GetMenuEtc_2(3) or var7
	if 0 < var7 then
		helper_4005e7b5(arg0, 8)
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "I figured out [Number1] more scoops.")
		event.SetMesDrawspeed(arg0, 0)
		helper_d1353c5b(arg0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
	end
	helper_4005e7b5(arg0, 1)
	var7 = event.GetMenuEtc_2(4) or var7
	if var7 <= 0 then
		event.MesMake_2(arg0, "Come on, man! Quit slackin'!\nWhere's all your new inside scoops?")
	else
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Woo! You got [Number1] new scoops!\nI knew you had it in ya!")
	end
	if now_map_no == 22 then
		helper_b8950300(arg0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(6)
		end
	else
		helper_d1353c5b(arg0, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(7)
		end
	end
	return helper_e434(arg0)
end

--- Helper function.
local function helper_d164()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(732) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Great job! Humans\naren't so bad after all!<page>I was wrong!")
		return
	end
	flag = event.GetFlag(728) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"This is it. It's almost over.\nAll we have to do is defeat him.<page>And after that, the world can live again."
		)
		return
	end
	flag = event.GetFlag(712) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"I guess I know how Griffon feels, but I don't\nthink I could ever forgive him for what he did."
		)
		return
	end
	flag = event.GetFlag(702) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Return the garden to its former state, and\nexpose the secret of Griffon, I mean, Sirus.")
		return
	end
	flag = event.GetFlag(700) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"I wonder what she means, \"Sirus' memories.\"\nI guess we'll have to enter the palace to find out."
		)
		return
	end
	flag = event.GetFlag(640) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Griffon'll get away if we just stand around like\nthis. Let's get to the Moon Flower Palace, quick."
		)
		return
	end
	flag_2 = event.GetFlag(624) or flag_2
	flag_3 = event.GetFlag(628) or flag_3
	flag_4 = event.GetFlag(632) or flag_4
	flag_5 = event.GetFlag(636) or flag_5
	if (if (if (if flag_2 ~= 0 then flag_3 else 0) ~= 0 then flag_4 else 0) ~= 0 then flag_5 else 0) ~= 0 then
		event.MesMake_2(3, "Looks like we got all the gems. Now we\njust have to hurry to Kazarov Stonehenge.")
		return
	end
	flag = event.GetFlag(616) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Whatever it is, we better find the gems\nquick, before it's too late.")
		return
	end
	flag = event.GetFlag(600) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Everything started at this palace, huh.\nAnyway, let's head into the garden.")
		return
	end
	flag = event.GetFlag(540) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "We better head back to Luna Lab soon.\nThey may be finished with Ixion already.")
		return
	end
	flag = event.GetFlag(536) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "It's about time to strike back against\nGriffon. Let's head over to the Paznos base.")
		return
	end
	flag = event.GetFlag(526) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Don't just stand there!\nWe got to rescue Monica, fast!")
		return
	end
	flag = event.GetFlag(524) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Remember? Galen Agaris said that if you\nplay the Fire Horn the road will open up.")
		return
	end
	flag = event.GetFlag(520) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Don't just stand there!\nWe got to rescue Monica, fast!")
		return
	end
	flag = event.GetFlag(508) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Gotta blow that Firesquall to bits.<page>So it's up there on top of Mt. Gundor, huh?")
		return
	end
	event.MesMake_2(
		3,
		"Just waiting here won't change anything.<page>There's got to be some places we haven't been to yet."
	)
end

--- Helper function.
local function helper_220f0(sp: number)
	local junk = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local now_map_no: s32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: any = 0
	local var30: s32 = 0
	local var31: s32 = 0
	local var32: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				var4 = 0
				var4 = 20
				var4 = 24
				var4 = 28
				var4 = 32
				var4 = 40
				var4 = 44
				var4 = 48
				var4 = 52
				var4 = 56
				var23 = vm.f32(vm.sin(var18) * 30.0)
				var23 = vm.f32(var23 + var5)
				var24 = vm.f32(var6 + 33.0)
				var25 = vm.f32(vm.cos(var18) * 30.0)
				var25 = vm.f32(var25 + var7)
				var26 = var5
				var27 = vm.f32(var6 + 30.0)
				var28 = var7
				junk += 25
			end
			if at <= 2 then
				var29 = 0
				helper_4005e7b5(3, 1)
				helper_205d8(3, var2, sp + junk + 34)
				junk += 1
			end
			if at <= 3 then
				var30 = -1
				helper_4005e7b5(1, 8)
				helper_dc39b923(1, 1, 1, 0, 0)
				helper_4005e7b5(2, 2)
				var30 = 30
				var30 = 31
				var30 = 32
				var29 = helper_62059bfe(2, var30, 7, 0, 0, var32, vm.i32(var32 - 1))
				junk += 3
			end
			helper_21e28()
			return
		end
		if at <= 6 then
			helper_21e28()
			return
		end
		if at <= 11 then
			if at <= 7 then
				helper_4005e7b5(3, 8)
				helper_d1353c5b(3, var30, 9, 0, 0)
				junk += 1
			end
			if at <= 8 then
				helper_d1353c5b(3, -1, 3, 256, 208)
				junk += 4
			end
			if at <= 9 then
				helper_21e28()
				helper_21fd4(6)
				junk += 1
			end
			if at <= 10 then
				helper_21fd4(23)
				junk += 2
			end
			return
		end
		if at <= 13 then
			if at <= 12 then
				helper_21fd4(33)
			end
			return
		end
		if at <= 14 then
			helper_21fd4(1)
			junk += 1
		end
		if at <= 15 then
			helper_21fd4(2)
			junk += 1
		end
		if at <= 16 then
			helper_21fd4(3)
			junk += 1
		end
		if at <= 17 then
			helper_21fd4(7)
			junk += 1
		end
		if at <= 18 then
			helper_21fd4(8)
			junk += 1
		end
		if at <= 19 then
			helper_21fd4(9)
			junk += 1
		end
		if at <= 20 then
			helper_21fd4(10)
			junk += 1
		end
		if at <= 21 then
			helper_21fd4(11)
			junk += 1
		end
		if at <= 22 then
			helper_21fd4(12)
			junk += 1
		end
		if at <= 23 then
			helper_21fd4(13)
			junk += 1
		end
		if at <= 24 then
			helper_21fd4(14)
			junk += 1
		end
		if at <= 25 then
			helper_21fd4(15)
			junk += 1
		end
		if at <= 26 then
			helper_21fd4(16)
			junk += 1
		end
		if at <= 27 then
			helper_21fd4(17)
			junk += 1
		end
		if at <= 28 then
			helper_21fd4(18)
			junk += 1
		end
		if at <= 29 then
			helper_21fd4(19)
			junk += 1
		end
		if at <= 30 then
			helper_21fd4(20)
			junk += 1
		end
		if at <= 31 then
			helper_21fd4(21)
			junk += 1
		end
		if at <= 32 then
			helper_21fd4(22)
			junk += 1
		end
		if at <= 33 then
			helper_21fd4(32)
			junk += 1
		end
		if at <= 34 then
			helper_d164()
			helper_d1353c5b(3, -1, 3, 256, 208)
			junk += 1
		end
		if at <= 35 then
			helper_21e28()
			helper_b0211f82(30)
			junk += 1
		end
		helper_21e28()
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	event.SetMotion(0, "立ち")
	event.SetMotion(var1, "立ち")
	event.Initialize()
	event.SetMesPreset(1, 0)
	var4 = 0
	if var2 == 18 then
		var4 = 20
	end
	if var2 == 25 then
		var4 = 24
	end
	if var2 == 12 or var2 == 17 then
		var4 = 28
	end
	if var2 == 7 then
		var4 = 32
	end
	if var2 == 10 or var2 == 6 or var2 == 24 then
		var4 = 40
	end
	if var2 == 8 or var2 == 1 or var2 == 2 or var2 == 3 or var2 == 15 or var2 == 16 or var2 == 21 then
		var4 = 44
	end
	if var2 == 4 or var2 == 19 or var2 == 20 or var2 == 22 then
		var4 = 48
	end
	if var2 == 5 or var2 == 11 or var2 == 23 or var2 == 13 then
		var4 = 52
	end
	if var2 == 9 then
		var4 = 56
	end
	event.SetMesEtc(1, 4, 30, 60, 168, -1)
	event.SetMesEtc(1, 9, 20 + var4, 16)
	do
		local out1, _, out3 = event.GetCharaPos(0)
		var11 = out1 or var11
		var13 = out3 or var13
	end
	do
		local out1, _, out3 = event.GetCharaRot(0)
		var14 = out1 or var14
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = event.GetCharaPos(var1)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, _, out3 = event.GetCharaRot(var1)
		var8 = out1 or var8
		var10 = out3 or var10
	end
	var17 = event.GetRotLookPos(var5 - var11, var7 - var13) or var17
	event.SetCharaRot(0, var14, var17, var16)
	var18 = event.GetRotLookPos(var11 - var5, var13 - var7) or var18
	event.SetCharaRot(var1, var8, var18, var10)
	now_map_no = event.GetNowMapNo() or now_map_no
	if now_map_no ~= 1 then
		do
			local out1, out2, out3 = event.FuncPointGetPos("", "gcamp")
			var20 = out1 or var20
			var21 = out2 or var21
			var22 = out3 or var22
		end
		event.SetCameraPos(var20, var21, var22)
		event.SetCameraRef(var5, var6 + 30.0, var7)
		var18 = event.GetRotLookPos(var20 - var5, var22 - var7) or var18
		event.SetCharaRot(var1, var8, var18, var10)
	else
		var23 = vm.f32(vm.sin(var18) * 30.0)
		var23 = vm.f32(var23 + var5)
		var24 = vm.f32(var6 + 33.0)
		var25 = vm.f32(vm.cos(var18) * 30.0)
		var25 = vm.f32(var25 + var7)
		event.SetCameraPos(var23, var24, var25)
		var26 = var5
		var27 = vm.f32(var6 + 30.0)
		var28 = var7
		event.SetCameraRef(var26, var27, var28)
	end
	event.CharaActive(0, 0)
	if vm.wait() then
		return skip(2)
	end
	event.SetCrossfade(10)
	var29 = 0
	while true do
		helper_4005e7b5(3, 1)
		helper_205d8(3, var2, sp + junk + 33)
		if vm.skipping() then
			return skip(3)
		end
		var30 = -1
		event.SetMesDrawspeed(3, 0, 0)
		helper_4005e7b5(1, 8)
		event.SetMesDrawspeed(1, 0, 0)
		var31 = event.GetPartyCharaMesNo_3(var2, 0) or var31
		event.SetMesItemDirect(1, 1, var31)
		helper_dc39b923(1, 1, 1, 0, 0)
		helper_4005e7b5(2, 2)
		do
			local out1, out2 = event.GetPartyCharaMesNo_4(var2, 4)
			var30 = out1 or var30
			var32 = out2 or var32
		end
		if var32 == 3 then
			var30 = 30
		end
		if var32 == 4 then
			event.SetMesItemDirect(2, 1, var30)
			var30 = 31
		end
		if var32 == 5 then
			event.SetMesItemDirect(2, 1, var30)
			event.SetMesItemDirect(2, 2, vm.i32(var30 + 1))
			var30 = 32
		end
		var29 = helper_62059bfe(2, var30, 7, 0, 0, var32, vm.i32(var32 - 1))
		if vm.skipping() then
			return skip(4)
		end
		if var29 == 0 then
			if var2 == now_party_chara_id then
				helper_21e28()
				event.SetCrossfade(10)
				return
			end
			if now_party_chara_id ~= 26 then
				event.SetFadeOut(25)
				helper_b0211f82(30)
				if vm.skipping() then
					return skip(5)
				end
				event.SetNpcStatus(var2, 1)
				event.GotoSelectParty()
				if vm.wait() then
					return skip(6)
				end
				helper_21e28()
				event.SetFadeIn(30)
				return
			end
			helper_4005e7b5(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			event.MesMake_2(3, "[(!)]You can't do that right now. You have\nto bring Lin to the lighthouse first!")
			helper_d1353c5b(3, -1, 9, 0, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if var29 == 1 then
			helper_4005e7b5(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			var30 = event.GetPartyCharaMesNo_3(var2, 3) or var30
			helper_d1353c5b(3, var30, 9, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if 3 < var32 then
			if var32 == 5 then
				if var29 == 2 then
					if var2 == 1 then
						event.SetSavedataEtc(2)
						event.MesMake_2(3, "Alright, we're finished\nwith repairs!")
						helper_d1353c5b(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(9)
						end
						helper_21e28()
						event.SetCrossfade(10)
					end
					if not (var2 == 4) then
						break
					end
					helper_21fd4(6)
					if vm.skipping() then
						return skip(10)
					end
					break
				end
				if var29 == 3 then
					if var2 == 1 then
						helper_21fd4(23)
						if vm.skipping() then
							return skip(11)
						end
						return
					end
					if var2 == 4 then
						local t0 = helper_ea7c(3)
						if vm.skipping() then
							junk += 1
							return skip(12)
						end
						if t0 ~= 0 then
							helper_21fd4(33)
							if vm.skipping() then
								return skip(13)
							end
							return
						end
					end
				end
				if var29 == 4 then
					break
				end
				if var29 == -1 then
					break
				end
			else
				if var29 == 2 then
					if var2 == 15 then
						helper_21fd4(0)
						if vm.skipping() then
							return skip(14)
						end
					end
					if var2 == 12 then
						helper_21fd4(1)
						if vm.skipping() then
							return skip(15)
						end
					end
					if var2 == 6 then
						helper_21fd4(2)
						if vm.skipping() then
							return skip(16)
						end
					end
					if var2 == 7 then
						helper_21fd4(3)
						if vm.skipping() then
							return skip(17)
						end
					end
					if var2 == 2 then
						helper_21fd4(7)
						if vm.skipping() then
							return skip(18)
						end
					end
					if var2 == 3 then
						helper_21fd4(8)
						if vm.skipping() then
							return skip(19)
						end
					end
					if var2 == 5 then
						helper_21fd4(9)
						if vm.skipping() then
							return skip(20)
						end
					end
					if var2 == 8 then
						helper_21fd4(10)
						if vm.skipping() then
							return skip(21)
						end
					end
					if var2 == 10 then
						helper_21fd4(11)
						if vm.skipping() then
							return skip(22)
						end
					end
					if var2 == 11 then
						helper_21fd4(12)
						if vm.skipping() then
							return skip(23)
						end
					end
					if var2 == 13 then
						helper_21fd4(13)
						if vm.skipping() then
							return skip(24)
						end
					end
					if var2 == 16 then
						helper_21fd4(14)
						if vm.skipping() then
							return skip(25)
						end
					end
					if var2 == 18 then
						helper_21fd4(15)
						if vm.skipping() then
							return skip(26)
						end
					end
					if var2 == 19 then
						helper_21fd4(16)
						if vm.skipping() then
							return skip(27)
						end
					end
					if var2 == 20 then
						helper_21fd4(17)
						if vm.skipping() then
							return skip(28)
						end
					end
					if var2 == 21 then
						helper_21fd4(18)
						if vm.skipping() then
							return skip(29)
						end
					end
					if var2 == 22 then
						helper_21fd4(19)
						if vm.skipping() then
							return skip(30)
						end
					end
					if var2 == 23 then
						helper_21fd4(20)
						if vm.skipping() then
							return skip(31)
						end
					end
					if var2 == 24 then
						helper_21fd4(21)
						if vm.skipping() then
							return skip(32)
						end
					end
					if var2 == 25 then
						helper_21fd4(22)
						if vm.skipping() then
							return skip(33)
						end
					end
					if var2 == 17 then
						helper_21fd4(32)
						if vm.skipping() then
							return skip(34)
						end
					end
					if var2 == 9 then
						helper_d164()
						helper_d1353c5b(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(35)
						end
						helper_21e28()
						event.SetCrossfade(10)
					end
					if var2 == 14 then
						event.SetFadeOut(25)
						helper_b0211f82(30)
						if vm.skipping() then
							return skip(36)
						end
						event.GotoMenu(25)
						if vm.wait() then
							return skip(37)
						end
						helper_21e28()
						event.SetFadeIn(30)
					end
					return
				end
				if var29 == 3 then
					break
				end
				if var29 == -1 then
					break
				end
			end
		else
			if var29 == 2 then
				break
			end
			if var29 == -1 then
				break
			end
		end
	end
	helper_21e28()
	event.SetCrossfade(10)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_c6c63376

--- Program 100.
script[100] = function()
	helper_c6c63376()
	event.ResetCamera(1, 0.0)
	event.SetFadeIn(30)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.MesMake_2(0, "お洒落")
	helper_d1353c5b(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1000.
script[1000] = function()
	local sp: number = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_220f0(sp + 0)
		end
	end
	helper_21b24(sp + 0)
	if vm.skipping() then
		return skip(1)
	end
	helper_220f0(sp + 0)
	if vm.skipping() then
		return skip(2)
	end
end

return script
