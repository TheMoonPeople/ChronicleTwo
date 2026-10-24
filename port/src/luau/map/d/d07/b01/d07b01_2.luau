--!strict
-- map/d/d07/b01/d07b01_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_11cd726a = require("@lib/event/helper_11cd726a")
local helper_21ceb188 = require("@lib/event/helper_21ceb188")
local helper_29dc3834 = require("@lib/event/helper_29dc3834")
local helper_2f95e1a8 = require("@lib/event/helper_2f95e1a8")
local helper_74ae835d = require("@lib/event/helper_74ae835d")
local helper_7a92069b = require("@lib/event/helper_7a92069b")
local helper_9289be63 = require("@lib/event/helper_9289be63")
local helper_97678a64 = require("@lib/event/helper_97678a64")
local helper_a0e17f3c = require("@lib/event/helper_a0e17f3c")
local helper_a217b2b5 = require("@lib/event/helper_a217b2b5")
local helper_b0ccfec7 = require("@lib/event/helper_b0ccfec7")
local helper_ec8c350b = require("@lib/event/helper_ec8c350b")

--- Program 99.
local function program_99()
	local flag: s32 = 0
	event.StopBgm(0)
	event.LoadSound(8693)
	flag = event.GetFlag(820) or flag
	if flag == 1 then
		event.EohSyncObj(0, "p04")
		event.EohSetShow(0, 0)
		event.FuncPointShow("p04", "func", 0)
	end
end

--- Program 28020.
local function program_28020()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_97678a64(vm.f32(438.61), 0.0, vm.f32(192.19), vm.f32(-1.89))
		end
	end
	event.Initialize()
	event.SetFadeOut(0)
	event.EohSyncObj(0, "p06")
	event.EohSetShow(0, 1)
	event.StopBgm(0)
	helper_a0e17f3c(6)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(40)
	event.PlayBgm(0)
	event.LoadMonsterFile(629, 1)
	event.LoadMonsterFile(630, 0)
	event.AutoSetMonster(629, -513.2, 9.0, -127.2, 0.0, 1.25, 0.0)
	helper_97678a64(vm.f32(438.61), 0.0, vm.f32(192.19), vm.f32(-1.89))
	event.SetCameraRef(438.61, 30.0, 192.19)
	event.SetCameraPos(590.29, 39.11, 243.1)
	event.ResetCamera(0)
	event.SetFadeIn(30)
	if vm.wait() then
		return skip(2)
	end
	event.Finish()
end

