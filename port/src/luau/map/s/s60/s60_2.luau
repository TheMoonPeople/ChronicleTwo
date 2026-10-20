--!strict
-- map/s/s60/s60_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_9336672d = require("@lib/event/helper_9336672d")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")
local helper_e20fd550 = require("@lib/event/helper_e20fd550")

--- Helper function.
local function helper_d3b0()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_e20fd550(8240090, 360)
			end
			if at <= 2 then
				helper_e20fd550(8240110, 420)
			end
			if vm.skip_end() then
				return skip(4)
			end
			return part2()
		end
		var1 = 0
		var1 = var1 + 1
	end
	function part2()
		event.CancelDramaScene()
		event.SetStatus(1, 0, 256, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		var1 = 0
		while var1 < 100 do
			event.DeleteChara(12 + var1)
			var1 = var1 + 1
		end
		event.LoadMes(0, -1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(824, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e800/e824/")
	event.LoadMes(0, 5, "e824.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e824_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e824_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e824_need.gltf", "info", 10)
	event.SetStatus(1, 10, 8, 1)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e824_hanabi.gltf", "info", 11)
	event.CharaActive(11)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e800/e824/e824_mints.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 8)
		event.EohSyncChara(0, 8)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
		event.LoadEquip(5, 1, 4, "info", 8)
		event.LoadEquip(5, 1, 3, "info", 8)
		event.LoadEquip(5, 1, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e800/e824/e824_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.SetCharaShow(3, 0)
	event.EohSetPos(0, 72.11, -90.0, 76.71)
	event.EohSetRot(0, 0.0, -3.02, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, 54.92, -90.0, 77.88)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetPos(2, 44.14, -49.08, -126.86)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "しんけん顔")
	event.EohSetTexAnim(2, 1, "しんけん目パチ")
	event.InitDramaScene()
	event.SetStatus(1, 0, 8, 0)
	event.SetStatus(1, 8, 8, 0)
	event.SetMapDraw(1)
	event.CmrsInit()
	event.CmrsSetPos(55.46, 200.34, 515.95)
	event.CmrsSetRef(53.44, 227.2, 372.83)
	event.SetFadeIn(0)
	event.SetMapDraw(1)
	event.CmrsSetPos(44.0, -16.0, -75.76)
	event.CmrsSetRef(44.0, -29.0, -122.08)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.ObjsTexAnime(2, 1, "通常口パク")
	event.ObjsTexaDelay(2, 300)
	event.ObjsTexAnime(2, 0, "通常口パク")
	event.ObjsSetMotion(2, "いつか世界に・・・", 4)
	event.ObjsMotionDelay(2, 60)
	event.ObjsNextMotion(2, "いつか世界に・・・Ｌ", 4)
	helper_e20fd550(8240090, 360)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(44.2, -3.01, -177.99)
	event.CmrsSetRef(35.75, -20.84, -125.36)
	event.CmrsMove(44.2, -3.01, -177.99, 52.28, -20.84, -125.25, 420)
	event.SetMapDraw(0)
	event.ObjsTexAnime(2, 1, "通常口パク")
	event.ObjsTexaDelay(2, 336.0)
	event.ObjsTexAnime(2, 0, "通常口パク")
	event.ObjsSetMotion(2, "なぜなら１", 2)
	event.ObjsNextMotion(2, "なぜなら１Ｌ", 4)
	event.ObjsNextMotion(2, "なぜならＬ～なぜなら２", 4)
	event.ObjsNextMotion(2, "なぜなら２Ｌ", 4)
	event.ObjsNextMotion(2, "なぜなら２～なぜなら１", 4)
	event.ObjsNextMotion(2, "なぜなら１Ｌ", 4)
	event.ObjsNextMotion(2, "なぜならＬ～なぜなら２", 4)
	event.ObjsNextMotion(2, "なぜなら２Ｌ", 4)
	helper_e20fd550(8240110, 420)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMapDraw(1)
	return part2()
end

--- Helper function.
local function helper_be7c()
	local block: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_b0211f82(90)
		end
		if at <= 3 then
			local _ = helper_9336672d(0)
		end
		if at <= 4 then
			helper_b0211f82(30)
		end
	end
	event.SetFadeOut(0)
	event.SoundAllStop()
	helper_b0211f82(6)
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeIn(0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetMovieCc(0, 0)
	event.SetMovieCc(1, 0, 300, "Hourra, hourra !!!", 150)
	event.SetMovieCc(1, 1, 600, "Bravo bravo !!! Hourra !!!", 150)
	event.SetMovieCc(1, 2, 900, "Mes amis, mes amis...", 150)
	event.SetMovieCc(1, 3, 1200, "Hourra, hourra !!! ", 150)
	event.SetMovieCc(
		1,
		4,
		1500,
		"Aujourd'hui, le train Noirpierre va partir pour un \nnouveau voyage dans toute notre r[UNI00e9]gion.",
		150
	)
	event.SetMovieCc(
		1,
		5,
		1800,
		"J'esp[UNI011d]re que le monde va suivre cet exemple et\nrecommencer [UNI0155] se d[UNI00e9]velopper.",
		150
	)
	event.SetMovieCc(1, 6, 2100, "Eh bien, le maire a retrouv[UNI00e9] de l'aplomb.", 150)
	event.SetMovieCc(1, 7, 2400, "Oui, c'est vrai.", 150)
	event.SetMovieCc(
		1,
		8,
		2700,
		"Nous serons s[UNI0171]rement confront[UNI00e9]s [UNI0155] des difficult[UNI00e9]s,\nmais je suis certain qu'en travaillant ensemble,\nnous les r[UNI00e9]glerons sans probl[UNI011d]me !",
		150
	)
	event.SetMovieCc(1, 9, 3000, "Trois fois hourra !!! Bravo !!!", 150)
	event.SetMovieCc(
		1,
		10,
		3300,
		"Vous, habitants de Palm Brinks, vous avez surmont[UNI00e9] tant\nde temp[UNI0129]tes et su faire face [UNI0155] l'adversit[UNI00e9]...\nCette victoire est enti[UNI011d]rement la v[UNI00f4]tre !!!",
		150
	)
	event.SetMovieCc(1, 11, 3600, "Hourra pour Palm Brinks !!! Hourra !!!", 150)
	event.SetMovieCc(
		1,
		12,
		3900,
		"Il fut un temps o[UNI017f] notre monde [UNI00e9]tait plong[UNI00e9] dans les t[UNI00e9]n[UNI011d]bres.",
		150
	)
	event.SetMovieCc(
		1,
		13,
		4200,
		"Les hommes de cette [UNI00e9]poque ont r[UNI00e9]sist[UNI00e9] et ont reconquis leur avenir.",
		150
	)
	event.SetMovieCc(
		1,
		14,
		4500,
		"Mais le r[UNI00e9]cit de leur combat n'a jamais pu [UNI0129]tre transmis\naux g[UNI00e9]n[UNI00e9]rations futures.",
		150
	)
	event.SetMovieCc(
		1,
		15,
		4800,
		"Cette [UNI00e9]tonnante aventure [UNI00e9]tait-elle r[UNI00e9]elle ou non ?\nPersonne ne le sait.",
		150
	)
	event.SetMovieCc(
		1,
		16,
		5100,
		"Mais...\nQuand vous vous prom[UNI011d]nerez la nuit, parlez-en [UNI0155] la lune...\nIl est bien possible qu'elle vous raconte notre [UNI00e9]trange histoire.",
		150
	)
	event.SetMovieCc(0, 1)
	event.LoadMovie(5, "movie/end2.mp4")
	if vm.wait() then
		return skip(2)
	end
	event.SetMovieCc(0, 0)
	block = event.LoadImg_4(5, "textures/event/e700/e736/e73601.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetColor(0, 0, 0, 0, 128)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 1)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e73601", block)
	event.SpriteSetColor(1, 128, 128, 128, 128)
	event.SpriteSetUvsize(1, 0, 0, 512, 448)
	event.SpriteSetPutsize(1, 512, 448)
	event.SpriteSetPos(1, 256, 224)
	event.SpriteSetDraw(1, 1)
	event.SetFadeIn(60)
	helper_b0211f82(90)
	if vm.skipping() then
		return skip(3)
	end
	while true do
		if helper_9336672d(0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(4)
			end
		end
	end
	event.SetFadeOut(30)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(5)
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
-- Defined empty, so the engine runs this instead of its default.
script[99] = function() end

--- Program 100.
-- Defined empty, so the engine runs this instead of its default.
script[100] = function() end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_d3b0()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	event.SetTime(22.0)
	event.SetTimeStepEnable(0)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_d3b0()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_be7c()
	if vm.skipping() then
		return skip(1)
	end
	event.SetExitFlag(1)
end

return script
