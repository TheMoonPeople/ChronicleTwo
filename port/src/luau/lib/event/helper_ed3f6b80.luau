--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_12ac1c2b = require("@lib/event/helper_12ac1c2b")
local helper_29ffefe6 = require("@lib/event/helper_29ffefe6")
local helper_fb6fbabc = require("@lib/event/helper_fb6fbabc")

--- Helper function.
local function helper_ed3f6b80(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_fb6fbabc(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_fb6fbabc(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_fb6fbabc(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_12ac1c2b()
		end
	end
	event.SetMesPreset(0, 0)
	helper_29ffefe6(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(12) or var2
	if var2 < 3 then
		event.MesMake_2(
			0,
			"まだ、支度が\n出来てないんだよ。<page>もうちょっと\n待っておくれ。"
		)
		helper_fb6fbabc(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "ところで、\nモートンのところへは\n行ってくれたのかい？")
		helper_fb6fbabc(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"なんだって！モートンの奴、\n勝手なことばっかり言って。<page>もう、いいわ、\nそのパンは全部あげる。"
	)
	helper_fb6fbabc(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"そんなことより、ユリス、\n出発しましょう。<page>さぁ、どこへだって\nついて行きますよ。"
	)
	helper_fb6fbabc(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SubItem(300, 20)
	event.AddItem(299, 20)
	helper_12ac1c2b()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 8, 1)
end

return helper_ed3f6b80