--- Helper function.
local function helper_17358()
	local language_code: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a0e17f3c(6)
		end
		if at <= 2 then
			print("GET_LANGUAGE=", language_code, "\n")
		end
		if at <= 3 then
			helper_a0e17f3c(90)
		end
		if at <= 4 then
			local _ = helper_ec8c350b(0)
		end
		if at <= 5 then
			helper_a0e17f3c(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(0)
	event.SoundAllStop()
	helper_a0e17f3c(6)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeIn(0)
	event.AssignStack(5)
	event.ClearStack(5)
	language_code = event.GetLanguage() or language_code
	print("GET_LANGUAGE=", language_code, "\n")
	if language_code ~= 1 then
		event.SetMovieCc(0, 0)
		event.SetMovieCc(1, 2, vm.ftoi(vm.f32(109.8)), "Mes amis, mes amis...", vm.ftoi(vm.f32(50.7)))
		event.SetMovieCc(
			1,
			4,
			vm.ftoi(vm.f32(241.80002)),
			"Aujourd'hui, le train Noirpierre va partir pour un \nnouveau voyage dans toute notre r[UNI00e9]gion.",
			vm.ftoi(vm.f32(160.20001))
		)
		event.SetMovieCc(
			1,
			5,
			vm.ftoi(vm.f32(555.9)),
			"J'esp[UNI011d]re que le monde va suivre cet exemple et\nrecommencer [UNI0155] se d[UNI00e9]velopper.",
			vm.ftoi(vm.f32(143.40001))
		)
		event.SetMovieCc(
			1,
			6,
			vm.ftoi(vm.f32(788.4)),
			"Eh bien, le maire a retrouv[UNI00e9] de l'aplomb.",
			vm.ftoi(vm.f32(99.299995))
		)
		event.SetMovieCc(1, 7, vm.ftoi(vm.f32(897.3)), "Oui, c'est vrai.", vm.ftoi(vm.f32(33.6)))
		event.SetMovieCc(
			1,
			8,
			vm.ftoi(937.5),
			"Nous serons s[UNI0171]rement confront[UNI00e9]s [UNI0155] des difficult[UNI00e9]s,\nmais je suis certain qu'en travaillant ensemble,\nnous les r[UNI00e9]glerons sans probl[UNI011d]me !",
			vm.ftoi(vm.f32(234.6))
		)
		event.SetMovieCc(
			1,
			10,
			vm.ftoi(1294.5),
			"Vous, habitants de Palm Brinks, vous avez surmont[UNI00e9] tant\nde temp[UNI0129]tes et su faire face [UNI0155] l'adversit[UNI00e9]...\nCette victoire est enti[UNI011d]rement la v[UNI00f4]tre !!!",
			vm.ftoi(vm.f32(311.1))
		)
		event.SetMovieCc(
			1,
			12,
			vm.ftoi(vm.f32(1611.6001)),
			"Il fut un temps o[UNI017f] notre monde [UNI00e9]tait plong[UNI00e9] dans les t[UNI00e9]n[UNI011d]bres.",
			vm.ftoi(vm.f32(96.6))
		)
		event.SetMovieCc(
			1,
			13,
			vm.ftoi(vm.f32(1820.7)),
			"Les hommes de cette [UNI00e9]poque ont r[UNI00e9]sist[UNI00e9] et ont reconquis leur avenir.",
			vm.ftoi(vm.f32(99.299995))
		)
		event.SetMovieCc(
			1,
			14,
			vm.ftoi(vm.f32(2121.6)),
			"Mais le r[UNI00e9]cit de leur combat n'a jamais pu [UNI0129]tre transmis\naux g[UNI00e9]n[UNI00e9]rations futures.",
			vm.ftoi(vm.f32(128.40001))
		)
		event.SetMovieCc(
			1,
			15,
			vm.ftoi(vm.f32(2328.6)),
			"Cette [UNI00e9]tonnante aventure [UNI00e9]tait-elle r[UNI00e9]elle ou non ?\nPersonne ne le sait.",
			vm.ftoi(vm.f32(209.09999))
		)
		event.SetMovieCc(
			1,
			16,
			vm.ftoi(vm.f32(2623.2002)),
			"Mais...\nQuand vous vous prom[UNI011d]nerez la nuit, parlez-en [UNI0155] la lune...\nIl est bien possible qu'elle vous raconte notre [UNI00e9]trange histoire.",
			vm.ftoi(vm.f32(242.70001))
		)
		event.SetMovieCc(0, 1)
	end
	event.LoadMovie(5, "movie/end2.mp4")
	if vm.wait() then
		return skip(3)
	end
	if language_code ~= 1 then
		event.SetMovieCc(0, 0)
	end
	event.PauseEnableFlag(0)
	block = event.LoadImg_4(5, "textures/event/e800/e824/e82401_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetColor(0, 0, 0, 0, 128)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 1)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e82401", block)
	event.SpriteSetColor(1, 128, 128, 128, 128)
	event.SpriteSetUvsize(1, 0, 0, 512, 448)
	event.SpriteSetPutsize(1, 512, 448)
	event.SpriteSetPos(1, 256, 224)
	event.SpriteSetDraw(1, 1)
	event.SetFadeIn(60)
	helper_a0e17f3c(90)
	if vm.skipping() then
		return skip(4)
	end
	while true do
		if helper_ec8c350b(0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(5)
			end
		end
	end
	event.SetFadeOut(30)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(6)
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	program_99()
	helper_97678a64(vm.f32(972.08), vm.f32(-72.14), vm.f32(1770.23), vm.f32(-2.36))
	event.SetCameraRef(972.08, -42.14, 1770.23)
	event.SetCameraPos(1061.01, -40.06, 1860.38)
	event.ResetCamera(0)
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	program_28020()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 152.
script[152] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_11cd726a(64)
		end
	end
	event.SetCameraRef(0.0, 0.0, 0.0)
	if vm.wait() then
		return skip(1)
	end
	helper_11cd726a(64)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 300.
script[300] = function()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_29dc3834(0, 21, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			helper_a0e17f3c(30)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_29dc3834(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_29dc3834(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return
	end
	var1 = helper_9289be63(2, -1)
	if vm.skipping() then
		return skip(3)
	end
	if var1 == 0 then
		event.SetFadeOut(30)
		helper_a0e17f3c(30)
		if vm.skipping() then
			return skip(4)
		end
		event.LoadScript("d07/d07.stb", 1000)
	else
		event.Finish()
	end
end

--- Program 500.
script[500] = function()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_29dc3834(0, 21, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			var1 = 2
			helper_a0e17f3c(6)
		end
		if at <= 5 then
			helper_a0e17f3c(20)
		end
		if at <= 6 then
			helper_b0ccfec7()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 8 then
			helper_97678a64(vm.f32(438.61), 0.0, vm.f32(192.19), vm.f32(-1.89))
			helper_2f95e1a8()
		end
		if at <= 9 then
			helper_a0e17f3c(6)
		end
	end
	function part2()
		event.DngPause(1, 0)
		event.Finish()
	end
	function landing1()
		if vm.wait() then
			return skip(8)
		end
		event.Initialize()
		event.EohSyncObj(0, "p05")
		event.EohSetShow(0, 1)
		event.EohSyncObj(1, "p06")
		event.EohSetShow(1, 1)
		event.SetBitCtrl(1, 1)
		event.LoadMonsterFile(629, 1)
		event.LoadMonsterFile(630, 0)
		event.AutoSetMonster(629, -513.2, 9.0, -127.2, 0.0, 1.25, 0.0)
		helper_97678a64(vm.f32(438.61), 0.0, vm.f32(192.19), vm.f32(-1.89))
		event.SetCameraRef(438.61, 30.0, 192.19)
		event.SetCameraPos(590.29, 39.11, 243.1)
		event.ResetCamera(0)
		event.SetFadeIn(30)
		event.Finish()
		event.SetStatusbarShow(1, 0.16666667)
		helper_a0e17f3c(6)
		if vm.skipping() then
			return skip(10)
		end
		return part2()
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_29dc3834(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_29dc3834(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return
	end
	event.ActchrSetDefMotion(0)
	var1 = event.GetEventData_2(6) or var1
	if var1 == 1 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.SetMesDrawspeed(0, 1)
		event.MesMake_2(0, "Il y a un rocher sur le chemin.\n(Pour ouvrir le menu : (#).)")
		var2 = helper_21ceb188(0, -1, 5, 256, 208, var2)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMesShippo(0, 1)
		event.SetMesDrawspeed(0, 0)
		if var2 == 1 then
			var1 = 2
		end
	end
	if var1 == 2 then
		event.SetStatusbarShow(0, 0.16666667)
		helper_a0e17f3c(6)
		if vm.skipping() then
			return skip(4)
		end
		event.GotoUseItem(173)
		do
			local skipped = vm.wait()
			var3 = event.DeferredOutput() or var3
			if skipped then
				return skip(5)
			end
		end
		if var3 == 173 then
			event.FadeOutBgm(20)
			event.SetFadeOut(20)
			helper_a0e17f3c(20)
			if vm.skipping() then
				return skip(6)
			end
			event.FuncPointShow("p04", "func", 0)
			helper_b0ccfec7()
			if vm.skipping() then
				return skip(7)
			end
			if vm.wait() then
				return skip(8)
			end
			event.Initialize()
			event.EohSyncObj(0, "p05")
			event.EohSetShow(0, 1)
			event.EohSyncObj(1, "p06")
			event.EohSetShow(1, 1)
			event.SetBitCtrl(1, 1)
			event.LoadMonsterFile(629, 1)
			event.LoadMonsterFile(630, 0)
			event.AutoSetMonster(629, -513.2, 9.0, -127.2, 0.0, 1.25, 0.0)
			helper_97678a64(vm.f32(438.61), 0.0, vm.f32(192.19), vm.f32(-1.89))
			event.SetCameraRef(438.61, 30.0, 192.19)
			event.SetCameraPos(590.29, 39.11, 243.1)
			event.ResetCamera(0)
			event.SetFadeIn(30)
			event.Finish()
		elseif var3 <= 0 then
		else
			helper_2f95e1a8()
			if vm.skipping() then
				return skip(9)
			end
		end
		event.SetStatusbarShow(1, 0.16666667)
		helper_a0e17f3c(6)
		if vm.skipping() then
			return skip(10)
		end
	end
	return part2()
end

--- Program 510.
script[510] = function()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a217b2b5()
			if not vm.skipping() then
				return part2()
			end
		end
		if at <= 2 then
			helper_17358()
		end
	end
	function part2()
		helper_17358()
		if vm.skipping() then
			return skip(3)
		end
		event.SetExitFlag(1)
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.FadeOutBgm(20)
	event.SetFadeOut(20)
	helper_a0e17f3c(20)
	if vm.skipping() then
		return skip(1)
	end
	event.DelMonster(-1)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.DngSetupMainUnit(0)
	end
	if active_chr_no == 3 then
		event.DngSetupMainUnit(1)
	end
	event.EohSyncObj(0, "p05")
	event.EohSetShow(0, 0)
	event.EohSyncObj(1, "p06")
	event.EohSetShow(1, 0)
	event.SetBitCtrl(1, 0)
	helper_a217b2b5()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 1200.
script[1200] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local value: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_7a92069b(0, 8600070)
			end
			return
		end
	end
	flag = event.GetFlag(816) or flag
	flag_2 = event.GetFlag(820) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		value = 0
		value = event.GetRandInt(100) or value
		if value < 50 then
			helper_7a92069b(0, 8600060)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_7a92069b(0, 8600070)
			if vm.skipping() then
				return skip(2)
			end
		end
		return
	end
	helper_74ae835d(0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Program 18160.
script[18160] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_b0ccfec7()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 18200.
script[18200] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_17358()
		end
	end
	helper_a217b2b5()
	if vm.skipping() then
		return skip(1)
	end
	helper_17358()
	if vm.skipping() then
		return skip(2)
	end
	event.SetExitFlag(1)
end

script[28020] = program_28020

return script
