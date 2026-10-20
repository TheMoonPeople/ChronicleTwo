--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4eedff96 = require("@lib/event/helper_4eedff96")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_b8f871c8 = require("@lib/event/helper_b8f871c8")

--- Helper function.
local function helper_d02ffa17(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_635ee3fd(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_635ee3fd(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_635ee3fd(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_635ee3fd(0, -1, arg1, arg0, 0)
			end
			if at <= 5 then
				helper_b8f871c8(0, -1, 8, 0, 0)
			end
			return
		end
		if at <= 7 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_635ee3fd(0, -1, arg1, arg0, 0)
		end
		if at <= 10 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 11 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 12 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 13 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 14 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 16 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMesPreset(0, 0)
		helper_4eedff96(arg0, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		event.MesMake_2(0, "Hi there.\nIt's Monica, right?")
		helper_635ee3fd(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "I'm Parn.\nI'm a magical artist.")
		helper_635ee3fd(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "I haven't introduced you yet, have I?<page>This is Julia, my wife-to-be.")
		helper_635ee3fd(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.MesMake_2(0, "...")
		helper_635ee3fd(0, -1, arg1, arg0, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.MesMake_2(
			0,
			"[(!)] Monica's not very good in this kind of \n   situation. She might get somewhere, but\n   probably not. Better try again as Max."
		)
		helper_b8f871c8(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetMesPreset(0, 0)
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	helper_4eedff96(arg0, 0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(0, "Hey Max.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "I haven't introduced you yet, have I?<page>This is Julia, my wife-to-be.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(0, "...")
	helper_635ee3fd(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(0, "Yeah, you can laugh.\nI know it's strange!<page>Who'd fall in love with\na girl in a picture?")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(
		0,
		"But I'm a magical artist.\nI have the power to make the things I draw real.<page>Whatever I draw really does exist in the picture.\nAs long as it's not a living thing..."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.MesMake_2(0, "Even a magical artist can't draw life.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(13)
	end
	event.MesMake_2(0, "But, I've heard of a way.\nThere's a Golden Egg in a big, old tree.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "It's said that with its golden colour,\nyou can give life to anything you draw.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.MesMake_2(
		0,
		"Max, you're going out of\ntown, right?<page>I wonder if you could get hold of some Golden Paint?"
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.MesMake_2(
		0,
		"Of course I don't expect you to do it for nothing.<page>If you can help me, I'll use\nmy new power to help you in return."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]A big, old tree...\n   With  a Golden Egg! Where on earth\n   would you find a tree like that?!"
	)
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(18)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 1, 1)
end

return helper_d02ffa17
