--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_d0179d58(arg0: s32, arg1: s32)
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

return helper_d0179d58
