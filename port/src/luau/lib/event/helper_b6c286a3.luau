--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06ed6d94 = require("@lib/event/helper_06ed6d94")
local helper_7408556b = require("@lib/event/helper_7408556b")
local helper_dbd14b96 = require("@lib/event/helper_dbd14b96")
local helper_f3577a67 = require("@lib/event/helper_f3577a67")

--- Helper function.
local function helper_b6c286a3(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local var5: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_06ed6d94(arg0, 0, 0)
			end
			if at <= 2 then
				helper_dbd14b96(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			if at <= 4 then
				helper_dbd14b96(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			helper_f3577a67(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_06ed6d94(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	argc = event.GetItemNum(214) or argc
	argc_2 = event.GetItemNum(245) or argc_2
	argc_3 = event.GetItemNum(227) or argc_3
	if argc <= 0 or argc_2 <= 0 or argc_3 <= 0 then
		event.MesMake_2(
			0,
			"材料がないと服は作れません。<page>『ぶあつい皮』『銅のかたまり』\nそれと『意外と丈夫な布』です。<page>甘えるようですが、\nお願いします。"
		)
		helper_dbd14b96(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "これで服を作ってみなよ！\nやっぱり、もったいないや")
	var5 = helper_7408556b(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var5 ~= 0 then
		event.MesMake_2(0, "材料がないと服は作れません。")
		helper_dbd14b96(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(214)
	event.SubItem(245)
	event.SubItem(227)
	event.SetCnt(8, 2)
	event.MesMake_2(
		0,
		"ありがとうございます！\nこれで服を作ってみます。<page>坊ちゃんのお気持ち、\n決してむだにはしません。"
	)
	helper_dbd14b96(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetFadeOut(30)
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(7)
	end
	event.SetAi(1, arg0)
	event.CharaActive(0, arg0)
	event.DeleteVillager(arg0)
	event.Finish()
	event.SetFadeIn(30)
end

return helper_b6c286a3
