--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_48a5daee = require("@lib/event/helper_48a5daee")
local helper_4eedff96 = require("@lib/event/helper_4eedff96")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_b8f871c8 = require("@lib/event/helper_b8f871c8")

--- Helper function.
local function helper_a69fa4ed(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
		if at <= 9 then
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
		if at <= 10 then
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
		if at <= 11 then
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_48a5daee(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_4eedff96(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Oh, Max! You've been moping about\na lot lately. Are you taking care\nof yourself?<page>Something I can do for you?"
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "What! You want me to go with you\non your adventure?")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Hmm... I'd like to go with you...\nBut this poor tree isn't doing\nso well.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Taking care of the trees and the\nflowers on this property is my\nnumber one priority, you know.<page>If I go off roaming about, I could\nlose my job."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"I bet some of the Holy Water that Priest Bruno\nsells at the church would fix this tree!<page>But, as you know, your father\nand Priest Bruno are on bad terms...<page>Your father'd never give me money to buy\nHoly Water from Priest Bruno!<page>I'm in a pickle."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "[(!)]To get Gordon to Sindain, first you\n   have to get him to join you on\n   your journey.")
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]If you fulfill Gordon's quest,\n   he'll join you on your journey and\n   get on the train."
	)
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(0, "[(!)]You can check out your quests\n   by reading your Notebook,\n   located on the Item Menu.")
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	argc = event.GetItemHaveNum(386) or argc
	if argc <= 0 then
		event.MesMake_2(
			0,
			"[(!)]Oh, you don't have a Notebook.\n   There's one on the table\n   inside the Maintenance Shop."
		)
		helper_b8f871c8(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.MesMake_2(
			0,
			"[(!)]There's another one in\n   Donny's hideout. Either will do.\n   Just get hold of one quick!"
		)
		helper_b8f871c8(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(12)
		end
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 0, 1)
end

return helper_a69fa4ed
