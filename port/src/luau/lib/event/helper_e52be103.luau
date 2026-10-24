--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_29ffefe6 = require("@lib/event/helper_29ffefe6")
local helper_fb6fbabc = require("@lib/event/helper_fb6fbabc")
local helper_fd6374b2 = require("@lib/event/helper_fd6374b2")

--- Helper function.
local function helper_e52be103(arg0: s32, arg1: s32)
	local flag: s32 = 0
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
			helper_fd6374b2()
		end
	end
	event.SetMesPreset(0, 0)
	helper_29ffefe6(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(41) or flag
	if flag == 0 then
		event.MesMake_2(0, "魚は飼い主に似ると言います。")
		helper_fb6fbabc(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "あんな弱っちい魚の飼い主と\n話す事なんて、ありません。")
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
		"こっそり見てましたよ。\nすばらしいレースでしたね。<page>あそこまで魚を育て上げるなんて、\n私には出来そうもありません。<page>いっしょに連れて行ってください。\nそして、勉強させてください。"
	)
	helper_fb6fbabc(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_fd6374b2()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 16, 1)
end

return helper_e52be103
