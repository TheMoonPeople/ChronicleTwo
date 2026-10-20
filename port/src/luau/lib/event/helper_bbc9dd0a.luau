--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_bbc9dd0a()
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

return helper_bbc9dd0a
