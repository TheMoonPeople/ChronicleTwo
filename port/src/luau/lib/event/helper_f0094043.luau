--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2b963b7e = require("@lib/event/helper_2b963b7e")
local helper_4eedff96 = require("@lib/event/helper_4eedff96")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_8d417a4e = require("@lib/event/helper_8d417a4e")
local helper_ed0a80b8 = require("@lib/event/helper_ed0a80b8")

--- Helper function.
local function helper_f0094043(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local money: s32 = 0
	local var4: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_635ee3fd(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_635ee3fd(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_635ee3fd(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 5 then
				helper_635ee3fd(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 7 then
			return
		end
		if at <= 10 then
			if at <= 8 then
				var4 = helper_2b963b7e(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 9 then
				helper_635ee3fd(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 12 then
			if at <= 11 then
				helper_ed0a80b8(30)
			end
			return
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
			helper_8d417a4e()
		end
	end
	event.SetMesPreset(0, 0)
	helper_4eedff96(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(9) or var2
	money = event.GetMoney() or money
	if var2 == 0 then
		if money < 1000 then
			event.MesMake_2(
				0,
				"Ese dinero no\nme vale para la subasta.<page>Necesito 1000 Gildas.\nNo s[UNI00e9] si est[UNI00e1] claro."
			)
			helper_635ee3fd(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			event.MesMake_2(0, "[UNI00a1]No te lo vas a creer!<page>El precio ha subido a\n1200 Gildas.")
			helper_635ee3fd(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(3)
			end
			event.MesMake_2(0, "Lo siento mucho, pero [UNI00bf]podr[UNI00ed]as\nconseguir 1500 Gildas?")
			helper_635ee3fd(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(4)
			end
			event.SetCnt(9, 1)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 == 1 then
		if money < 1500 then
			event.MesMake_2(
				0,
				"No podemos perder el tiempo,\nsi no, se lo vender[UNI00e1]n a otro.<page>[UNI00a1]Cons[UNI00ed]gueme 1500 Gildas cuanto antes!"
			)
			helper_635ee3fd(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(5)
			end
		else
			event.MesMake_2(
				0,
				"[UNI00a1]Es terrible!\nAlguien ofrece 1800 Gildas.<page>Si no doy m[UNI00e1]s de 2000,\nno me lo llevar[UNI00e9] ni en broma."
			)
			helper_635ee3fd(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(6)
			end
			event.SetCnt(9, 2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 == 2 then
		if money < 2000 then
			event.MesMake_2(
				0,
				"No podemos perder el tiempo,\nsi no se lo vender[UNI00e1]n a otro.<page>[UNI00a1]Cons[UNI00ed]gueme 2000 Gildas cuanto antes!"
			)
			helper_635ee3fd(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "Sonny, [UNI00bf]has conseguido reunir\nlas 2000 Gildas?")
		helper_635ee3fd(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.SetMotion(arg0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "[UNI00bf]Qu[UNI00e9] hago? Es tuyo.\nHa sido un despilfarro.")
		var4 = helper_2b963b7e(0, -1, 5, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(9)
		end
		event.SetMesShippo(0, 1)
		event.SetMesEtc(0, 0, 0)
		if var4 ~= 0 then
			event.MesMake_2(
				0,
				"Ya... Bueno, 2000 Gildas es mucho dinero.\nDebe de ser duro gast[UNI00e1]rselo.\nIncluso para un joven bien acomodado como t[UNI00fa]... <page>Bueno, no importa.\nPero la subasta a[UNI00fa]n no ha terminado.\nEsperar[UNI00e9] lo que haga falta..."
			)
			helper_635ee3fd(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(10)
			end
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "Gracias por todo.<page>[UNI00a1]Me largo corriendo a la subasta!")
		helper_635ee3fd(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.AddMoney(-2000)
		event.SetCnt(9, 3)
		event.SetFadeOut(30)
		helper_ed0a80b8(30)
		if vm.skipping() then
			return skip(12)
		end
		event.SetAi(1, arg0)
		event.CharaActive(0, arg0)
		event.DeleteVillager(arg0)
		event.SetFadeIn(30)
		event.Finish()
		return
	end
	event.MesMake_2(0, "Muchas gracias.\nHe conseguido ganar la subasta.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(13)
	end
	event.MesMake_2(
		0,
		"Puj[UNI00e9] mucho y los dem[UNI00e1]s desistieron\nr[UNI00e1]pidamente. [UNI00a1]Me lo he llevado por 1400 Gildas!"
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "Tengo que devolverte 600.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.AddMoney(600)
	event.MesMake_2(0, "Y trabajar[UNI00e9] para devolverte\nel resto del dinero que te debo.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.MesMake_2(
		0,
		"S[UNI00e9] que te he causado muchas molestias.\nTe devolver[UNI00e9] el favor en cualquier momento."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	helper_8d417a4e()
	if vm.skipping() then
		return skip(18)
	end
	event.Finish()
	event.SetQuestEtc(1, 6, 1)
end

return helper_f0094043
