--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_59a16271 = require("@lib/event/helper_59a16271")
local helper_907fd9a8 = require("@lib/event/helper_907fd9a8")
local helper_927b384d = require("@lib/event/helper_927b384d")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_cfca3481 = require("@lib/event/helper_cfca3481")

--- Helper function.
local function helper_1507cec2()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local flag_7: s32 = 0
	local flag_8: s32 = 0
	local flag_9: s32 = 0
	local player_chara_2: s32 = 0
	local var14: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	player_chara = event.GetControlChrid() or player_chara
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Hello there.\nGreat weather, isn't it.")
	var3 = 0
	if var2 == 400 then
		flag = event.GetFlag(640) or flag
		if flag == 0 then
			flag_2 = event.GetFlag(616) or flag_2
			if flag_2 == 0 then
				flag_3 = event.GetFlag(540) or flag_3
				if flag_3 == 0 then
					flag_4 = event.GetFlag(536) or flag_4
					if flag_4 == 0 then
						event.MesMake_2(
							0,
							"Gaspard's a formidable adversary. \nDon't let your guard down, even \nan instant.<page>I know you can defeat him.\nThe Atlamillia chose you for\na reason..."
						)
					else
						event.MesMake_2(
							0,
							"Right, Gaspard was unhappy too.<page>What on earth is Griffon up to,\nmessing with people from two eras..."
						)
					end
				else
					event.MesMake_2(
						0,
						"I'm sure that if anyone can \ndefeat Griffon, you guys can.<page>We're counting on you."
					)
				end
			else
				event.MesMake_2(
					0,
					"The Chrono Union...  So, the world\nis going to be saved by the wisdom\nof the ancients..."
				)
			end
		else
			event.MesMake_2(
				0,
				"So, this is it, eh. The blood of\nmany friends has been spilled in\nthe fight against Griffon...<page>You're our last hope! Max, Monica,\nI'm counting on you. You must \ndefeat Griffon!"
			)
		end
	end
	if var2 == 401 then
		flag_5 = event.GetFlag(640) or flag_5
		if flag_5 == 0 then
			flag_6 = event.GetFlag(616) or flag_6
			if flag_6 == 0 then
				flag_7 = event.GetFlag(540) or flag_7
				if flag_7 == 0 then
					flag_8 = event.GetFlag(536) or flag_8
					if flag_8 == 0 then
						flag_9 = event.GetFlag(520) or flag_9
						if flag_9 == 0 then
							event.MesMake_2(
								0,
								"Okay, first you've got to \ndestroy the Fire Squall.<page>If we don't do anything about\nthis fire raining down here, \nHeim Rada is done for."
							)
						else
							event.MesMake_2(
								0,
								"Okay, so that's what happened. I\nguess we should be glad the\nFiresquall is out of the way."
							)
							helper_927b384d(player_chara, var1, 0)
							helper_b5a98ffa(0, -1, var1, player_chara, 0)
							var3 = 1
							event.MesMake_2(
								0,
								"But I'm worried about your friend\nthat fell into the crater.<page>I guess all we can do now is\nrestore Heim Rada and make the\nWorkshop even better than before."
							)
						end
					else
						event.MesMake_2(
							0,
							"You defeated Gaspard!\nYou guys are simply amazing!<page>Now for his boss, Emperor Griffon.\nSettle this once and for all!"
						)
					end
				else
					event.MesMake_2(
						0,
						"I was so happy to see Paznos in action,\ntears ran down my cheeks.<page>Everything we worked so hard\nfor has finally paid off."
					)
				end
			else
				event.MesMake_2(0, "Gem? Hmm, sorry but, I really\nhave no idea about that stuff.")
			end
		else
			event.MesMake_2(0, "Time to finally face Griffon, eh?\nGood luck. Go get him!")
		end
	end
	if var2 == 402 then
		event.MesMake_2(0, "Hey there! We got lotsa good stuff\nfor you! So what can I get ya?")
	end
	if var2 == 403 then
		event.MesMake_2(0, "You name it, I got it. Any part\nyou need, I'm your man.")
	end
	if var2 == 404 then
		event.MesMake_2(
			0,
			"Combat can get pretty deep. You\ncan't just run into every \nsituation guns blazing.<page>If you wanna be cool, you gotta use\nitems too. Find your enemy's\nweakness and exploit it."
		)
	end
	if var2 == 405 then
		event.MesMake_2(
			0,
			"There's nothing we can't make here\nat Gundorada Workshop. No matter\nhow big or small, we can do it."
		)
	end
	if var2 == 406 then
		event.MesMake_2(
			0,
			"Hey, how'd you guys get in here?\nBetter watch yourself in here. It\ncan get pretty dangerous."
		)
	end
	if var2 == 407 then
		event.MesMake_2(0, "What's been going on this whole\ntime? I just can't seem to \nremember, you know.")
	end
	if var2 == 408 then
		event.MesMake_2(0, "So, we all got erased by Griffon, huh?\nWhat a terrible monster he must be.")
	end
	if var2 == 409 then
		event.MesMake_2(0, "I'm a little busy right now.\nPlease stay out of the way.")
	end
	if var2 == 410 then
		event.MesMake_2(0, "We're all rooting for you too.\nWe're behind you 100%.")
	end
	if var2 == 411 then
		event.MesMake_2(
			0,
			"Seems the weapons\nin this case\naren't for sale.<page>There really are some\nweird and wonderful weapons\nin the world, though..."
		)
	end
	if var2 == 412 then
		event.MesMake_2(
			0,
			"So that guy Gaspard can\nunleash the Fire Squall?<page>He's not just sly...\nHe's truly evil."
		)
	end
	if var2 == 413 then
		event.MesMake_2(0, "What's with the heart\non that sign...<page>That's pretty nasty,\nif you ask me...")
	end
	if var3 == 0 then
		helper_907fd9a8(var1, -1, 0, 0)
	end
	if var3 == 1 then
		helper_b5a98ffa(0, -1, var1, player_chara, 0)
		event.SetMotion(var1, "立ち")
		event.Finish()
	end
	if var3 == 2 then
		event.SetCameraPos(1.39, 51.09, 278.55)
		event.SetCameraRef(-54.8, 23.29, 223.57)
		player_chara_2 = event.GetControlChrid() or player_chara_2
		do
			local out1, _, out3 = event.GetCharaPos(player_chara_2)
			var14 = out1 or var14
			var16 = out3 or var16
		end
		do
			local out1, _, out3 = event.GetCharaPos(var1)
			var17 = out1 or var17
			var19 = out3 or var19
		end
		var20 = event.GetRotLookPos(var17 - var14, var19 - var16) or var20
		helper_cfca3481(player_chara_2, var20)
		event.SetCharaRot(player_chara_2, 0.0, var20, 0.0)
		event.SetMotion(player_chara_2, "立ち")
		helper_b5a98ffa(0, -1, var1, player_chara_2, 0)
		event.ResetCamera(1, 3.1415927)
	end
	event.SetAi(1, var1)
	if var2 == 402 then
		helper_59a16271(30)
	end
	if var2 == 403 then
		helper_59a16271(28)
	end
	if var2 == 404 then
		helper_59a16271(29)
	end
end

return helper_1507cec2
