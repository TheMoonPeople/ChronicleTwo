--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_59a16271 = require("@lib/event/helper_59a16271")
local helper_907fd9a8 = require("@lib/event/helper_907fd9a8")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_cfca3481 = require("@lib/event/helper_cfca3481")

--- Helper function.
local function helper_094dedcf()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local player_chara_2: s32 = 0
	local var10: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
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
	flag = event.GetFlag(324) or flag
	flag_2 = event.GetFlag(330) or flag_2
	flag_3 = event.GetFlag(372) or flag_3
	flag_4 = event.GetFlag(400) or flag_4
	flag_5 = event.GetFlag(640) or flag_5
	if var2 == 200 then
		if flag_5 == 0 then
			if flag_2 == 0 then
				if flag == 0 then
					event.MesMake_2(
						0,
						"To make the miracle dish、I need\na White Windflower.　But I'm all\nout. Sorry I can't help you now."
					)
				else
					event.MesMake_2(
						0,
						"Have you already tried the\nMiracle Dumpling? They lose effect\nas they cool, so eat 'em quick."
					)
				end
			else
				event.MesMake_2(
					0,
					"The Miracle Dumpling helped, eh?\nGlad to hear it. Hey, do you want\nsomething to eat before you go?"
				)
			end
		else
			event.MesMake_2(0, "Oh my, it's just about time, eh?\nWell, here goes nothing, eh?")
		end
	end
	if var2 == 201 then
		event.MesMake_2(
			0,
			"Different items have different\neffects. Some can help you. Others\nchange to form weapons...<page>If you try experimenting, you'll\nbe able to beat even the toughest\nof enemies. Try everything you can."
		)
	end
	if var2 == 202 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"I just can't believe this temple\ngot wiped out by that diabolical \nEmperor Griffon...<page>If only the Great Sage Crest\nwere here..."
			)
		else
			event.MesMake_2(
				0,
				"With the Great Crest with us once\nagain, there will be nothing to\nfear. Now go, and face Griffon."
			)
		end
	end
	if var2 == 203 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"This Temple exists in an endless\nnight because the Moon Crystal's\npower is strongest at night.<page>It's utilizing the force of the\ntemple to create an area of night."
			)
		else
			event.MesMake_2(
				0,
				"May Crest the Great use the power\nof the Moon Crystal to see all\nthat is of this world. <page>There is no escaping the all-\nseeing eyes of Crest."
			)
		end
	end
	if var2 == 204 then
		event.MesMake_2(
			0,
			"Howdy. We got a great selection for\nyou. Our weapons are known for\nbeing strong and sturdy."
		)
	end
	if var2 == 205 then
		if flag_5 == 0 then
			if flag_4 == 0 then
				event.MesMake_2(0, "Hey! Quit dilly-dallying and show\nthat Griffon who's boss!\nHurry!")
			else
				event.MesMake_2(
					0,
					"Well, this is the end of the line\nfor me. The rest is up to you. Go\ntake care of that Griffon, ya hear.<page>You saved my life. I know if anyone\ncan do the job, it's you guys."
				)
			end
		else
			event.MesMake_2(
				0,
				"Looks like your journey has almost\nreached its end. Get that Griffon,\nfor Master, and for us all.<page>You must defeat him no matter what.\nWhen Griffon falls... Crest and\nI... can truly become Great Sages."
			)
		end
	end
	if var2 == 206 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Even with the temple back to\nnormal, without Crest, Starlight\nTemple is useless. <page>No one but Crest has the immense\nastrological power to survey\nthe whole world."
			)
		else
			event.MesMake_2(
				0,
				"Even the Great Crest was once the\napprentice of a sage. He must have\nbeen an amazing teacher..."
			)
		end
	end
	if var2 == 207 then
		if flag == 0 then
			event.MesMake_2(0, "The food here is first class.\nMakes my mouth water just\nthinking about it.")
		else
			event.MesMake_2(0, "He made his miracle dish!\nLao Chao really is a great chef!")
		end
	end
	if var2 == 208 then
		if flag == 0 then
			event.MesMake_2(0, "Once you've dined here,\nnothing else will ever taste\nas good. This is so good.")
		else
			event.MesMake_2(0, "Wow! I'd sure like to\ntry some of those\nMiracle Dumplings too!")
		end
	end
	if var2 == 209 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"You think the Starglass\nis pretty weird?<page>You're telling me! I've got one as\nwell, but I don't think much of it...\nCertainly never turned back time."
			)
		else
			event.MesMake_2(
				0,
				"That's great that you guys were\nfriends with Crest the Great Sage.<page>But I didn't realize\nyou were so incredibly close..."
			)
		end
	end
	if var2 == 210 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"The Great Sage Crest isn't here.\nI wonder where he's gone...<page>We can't help but feel uneasy\nwith him not around."
			)
		else
			event.MesMake_2(
				0,
				"The Great Crest once told me... \nIn ages past, a man called Gaspard\ntried to destroy this Moon Crystal.<page>And it was the Great Crest's master\nthat risked his life to protect it..."
			)
		end
	end
	if var2 == 211 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"The Great Crest has disappeared\nwith the Moon Crystal,\nin order to protect it...?<page>I don't understand..."
			)
		else
			event.MesMake_2(
				0,
				"You've witnessed the massive power\nof the Moon Crystal, right? But\n there is only one who can use it...<page>Crest the Great Sage...<page>There's no way normal people like\nus could ever do anything like\nthat."
			)
		end
	end
	if var2 == 212 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Could you be the ones...? The Great\nCrest told me that one day\na boy and girl would come to me...<page>I just knew this prophecy would\ncome to pass!<page>But unfortunately the Great Sage\nhas disappeared as well."
			)
		else
			event.MesMake_2(
				0,
				"10,000 years ago?<page>You're telling me the Luna Lab can\naccomplish such a feat that even\nthe Great Crest was incapable of?"
			)
		end
	end
	if var2 == 213 then
		event.MesMake_2(
			0,
			"The moon has a strange power\nthat affects all sorts of\nliving things.<page> And it is the Moon Crystal\nthat embodies that power."
		)
	end
	if var2 == 214 then
		if flag_2 == 0 then
			event.MesMake_2(
				0,
				"If you are looking for the\nworld's best food, you should\nvisit Lao Chao's Bistro!<page>You have heard of it, right?"
			)
		else
			event.MesMake_2(
				0,
				"So you're the ones. The Great Crest\ntold me about you, and about how a\nlong time ago you saved her life.<page>But, I never would've imagined\nyou were just kids..."
			)
		end
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
			var10 = out1 or var10
			var12 = out3 or var12
		end
		do
			local out1, _, out3 = event.GetCharaPos(var1)
			var13 = out1 or var13
			var15 = out3 or var15
		end
		var16 = event.GetRotLookPos(var13 - var10, var15 - var12) or var16
		helper_cfca3481(player_chara_2, var16)
		event.SetCharaRot(player_chara_2, 0.0, var16, 0.0)
		event.SetMotion(player_chara_2, "立ち")
		helper_b5a98ffa(0, -1, var1, player_chara_2, 0)
		event.ResetCamera(1, 3.1415927)
	end
	event.SetAi(1, var1)
	if var2 == 201 then
		helper_59a16271(5)
	end
	if var2 == 204 then
		helper_59a16271(27)
	end
end

return helper_094dedcf
