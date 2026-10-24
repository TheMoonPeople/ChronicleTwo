--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_5a511e14 = require("@lib/event/helper_5a511e14")
local helper_6982de90 = require("@lib/event/helper_6982de90")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_434d8c41(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	do
		local out1, out2, out3, out4 = event.Stopwatch_5(1)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
		var5 = out4 or var5
	end
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var6 = event.GetCnt(7) or var6
	if var6 == 0 then
		event.MesMake_2(0, "Hey there, Max.\nYou come to try again?")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		helper_5a511e14(arg0, arg1)
		return
	end
	if var6 == 1 then
		event.MesMake_2(0, "Oy! You didn't get to the boat,\ndid you? You tried to trick me.\nDon't cheat!")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(0, "Giving it another try?")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		helper_5a511e14(arg0, arg1)
		return
	end
	if var2 < 0 then
		event.MesMake_2(0, "Hey, no cheating!")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(0, "Giving it another try?")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		helper_5a511e14(arg0, arg1)
		return
	end
	event.MesMake_2(0, "Oh, you're back!\nRight,<page>Let's check\nyour time!")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMesValue(0, 1, var2)
	event.SetMesValue(0, 2, var3)
	event.SetMesValue(0, 3, var4)
	if var5 == 0 then
		event.MesMake_2(0, "Oh Dear!\n[数値１] minutes [数値２].[数値３] seconds is\ntoo slow.")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(0, "Giving it another try?")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		helper_5a511e14(arg0, arg1)
		return
	end
	event.MesMake_2(0, "Oh!\n[数値１] minutes [数値２] seconds [数値３]\nisn't a bad time!")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "You're a lot faster than you look. Okay,\nlet's go and fight the bad guys together!")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	helper_6982de90()
	event.Finish()
	event.SetQuestEtc(1, 9, 1)
end

return helper_434d8c41
