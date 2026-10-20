--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06ed6d94 = require("@lib/event/helper_06ed6d94")
local helper_1b7ab804 = require("@lib/event/helper_1b7ab804")
local helper_6c76a9f4 = require("@lib/event/helper_6c76a9f4")
local helper_dbd14b96 = require("@lib/event/helper_dbd14b96")

--- Helper function.
local function helper_32c6d3c9(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_dbd14b96(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_dbd14b96(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_dbd14b96(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_dbd14b96(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_dbd14b96(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_6c76a9f4(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_6c76a9f4(0, -1, 8, 0, 0)
		end
		if at <= 9 then
			helper_6c76a9f4(0, -1, 8, 0, 0)
		end
		if at <= 10 then
			helper_6c76a9f4(0, -1, 8, 0, 0)
		end
		if at <= 11 then
			helper_6c76a9f4(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1b7ab804(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_06ed6d94(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"あっ、ユリス坊ちゃん。\n最近、出歩かれることが多いようですが、\nくれぐれも気をつけてくださいよ。<page>それで、アッシに何かご用で？"
	)
	helper_dbd14b96(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "何と！アッシに坊ちゃんの\n冒険について来いと？")
	helper_dbd14b96(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"う～む、いっしょに行きたいところなのですが、\nこいつが病気にかかっているようなんです。"
	)
	helper_dbd14b96(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"アッシの第一の仕事は、この屋敷の\n木や花たちのお世話をすること。<page>それをほったらかしにして留守になどしたら\nダンナ様に怒られてしまいます。"
	)
	helper_dbd14b96(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"教会のブルーノさんが売っている「聖水」なら、\nこの木の病気を治せると思うんですけどね。<page>ダンナ様とブルーノ神父は、坊ちゃんも\n知ってのとおり犬猿の仲。<page>ブルーノさんの聖水を買うと言っても、\nお金はもらえませんし。<page>どうしたものでしょう・・・。"
	)
	helper_dbd14b96(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]グリンをシャーロットに移住させるためには、\n   まず、グリンを冒険に連れ出さねばなりません。"
	)
	helper_6c76a9f4(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]グリンの頼みごとを聞いて、解決してあげることで、\n   グリンを冒険の仲間として、列車に乗せることができます。"
	)
	helper_6c76a9f4(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"[(!)]頼まれごと（クエスト）は、アイテムメニュー内にある\n   「メモ帳」で確認することができます。"
	)
	helper_6c76a9f4(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	argc = event.GetItemHaveNum(386) or argc
	if argc <= 0 then
		event.MesMake_2(
			0,
			"[(!)]おや、メモ帳を持っていないようですね。\n   メモ帳は、メンテナンスショップ奥の\n   テーブルの上に置いてあります。"
		)
		helper_6c76a9f4(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.MesMake_2(
			0,
			"[(!)]ドニーのアジトにも同じような物が\n   落ちています。どちらでも良いので、\n   急いで取りに行きましょう。"
		)
		helper_6c76a9f4(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(12)
		end
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 0, 1)
end

return helper_32c6d3c9
