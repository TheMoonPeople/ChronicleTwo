--!strict
-- map/i/i01/h07/i01h07_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0c95681b = require("@lib/event/helper_0c95681b")
local helper_0d70bce8 = require("@lib/event/helper_0d70bce8")
local helper_187f0d3d = require("@lib/event/helper_187f0d3d")
local helper_2056b079 = require("@lib/event/helper_2056b079")
local helper_2ddedb3b = require("@lib/event/helper_2ddedb3b")
local helper_85ab2618 = require("@lib/event/helper_85ab2618")
local helper_8834eba9 = require("@lib/event/helper_8834eba9")
local helper_975658d3 = require("@lib/event/helper_975658d3")
local helper_b1ca721b = require("@lib/event/helper_b1ca721b")
local helper_bbc8e499 = require("@lib/event/helper_bbc8e499")
local helper_d22b9744 = require("@lib/event/helper_d22b9744")
local helper_e297c86b = require("@lib/event/helper_e297c86b")
local helper_eb131214 = require("@lib/event/helper_eb131214")
local helper_ecb662ce = require("@lib/event/helper_ecb662ce")
local helper_ee018022 = require("@lib/event/helper_ee018022")

--- Helper function.
local function helper_37de0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	if arg0 < 0 or 1 < arg0 or arg1 < 0 or 6 < arg1 then
		return
	end
	var2 = arg0 * 7 + arg1
	if var2 == 0 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m7")
	end
	if var2 == 7 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m21")
	end
	if var2 == 1 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m8")
	end
	if var2 == 8 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m20")
	end
	if var2 == 2 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m9")
	end
	if var2 == 9 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m19")
	end
	if var2 == 3 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m10")
	end
	if var2 == 10 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m18")
	end
	if var2 == 4 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m11")
	end
	if var2 == 11 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m17")
	end
	if var2 == 5 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m12")
	end
	if var2 == 12 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m16")
	end
	if var2 == 6 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m14")
	end
	if var2 == 13 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m15")
	end
	var3 = event.EohGetShow(0) or var3
	event.EohSetShow(0, if var3 == 0 then 1 else 0)
end

--- Helper function.
local function helper_38800(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_37de0(arg0, arg1)
			helper_37de0(vm.i32(arg0 + 1), arg1)
			helper_37de0(vm.i32(arg0 - 1), arg1)
			helper_37de0(arg0, vm.i32(arg1 + 1))
			helper_37de0(arg0, vm.i32(arg1 - 1))
			helper_0c95681b(45)
		end
	end
	event.SetMotion(0, "立ち")
	event.CmrsInit()
	event.CmrsSetPos(-5.74, 133.71, 0.0)
	event.CmrsSetRef(-143.54, 66.02, 0.0)
	helper_0c95681b(45)
	if vm.skipping() then
		return skip(1)
	end
	helper_37de0(arg0, arg1)
	helper_37de0(vm.i32(arg0 + 1), arg1)
	helper_37de0(vm.i32(arg0 - 1), arg1)
	helper_37de0(arg0, vm.i32(arg1 + 1))
	helper_37de0(arg0, vm.i32(arg1 - 1))
	helper_0c95681b(45)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_11fb4(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eb131214(arg0, -1, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMotion(arg1, "立ち")
		event.MesMake_2(0, "Mmh, questo albero... Non sembra\nstia bene. Devo fare qualcosa.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(1)
		end
	else
		event.MesMake_2(
			0,
			"Oh, Max! Mi hai messo paura.\nStavo levando dei fastidiosi\nparassiti da quest'albero.<page>Non tutti gli alberi crescono bene\nda soli, sai. Alcuni, come questo,\nhanno bisogno di molte cure."
		)
		helper_eb131214(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_11c60(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	event.SetMotion(arg1, "立ち")
	event.MesMake_2(0, "Mmh, questo albero... Non sembra\nstia bene. Devo fare qualcosa.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "[(!)]Pare che tu debba parlare con Gordon\n   per attirare la sua attenzione.")
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
end

--- Helper function.
local function helper_1230c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
		if at <= 9 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
		if at <= 10 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
		if at <= 11 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_11c60(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Oh, Max! Hai avuto parecchi\npensieri ultimamente.\nTi stai riguardando?<page>Posso fare qualcosa per te?"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Cosa! Vuoi che ti segua\nnella tua avventura?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Mmh... Vorrei venire con te...\nMa questo povero albero non\nsta mica tanto bene.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Prendermi cura degli alberi e dei\nfiori di questa tenuta [UNI00e8] ci[UNI00f2] che\nmi preme di pi[UNI00f9], lo sai.<page>Se me ne andassi a zonzo,\nperderei il mio lavoro!"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"L'Acqua sacra che Don Bruno vende\nin chiesa sanerebbe quest'albero!<page>Ma, come sai, tuo padre e Don\nBruno non vanno molto d'accordo...<page>Tuo padre non mi darebbe mai soldi\nper comprare la sua Acqua Sacra!<page>Sono in un bel pasticcio!"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "[(!)]Per portare Gordon a Sindain,\n   devi fare in modo che ti\n   segua in viaggio.")
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]Se soddisfi la richiesta di Gordon,\n   ti seguir[UNI00e0] in viaggio\n   e salir[UNI00e0] sul treno."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(0, "[(!)]Puoi controllare le richieste\n   leggendo il Taccuino,\n   nel Menu Oggetti.")
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	argc = event.GetItemHaveNum(386) or argc
	if argc <= 0 then
		event.MesMake_2(0, "[(!)]Oh, non hai un Taccuino?\n   Ce n'[UNI00e8] uno sul tavolo\n   nel Negozio di Cedric.")
		helper_8834eba9(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.MesMake_2(
			0,
			"[(!)]Ce ne [UNI00e8] un altro nella tana\n   di Donny. Vanno bene entrambi.\n   Prendine uno, sbrigati!"
		)
		helper_8834eba9(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(12)
		end
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 0, 1)
end

--- Helper function.
local function helper_12ffc(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 4 then
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
		if at <= 9 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
		if at <= 10 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_11c60(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Max, sistemare quest'albero\n[UNI00e8] ci[UNI00f2] che mi preme di pi[UNI00f9].<page>Allora, per rimetterlo in sesto,\nmi serve..."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.GotoUseItem(276)
	do
		local skipped = vm.wait()
		var3 = event.DeferredOutput() or var3
		if skipped then
			return skip(4)
		end
	end
	if var3 <= 0 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var3 ~= 276 then
		event.MesMake_2(0, "Max, non funzioner[UNI00e0]...<page>Mi serve l'Acqua Sacra\ndi Don Bruno.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"S[UNI00ec]! Max, ce l'hai fatta! Ora\nposso prendermi cura dell'albero!<page>Ti ringrazio, Max."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Bene, sembra che abbia sbrigato\ntutte le mie faccende.<page>Ora posso seguirti\nnella tua avventura!<page>Oh, e mi raccomando, non parlare\na tuo padre dell'Acqua Sacra, OK?"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "Gordon si [UNI00e8] unito al gruppo.")
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]Puoi sfruttare le sue capacit[UNI00e0]\n   con il comando Stato sotto\n   Personaggi, nel Menu principale.<page>[(!)]Se recluti qualcun altro\n   nella tua avventura, quella\n   persona salir[UNI00e0] sul treno."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"[(!)]Parla alla persona sul treno\n   per inserirla nel gruppo\n   come terzo membro.<page>[(!)]Per trasferire uno dei tuoi amici\n   in una casa, scegli Alloggia persone\n   dal Menu sulla porta della casa."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(0, "[(!)]Molti altri potrebbero\n   voler venire con te.\n   Mi raccomando, cercali!")
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMesPreset(0, 0)
	var4 = event.GetEventData_2(14) or var4
	event.SetNpcStatus(var4, 130)
	event.Finish()
	event.SetQuestEtc(1, 0, 1)
end

--- Helper function.
local function helper_13cec(arg0: s32, arg1: any)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			event.MesMake_2(0, "Oh, salve, signorina.\nPosso fare qualcosa per lei?")
		else
			event.MesMake_2(0, "Max, non fare parola a tuo padre\ndi quell'Acqua sacra, capito?")
		end
	else
		event.MesMake_2(0, "Chiss[UNI00e0] quante piante l[UNI00e0] fuori,\nche non abbiamo ancora visto!")
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1400c(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
		if at <= 3 then
			return
		end
	end
	flag = event.GetFlag(42) or flag
	if flag == 0 then
		helper_11fb4(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_1230c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_12ffc(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_13cec(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

--- Helper function.
local function helper_16a14(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_0d70bce8(arg0, 0, 0)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMesPreset(0, 0)
		helper_0d70bce8(arg0, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Ciao.\nMonica, giusto?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Mi chiamo Parn.\nSono un artista magico.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Ehi, Max!<page>Come fai ad essere\nsempre cos[UNI00ec] in forma?!")
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
end

--- Helper function.
local function helper_16e00(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_85ab2618(0, -1, arg1, arg0, 0)
			end
			if at <= 5 then
				helper_8834eba9(0, -1, 8, 0, 0)
			end
			return
		end
		if at <= 7 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_85ab2618(0, -1, arg1, arg0, 0)
		end
		if at <= 10 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 11 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 12 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 13 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 14 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 16 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMesPreset(0, 0)
		helper_0d70bce8(arg0, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		event.MesMake_2(0, "Ciao.\nMonica, giusto?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Mi chiamo Parn.\nSono un artista magico.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Non vi ho ancora presentato, vero?<page>Ecco Julia, la mia futura moglie.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.MesMake_2(0, "...")
		helper_85ab2618(0, -1, arg1, arg0, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.MesMake_2(
			0,
			"[(!)] Monica non [UNI00e8] molto brava in queste\n   situazioni. Forse pu[UNI00f2] fare qualcosa,\n   forse no. Meglio riprovare come Max."
		)
		helper_8834eba9(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetMesPreset(0, 0)
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(0, "Ehi, Max!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "Non vi ho ancora presentato, vero?<page>Ecco Julia, la mia futura moglie.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(0, "...")
	helper_85ab2618(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(
		0,
		"Certo, ridi pure!\nLo so che [UNI00e8] strano!<page>Chi si innamorerebbe della\nragazza di un quadro?"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(
		0,
		"Ma io sono un artista magico e\nposso dar vita ai miei quadri.<page>I miei soggetti esistono davvero,\nescluse le creature viventi..."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.MesMake_2(0, "Neanche un artista magico pu[UNI00f2]\nricreare la vita")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(13)
	end
	event.MesMake_2(0, "In realt[UNI00e0] un modo c'[UNI00e8]: un Uovo\nd'Oro in un grande albero antico.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "Pare che la sua Vernice oro dia\nvita a qualunque disegno.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.MesMake_2(0, "Max, stai andando fuori\ncitt[UNI00e0], vero?<page>Mi prenderesti della Vernice oro?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.MesMake_2(
		0,
		"Non mi aspetto che lo faccia gratis.<page>Se mi dai una mano, user[UNI00f2] i miei\nnuovi poteri per aiutarti."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Un grande albero antico...\n   con un Uovo d'Oro! Dove diavolo\n   lo trovi un albero simile?!"
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(18)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 1, 1)
end

--- Helper function.
local function helper_11b80()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bbc8e499(var0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	event.SetNpcStatus(var0, 128)
	helper_bbc8e499(var0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_17ee8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_11b80()
		end
		if at <= 8 then
			helper_bbc8e499(22)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Ti stavo aspettando.<page>Forza, dammi la Vernice, cos[UNI00ec]\nposso dar vita al mio quadro!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoUseItem(376)
	do
		local skipped = vm.wait()
		var2 = event.DeferredOutput() or var2
		if skipped then
			return skip(3)
		end
	end
	if var2 <= 0 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 ~= 376 then
		event.MesMake_2(0, "Starai scherzando!<page>Mi serve la Vernice oro.\nNon sbagliare!")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(376)
	event.MesMake_2(0, "Cos[UNI00ec] [UNI00e8] questa la Vernice oro...\nLa provo subito.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Lei, lei... [UNI00e8] vera...<page>Incredibile, [UNI00e8] perfetta!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "Grazie, Max. Non ho dimenticato\nla mia promessa. Usa pure il\nmio nuovo potere quando vuoi!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_11b80()
	if vm.skipping() then
		return skip(8)
	end
	event.SetNpcStatus(22, 130)
	helper_bbc8e499(22)
	if vm.skipping() then
		return skip(9)
	end
	event.Finish()
	event.SetQuestEtc(1, 1, 1)
end

--- Helper function.
local function helper_186b0(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Usa pure il mio nuovo potere\nquando vuoi.")
	else
		event.MesMake_2(
			0,
			"Il mondo della pittura [UNI00e8] sconfinato.\nPotrebbe volerci tutta la vita per\nconoscerlo ma ne varrebbe la pena!"
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_18908(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_16a14(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_16a14(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_16e00(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_17ee8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_186b0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_10aac(arg0: s32)
	local var1: s32 = 0
	local player_chara: s32 = 0
	local now_map_no: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return 1
		end
		if at <= 2 then
			helper_8834eba9(arg0, -1, 3, 256, 208)
		end
		if at <= 3 then
			helper_ecb662ce(arg0, 1)
			helper_85ab2618(arg0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_8834eba9(arg0, -1, 3, 256, 208)
		end
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	do
		local out1, out2 = event.GetMenuEtc_3(6)
		var4 = out1 or var4
		var5 = out2 or var5
	end
	if 0 < var4 then
		return 1
	end
	if var5 == 1 then
		helper_ecb662ce(arg0, 1)
		event.MesMake_2(arg0, "Se non mi porti altri scoop,\nnon posso darti nulla!")
		if now_map_no == 22 then
			helper_85ab2618(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			helper_8834eba9(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(3)
			end
		end
	end
	if var5 == 2 then
		helper_ecb662ce(arg0, 1)
		event.MesMake_2(
			arg0,
			"Il numero di idee e di scoop\ndetermineranno il tuo Livello\nfotografico.<page>Salendo di livello, riceverai\nin premio altri oggetti magnifici."
		)
		if now_map_no == 22 then
			helper_85ab2618(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(4)
			end
		else
			helper_8834eba9(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(5)
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_110f4(arg0: s32)
	local var1: s32 = 0
	local player_chara: s32 = 0
	local now_map_no: s32 = 0
	local argc: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_8834eba9(arg0, -1, 3, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				helper_8834eba9(arg0, -1, 3, 256, 208)
			end
			return helper_10aac(arg0)
		end
		if at <= 5 then
			helper_ecb662ce(arg0, 1)
			helper_85ab2618(arg0, -1, var1, player_chara, 0)
		end
		if at <= 6 then
			helper_8834eba9(arg0, -1, 3, 256, 208)
		end
		return helper_10aac(arg0)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	argc = event.GetItemHaveNum(355) or argc
	if argc <= 0 then
		helper_ecb662ce(arg0, 1)
		event.MesMake_2(arg0, "Andresti a prendermi\nun Blocchetto Scoop?")
		if now_map_no == 22 then
			helper_85ab2618(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_8834eba9(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		return 0
	end
	do
		local out1, out2 = event.GetMenuEtc_3(5)
		var5 = out1 or var5
		var6 = out2 or var6
	end
	if var5 == var6 then
		helper_ecb662ce(arg0, 1)
		event.MesMake_2(arg0, "Sembra non ci siano\naltri scoop.")
		if now_map_no == 22 then
			helper_85ab2618(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(3)
			end
		else
			helper_8834eba9(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(4)
			end
		end
		return helper_10aac(arg0)
	end
	var7 = event.GetMenuEtc_2(3) or var7
	if 0 < var7 then
		helper_ecb662ce(arg0, 8)
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Ho trovato ancora [Numero1] scoop.")
		event.SetMesDrawspeed(arg0, 0)
		helper_8834eba9(arg0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
	end
	helper_ecb662ce(arg0, 1)
	var7 = event.GetMenuEtc_2(4) or var7
	if var7 <= 0 then
		event.MesMake_2(arg0, "Allora, amico! Non startene\nimpalato! Dove sono i tuoi scoop?")
	else
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Wow! Hai ottenuto [Number1] scoop!\nSapevo che ce l'avevi nel sangue!")
	end
	if now_map_no == 22 then
		helper_85ab2618(arg0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(6)
		end
	else
		helper_8834eba9(arg0, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(7)
		end
	end
	return helper_10aac(arg0)
end

--- Helper function.
local function helper_e518()
	local var0: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("IN go_shop_up()\n")
			print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
			helper_eb131214(var1, -1, 0, 0)
		end
		if at <= 2 then
			helper_ee018022(15)
		end
		if at <= 3 then
			helper_ee018022(1)
		end
		if at <= 4 then
			helper_ee018022(6)
		end
		if at <= 5 then
			helper_ee018022(0)
		end
		if at <= 6 then
			helper_ee018022(4)
		end
		if at <= 7 then
			helper_ee018022(31)
		end
		if at <= 8 then
			helper_ee018022(35)
		end
		if at <= 9 then
			helper_ee018022(36)
		end
		if at <= 10 then
			helper_ee018022(37)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	print("IN go_shop_up()\n")
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Benvenuti.")
	if var0 == 18 then
		event.MesMake_2(
			0,
			"Vorresti usufruire del potere\ndegli d[UNI00e8]i? Allora, ti prego di\nfare una donazione alla chiesa."
		)
	end
	if var0 == 4 then
		event.MesMake_2(
			0,
			"Si lavora sodo, vedo!\nTi serve qualcosa?<page>Per[UNI00f2], niente omaggi.\nNeanche per te, Max."
		)
	end
	if var0 == 34 then
		event.MesMake_2(
			0,
			"Vi servono altri elementi\nDiorama?<page>Se non avete tempo di cercarli\nda soli, i soldi potrebbero\nrisolvere i vostri problemi."
		)
	end
	if var0 == 1012 then
		flag = event.GetFlag(45) or flag
		if flag == 0 then
			event.MesMake_2(
				0,
				"Salve. Sono apprendista fornaia.\nSostituisco Polly al forno\nquando non c'[UNI00e8].<page>Sono un po' nervosa, ma fa parte\nanche questo dell'apprendistato.\nFar[UNI00f2] del mio meglio!"
			)
			event.SetFlag(45, 1)
		end
	end
	if var0 == 1015 then
		flag_2 = event.GetFlag(46) or flag_2
		if flag_2 == 0 then
			event.MesMake_2(
				0,
				"Forse non ci somigliamo molto...\nMa sono la sorellina di Milane.<page>Mi ha lasciata qui a badare al\nnegozio, ma non mi intendo d'armi!"
			)
			event.SetFlag(46, 1)
		end
	end
	if var0 == 1018 then
		flag_3 = event.GetFlag(47) or flag_3
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Sorpreso, vero? Immagino chiunque\nrimarrebbe meravigliato nel vedere\nqualcuno vestito cos[UNI00ec].<page>Sostituisco il mio amico Don Bruno\nche [UNI00e8] in viaggio. Allora, posso\nesserti d'aiuto in qualche modo?"
			)
			event.SetFlag(47, 1)
		else
			event.MesMake_2(
				0,
				"Vorresti usufruire del potere\ndegli d[UNI00e8]i? Allora, ti prego di\nfare una donazione alla chiesa."
			)
		end
	end
	if var1 ~= -1 then
		helper_eb131214(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var0 == 18 then
		helper_ee018022(15)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var0 == 12 then
		helper_ee018022(1)
		if vm.skipping() then
			return skip(4)
		end
	end
	if var0 == 4 then
		helper_ee018022(6)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var0 == 15 then
		helper_ee018022(0)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var0 == 33 then
		helper_ee018022(4)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var0 == 34 then
		helper_ee018022(31)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var0 == 1012 then
		helper_ee018022(35)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var0 == 1015 then
		helper_ee018022(36)
		if vm.skipping() then
			return skip(10)
		end
	end
	if var0 == 1018 then
		helper_ee018022(37)
		if vm.skipping() then
			return skip(11)
		end
	end
end

--- Helper function.
local function helper_18d7c(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Il negozio [UNI00e8] chiuso. Dovrai andare\nin quello del mio vecchio.<page>Cerca le zucche, non puoi sbagliare!\n[UNI00c8] proprio in cima a quella scala."
	)
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_18bec(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Da quando sei arrivata,\nnon ho pi[UNI00f9] visto Max.\nNon so cos'hai in mente, ma<page>spero tu non lo stia sfruttando."
	)
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_18f2c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_18bec(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Dovresti gi[UNI00e0] sapere la risposta:\nNEANCHE PER SOGNO!<page>Perch[UNI00e9] dovrei faticare per\nfare un favore a qualcun altro?"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "A me non ne viene niente\ned [UNI00e8] troppo pericoloso.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Comunque, siccome sei tu, potrei\nanche farci un pensierino.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Sono figlio di un commerciante io,\nnon faccio certo favori gratis!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Saprai che colleziono monete.<page>Sono il perno degli affari. Come\nvorrei completare la collezione!"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Non riesco mai a mettere\nle mani sulla Moneta oscura\ne sulla Moneta eterna.<page>Se mi aiutassi,\nforse io potrei aiutare te."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(0, 2, 1)
end

--- Helper function.
local function helper_19670(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local var5: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				var5 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 5 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 7 then
			helper_11b80()
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_18bec(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	argc = event.GetItemNum(201) or argc
	argc_2 = event.GetItemNum(202) or argc_2
	if argc <= 0 or argc_2 <= 0 then
		event.MesMake_2(
			0,
			"Come? Ah, la numismatica?<page>Sto cercando la Moneta oscura\ne la Moneta eterna.<page>Non le troverai mai. Le ho cercate\novunque, ma sono cos[UNI00ec] rare!"
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Eh? Le hai trovate? Incredibile!<page>Forza! Dammele, dammele, dammele!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "Bene.\nCosa devo fare?")
	var5 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var5 ~= 0 then
		event.MesMake_2(0, "Argh! Se mi fai perdere tempo,\nnon ti aiuter[UNI00f2] di certo.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(201)
	event.SubItem(202)
	event.MesMake_2(
		0,
		"Wow, le ho tutte! E io che\npensavo fosse impossibile...<page>Bene, immagino di non avere\naltra scelta ora. Verr[UNI00f2] con te!"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_11b80()
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(1, 2, 1)
end

--- Helper function.
local function helper_1a0d0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			helper_18bec(arg0, arg1)
			if vm.skipping() then
				return skip(1)
			end
			return
		end
		event.SetMesPreset(0, 0)
		event.MesMake_2(0, "Incredibile! Non pensavo che\nsaresti riuscito a trovarle.<page>Niente male, Max!")
	else
		event.MesMake_2(
			0,
			"Ehi! Come procede la ricerca di\nZelmite? Se c'[UNI00e8] qualcosa che\nposso fare, fammi un fischio."
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1a3f0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
		if at <= 3 then
			return
		end
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_18d7c(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_18f2c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_19670(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_1a0d0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

--- Helper function.
local function helper_1a6d4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0d70bce8(arg0, 0, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Salve. Che tipo di cibo ti piace,\nMonica?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Certo, mi piace il cibo normale,\nma apprezzo anche quello esotico.")
	else
		event.MesMake_2(
			0,
			"Un giorno diventer[UNI00f2] il miglior\ncuoco del mondo e allora potrai\nmangiare gratis quanto vorrai."
		)
	end
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_1aa8c(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Hai fatto qualche nuova scoperta?<page>Sai, mentre tu fai esperimenti\nsu macchine e strumenti,\nio faccio esperimenti di cucina.<page>Ogni giorno provo dei\npiatti deliziosi, che nessuno\nha mai assaggiato prima."
	)
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1ac7c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Ah, capitate a proposito!\nVolevo parlarvi di una cosa.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Sicuramente sapete che sto\npreparando dolci esotici da tutto\nil mondo, per la mia ricerca.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Pare che esista un dolce chiamato\nCastagnaccio.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "fatto con una certa Castagna.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Ho scoperto che la Castagna cresce\nsu alberi chiamati Castagni.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Pensavo di usare le Castagne,\nma stranamente...\nnon se ne trovano pi[UNI00f9] in citt[UNI00e0]!"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(0, "Il Sindaco se le [UNI00e8] accaparrate tutte.\nNon [UNI00e8] che potreste darmi una mano?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
	event.SetQuestEtc(0, 3, 1)
end

--- Helper function.
local function helper_1b398(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_11b80()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Avete trovato delle Castagne?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoUseItem(301)
	do
		local skipped = vm.wait()
		var2 = event.DeferredOutput() or var2
		if skipped then
			return skip(3)
		end
	end
	if var2 <= 0 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 ~= 301 then
		event.MesMake_2(0, "Allora non potete aiutarmi...<page>Oh beh, meglio lasciar\nperdere il Castagnaccio.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"Ah, eccole! Grazie tante.<page>Prover[UNI00f2] a fare il Castagnaccio.<page>Ve lo far[UNI00f2] assaggiare appena pronto!"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Posso fare qualcosa in cambio?<page>Cosa? Un'avventura al vostro fianco?<page>Ah ah! Certo che verr[UNI00f2].<page>Ma potevate dirlo subito!"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_11b80()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 3, 1)
end

--- Helper function.
local function helper_1ba40(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Certo che non vi rifiuterei\nmai niente.")
	else
		event.MesMake_2(
			0,
			"Un giorno diventer[UNI00f2] il miglior\ncuoco del mondo e allora potrai\nmangiare gratis quanto vorrai."
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1bc88(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1a6d4(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1a6d4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_1aa8c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_1ac7c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_1b398(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_1ba40(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_1c014(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0d70bce8(arg0, 0, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Ciao! Sei la fidanzata\ndi Max?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Hai i capelli di un colore strano.\nCome quelli di Erik, ma diversi...<page>I tuoi sono veramente belli:\nbrillano come gioielli!"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_1c2f4(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1c014(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1c014(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Sei stato fuori citt[UNI00e0] ultimamente,\nvero Max?<page>Non negarlo.\nSo che [UNI00e8] cos[UNI00ec]!"
	)
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_1c51c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1c014(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Io vorrei aiutarvi, ma lottare\nfa paura... e poi ci si sporca!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Non vorrei essere di peso a\nnessuno. Devo dirvi di no.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Ma devono esserci molte cose\ninsolite fuori citt[UNI00e0].<page>Mi chiedo come siano gli alberi\ne quali fiori sboccino."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Se vedi un fiore interessante, gli\nfaresti una foto per me, Max?\nMi piacerebbe tanto vederlo."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Questa volta ha detto no ma, se le\n   mostrassi una foto di qualcosa\n   che le piace, forse cederebbe."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 4, 1)
end

--- Helper function.
local function helper_1cc30(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local photo: s32 = 0
	local photo_2: s32 = 0
	local photo_3: s32 = 0
	local photo_4: s32 = 0
	local photo_5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_11b80()
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1c014(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	photo = event.CheckInventPhoto(2009) or photo
	photo_2 = event.CheckInventPhoto(52, 3) or photo_2
	photo_3 = event.CheckInventPhoto(53, 3) or photo_3
	photo_4 = event.CheckInventPhoto(54, 3) or photo_4
	photo_5 = event.CheckInventPhoto(55, 3) or photo_5
	if vm.i32(vm.i32(vm.i32(vm.i32(photo + photo_2) + photo_3) + photo_4) + photo_5) <= 0 then
		event.MesMake_2(
			0,
			"Hai fotografato un fiore insolito?<page>So tutto sui fiori... se non [UNI00e8]\ndavvero speciale non mi interessa!"
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Hai fotografato un fiore insolito?\nVediamo, vediamo!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Wow! [UNI00c8] incredibile! Allora,\nsi trovano fiori cos[UNI00ec] l[UNI00e0] fuori!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Mmh... cosa dovrei fare?<page>Oh, va bene! Portatemi con voi!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_11b80()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 4, 1)
end

--- Helper function.
local function helper_1d460(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			helper_1c014(arg0, arg1)
			if vm.skipping() then
				return skip(1)
			end
			return
		end
		event.MesMake_2(0, "Non andate in posti troppo\npericolosi!")
	else
		event.MesMake_2(0, "Finalmente la Ferrovia Carbonero\n[UNI00e8] operativa in tutto il mondo.\nChe emozione!")
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1d740(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1c2f4(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_1c2f4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_1c51c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_1cc30(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_1d460(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_1da24(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eb131214(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Sar[UNI00f2] l'unico a pensarla cos[UNI00ec], ma\nqualcosa in te mi ricorda Elena.<page>Sei speciale rispetto agli altri\nabitanti di questa citt[UNI00e0]."
		)
	else
		event.MesMake_2(
			0,
			"La Miniera di Zelmite [UNI00e8] un posto\nmolto pericoloso. Non si deve\nmai abbassare la guardia."
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1dcdc(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Per qualsiasi problema,\nvenite subito da me!")
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1de1c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 10 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Qualunque cosa vi serva, far[UNI00f2]\ndel mio meglio per aiutarvi.<page>Lasciate fare a me.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "...")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Non so se potete aiutarmi...<page>Comunque ascoltate.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Sono 30 anni che lavoro\nsodo in questa casa.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Il lavoro [UNI00e8] la mia vita, ma\nun hobby ce l’ho: la lettura.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "C'[UNI00e8] un libro raro e prezioso,\nora in vendita all'asta.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(0, "La gente fa a botte per averlo.\nCredo che un'offerta di circa\n1000 Gilda possa bastare.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"Non ho tanto denaro e, se lo\nchiedessi al padrone, andrebbe su tutte\nle furie e io dovrei andarmene."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"Siete la mia unica speranza.<page>Ma questo non significa che se\nnon mi aiutate io non aiuter[UNI00f2] voi."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Malgrado le sue parole, Stewart non vi\n   aiuter[UNI00e0] se non gli darete 1000 Gilda.\n   Bisogner[UNI00e0] racimolare soldi!"
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 6, 1)
end

--- Helper function.
local function helper_1e898(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local money: s32 = 0
	local var4: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 5 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 7 then
			return
		end
		if at <= 10 then
			if at <= 8 then
				var4 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 9 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 12 then
			if at <= 11 then
				helper_0c95681b(30)
			end
			return
		end
		if at <= 13 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 14 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 16 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_11b80()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(9) or var2
	money = event.GetMoney() or money
	if var2 == 0 then
		if money < 1000 then
			event.MesMake_2(
				0,
				"Questa cifra non mi permetter[UNI00e0]\ndi partecipare all'asta.<page>Ho bisogno di 1000 Gilda.\nCercate di non sbagliare!"
			)
			helper_85ab2618(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			event.MesMake_2(0, "Non ci crederete!<page>Il prezzo [UNI00e8] salito\na 1200 Gilda.")
			helper_85ab2618(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(3)
			end
			event.MesMake_2(0, "Scusate tanto, vi dispiacerebbe\nprocurarmi 1500 Gilda?")
			helper_85ab2618(0, -1, arg0, arg1, 0)
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
				"Non perdiamo tempo, altrimenti\nsar[UNI00e0] venduto a qualcun altro.<page>Portatemi 1500 Gilda, presto!"
			)
			helper_85ab2618(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(5)
			end
		else
			event.MesMake_2(
				0,
				"[UNI00c8] terribile!\nQualcuno ha offerto 1800 Gilda!<page>Se non offro almeno 2000 Gilda,\nnon riuscir[UNI00f2] ad aggiudicarmelo."
			)
			helper_85ab2618(0, -1, arg0, arg1, 0)
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
				"Non perdiamo tempo, altrimenti\nverr[UNI00e0] venduto a qualcun altro.<page>Portatemi 2000 Gilda, presto!"
			)
			helper_85ab2618(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "Figliolo, sei riuscito a\nracimolare i miei 2000 Gilda?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.SetMotion(arg0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "Che posso farci, [UNI00e8] tuo.\nPer[UNI00f2] che spreco!")
		var4 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(9)
		end
		event.SetMesShippo(0, 1)
		event.SetMesEtc(0, 0, 0)
		if var4 ~= 0 then
			event.MesMake_2(
				0,
				"Gi[UNI00e0], 2000 Gilda sono molti soldi.\nDev'essere duro separarsene.\nAnche per un damerino come te...<page>Va bene allora, non importa!\nMa l'asta non [UNI00e8] ancora finita.\nAspetter[UNI00f2] anche in eterno!"
			)
			helper_85ab2618(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(10)
			end
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "Grazie tante.<page>Andr[UNI00f2] subito all'asta!")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.AddMoney(-2000)
		event.SetCnt(9, 3)
		event.SetFadeOut(30)
		helper_0c95681b(30)
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
	event.MesMake_2(0, "Grazie tante.\nLa mia era l’offerta migliore.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(13)
	end
	event.MesMake_2(0, "Alzata l'offerta, si sono ritirati\ntutti: l'ho avuto per 1400 Gilda!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "Quindi posso ridarvene 600.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.AddMoney(600)
	event.MesMake_2(0, "E d'ora in poi, lavorer[UNI00f2] sodo per\nrestituirvi il resto del prestito.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.MesMake_2(0, "So di avervi messo nei guai.\nVi devo un favore.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	helper_11b80()
	if vm.skipping() then
		return skip(18)
	end
	event.Finish()
	event.SetQuestEtc(1, 6, 1)
end

--- Helper function.
local function helper_1fea0(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Il libro?\nVeramente, non l'ho ancora letto.<page>Il solo averlo mi ha\ncomunque reso felice."
		)
	else
		event.MesMake_2(
			0,
			"La Miniera di Zelmite [UNI00e8] un posto\nmolto pericoloso. Non si deve\nmai abbassare la guardia."
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_20118(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1da24(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1da24(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_1dcdc(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_1de1c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_1e898(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_1fea0(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_204a4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0d70bce8(arg0, 0, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Per favore smetti di cacciare Max\nin situazioni pericolose.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Se gli trovo anche solo un\ngraffio, te ne pentirai!")
	else
		event.MesMake_2(0, "Pregher[UNI00f2] per la tua incolumit[UNI00e0]...")
	end
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_2082c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Lavoro qui come domestica,\nma sin da bambina avevo\nun sogno: diventare sarta!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "I sogni non diventano mai realt[UNI00e0],\necco perch[UNI00e9] si chiamano sogni.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_20b0c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Capisco...vorrei\npotervi aiutare... davvero!\nPi[UNI00f9] di qualsiasi altra cosa.<page>Ma non ho alcuna\nfiducia in me stessa."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Mi arrendo sempre a met[UNI00e0] strada e\nnon porto mai a termine nulla.<page>Da bambina, sognavo di fare la\nsarta, ma iniziavo sempre a fare\nvestiti, senza mai finirli."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Sono sicura che se venissi con\nvoi, sarei solo d'impaccio.<page>Quindi, mi spiace: dico di no."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Oh, Adel non ha fiducia in\n   s[UNI00e9], e non va bene. Facciamole\n   tornare la voglia di cucire!"
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 7, 1)
end

--- Helper function.
local function helper_21128(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"S[UNI00ec], se ci riprovassi e portassi\na termine qualcosa, forse\ntornerei a credere in me stessa."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Ma mi mancano i materiali.<page>Potreste procurarmeli?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Mi servono: Stoffa robusta,\nCuoio spesso e un Pezzo di Rame.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
	event.SetCnt(8, 1)
end

--- Helper function.
local function helper_214f8(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local var5: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_0d70bce8(arg0, 0, 0)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			if at <= 4 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			helper_0c95681b(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	argc = event.GetItemNum(214) or argc
	argc_2 = event.GetItemNum(245) or argc_2
	argc_3 = event.GetItemNum(227) or argc_3
	if argc <= 0 or argc_2 <= 0 or argc_3 <= 0 then
		event.MesMake_2(
			0,
			"Senza materiali,\nnon posso fare nulla.<page>Mi servono: Stoffa robusta,\nCuoio spesso e un Pezzo di Rame.<page>Mi spiace\nessere di peso!"
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
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
	event.MesMake_2(0, "Ecco, prendi questi!\nChe spreco per[UNI00f2]!")
	var5 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var5 ~= 0 then
		event.MesMake_2(0, "Senza materiali,\nnon posso fare nulla.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
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
		"Grazie di cuore!\nOra prover[UNI00f2] a fare dei vestiti!<page>Niente di questo andr[UNI00e0] sprecato!"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetFadeOut(30)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(7)
	end
	event.SetAi(1, arg0)
	event.CharaActive(0, arg0)
	event.DeleteVillager(arg0)
	event.Finish()
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_21efc(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0d70bce8(arg0, 0, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			var2 = 259
			var2 = 258
			var2 = 260
			helper_e297c86b(var2, 1)
		end
		if at <= 6 then
			helper_b1ca721b(1)
		end
		if at <= 7 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_11b80()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Ah, Max! Ho finito un indumento!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Non volevo sprecare i materiali\nche mi avete dato e che mi hanno\npermesso di arrivare fino in fondo."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Non sono del tutto convinta,\nma lo proveresti intanto?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	var2 = 259
	argc = event.GetItemNum(258) or argc
	if argc <= 0 then
		var2 = 258
	else
		argc = event.GetItemNum(260) or argc
		if argc <= 0 then
			var2 = 260
		end
	end
	event.AddItem(var2)
	helper_e297c86b(var2, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_b1ca721b(1)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Ah, che bello aver\nportato qualcosa a termine!<page>Ora mi sento molto\npi[UNI00f9] sicura di me.<page>Far[UNI00f2] del mio meglio...\nPer favore, portatemi con voi!"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMotion(arg0, "立ち")
	helper_11b80()
	if vm.skipping() then
		return skip(9)
	end
	event.Finish()
	event.SetQuestEtc(1, 7, 1)
end

--- Helper function.
local function helper_22608(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Che ne dici?<page>Dimmi la verit[UNI00e0]!")
	else
		event.MesMake_2(0, "Pregher[UNI00f2] per la tua incolumit[UNI00e0]...")
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_22820(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_204a4(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 7 then
			if at <= 5 then
				helper_214f8(arg0, arg1)
			end
			if at <= 6 then
				helper_21efc(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_204a4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_2082c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_20b0c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_21128(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_214f8(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_21efc(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_22608(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

--- Helper function.
local function helper_23ae8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0d70bce8(arg0, 0, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Sei tu la ragazza che\ngira con Max ultimamente!<page>Riconosco un bravo ragazzo\nquando ne vedo uno."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Se solo fossi un po' pi[UNI00f9] giovane,\nnon me lo lascerei scappare!")
	else
		event.MesMake_2(0, "Se mai ti venisse voglia\ndi pane, sai dove trovarmi.")
	end
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_23eb0(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"[UNI00c8] fondamentale negli affari\navere la fiducia dei tuoi clienti.<page>Non devi mai darla\nper scontata!"
	)
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_24030(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_e297c86b(300, 20)
		end
		if at <= 5 then
			helper_b1ca721b(1)
		end
		if at <= 6 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Vuoi che venga\ncon voi?<page>Sono solo una fornaia,\nma se posso essere utile,\nvengo volentieri."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Oh, ma prima c'[UNI00e8] una cosa che\ndev'essere consegnata a Morton.<page>Ti spiacerebbe portare 20 pagnotte\nal negozio di Morton per me?"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Mentre vai,\npreparo i bagagli.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(300, 20)
	helper_e297c86b(300, 20)
	if vm.skipping() then
		return skip(5)
	end
	helper_b1ca721b(1)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "Mi chiedo perch[UNI00e9] diavolo\nvoglia 20 pagnotte!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(0, 8, 1)
	event.SetCnt(12, 0)
end

--- Helper function.
local function helper_245c0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_11b80()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(12) or var2
	if var2 < 3 then
		event.MesMake_2(0, "Mi spiace, non sono\nancora pronta.<page>Puoi concedermi\naltro tempo?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "A proposito, hai gi[UNI00e0] fatto\nquella consegna a Morton?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Cosa! Come pu[UNI00f2] essere\ncos[UNI00ec] sconsiderato?<page>Oh, va bene:\nprendile tu.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Lascia perdere,\nandiamo.<page>Allora, dove\nsiamo diretti?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SubItem(300, 20)
	event.AddItem(299, 20)
	helper_11b80()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 8, 1)
end

--- Helper function.
local function helper_24bb0(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Forza Max,\nandiamo.<page>Allora, dove\nsiamo diretti?")
	else
		event.MesMake_2(0, "Se mai ti venisse voglia\ndi pane, sai dove trovarmi.")
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_24dd8(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_23ae8(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_23ae8(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_23eb0(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_24030(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_245c0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_24bb0(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_142d8(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eb131214(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Non mi piace vedere una donna\ncon una spada in mano.<page>Le donne migliori sono aggraziate.\nPrendi Adel, per esempio."
		)
	else
		event.MesMake_2(0, "Se posso aiutarti in qualche\nmodo, non esitare a chiedere.")
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_14550(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Questa citt[UNI00e0] [UNI00e8] troppo tranquilla,\nnon c'[UNI00e8] lavoro per me.<page>Non che mi lamenti,\neppure..."
	)
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_146e0(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Ehi, Max.\nMi spiace, sono un po'\npreso adesso.<page>Sto per entrare in possesso di\nmateriali essenziali alla\nsicurezza della citt[UNI00e0]."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Se non [UNI00e8] urgente, non\nsi pu[UNI00f2] aspettare fino a domani?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_149f0(arg0: s32, arg1: s32)
	local var2: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				var2 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "Certo, ci prover[UNI00f2].\nNon me la sento.")
	var2 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var2 ~= 0 then
		event.MesMake_2(0, "OK...<page>OK, se vuoi riprovarci pi[UNI00f9] avanti,\nfammelo sapere. Ti aspetto.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		event.SetCnt(7, 0)
		return
	end
	event.MesMake_2(0, "Pronti, partenza,\nvia!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.Finish()
	event.Stopwatch(3, 32, 364, 0)
	event.Stopwatch_1(0)
	event.SetCnt(7, 1)
end

--- Helper function.
local function helper_14f84(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_149f0(arg0, arg1)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Ehi Max, sei venuto a cercare me?<page>Ti stavo aspettando.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Grazie alle mura del castello,\nquesta citt[UNI00e0] [UNI00e8] abbastanza sicura.<page>[UNI00c8] giunto il momento di uscire."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"[UNI00c8] un bene che tu stia sempre\nad armeggiare con le macchine,\nma mi chiedo quanto forte tu sia."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Combattere significa velocit[UNI00e0]\ne lavoro di gambe.<page>Se sei pi[UNI00f9] lento di me,\nnon va affatto bene."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Facciamo una prova! Corri alla\nbarca sul lago e torna indietro.<page>Il mio record [UNI00e8] 2 minuti e\n1 secondo. Se non lo superi,\nnon va affatto bene."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetQuestEtc(0, 9, 1)
	event.MesMake_2(0, "Che ne dici, vuoi provare?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	helper_149f0(arg0, arg1)
	if vm.skipping() then
		return skip(8)
	end
end

--- Helper function.
local function helper_15668(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_149f0(arg0, arg1)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				helper_149f0(arg0, arg1)
			end
			return
		end
		if at <= 9 then
			if at <= 7 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 8 then
				helper_149f0(arg0, arg1)
			end
			return
		end
		if at <= 13 then
			if at <= 10 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 11 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 12 then
				helper_149f0(arg0, arg1)
			end
			return
		end
		if at <= 14 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_11b80()
		end
	end
	do
		local out1, out2, out3, out4 = event.Stopwatch_5(1)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
		var5 = out4 or var5
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var6 = event.GetCnt(7) or var6
	if var6 == 0 then
		event.MesMake_2(0, "Ehi, Max.\nVieni a provarci di nuovo?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		helper_149f0(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var6 == 1 then
		event.MesMake_2(0, "Ohi! Non sei arrivato alla barca,\nvero? Hai cercato di fregarmi.\nNon imbrogliare!")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(0, "Vuoi provare di nuovo?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		helper_149f0(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if var2 < 0 then
		event.MesMake_2(0, "Ehi, niente scherzi!")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.MesMake_2(0, "Vuoi provare di nuovo?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		helper_149f0(arg0, arg1)
		if vm.skipping() then
			return skip(9)
		end
		return
	end
	event.MesMake_2(0, "Oh, sei tornato!\nBene,<page>Controlliamo\nil tuo tempo!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesValue(0, 1, var2)
	event.SetMesValue(0, 2, var3)
	event.SetMesValue(0, 3, var4)
	if var5 == 0 then
		event.MesMake_2(0, "Oh mio Dio!\n[数値１] minuti [数値２].[数値３] secondi [UNI00e8]\ntroppo.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.MesMake_2(0, "Vuoi provare di nuovo?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(12)
		end
		helper_149f0(arg0, arg1)
		if vm.skipping() then
			return skip(13)
		end
		return
	end
	event.MesMake_2(0, "Oh!\n[数値１] minuti [数値２] secondi [数値３]\nnon [UNI00e8] niente male!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "Sei pi[UNI00f9] veloce di quanto sembra.\nOK, combattiamo i cattivi insieme!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.SetMotion(arg0, "立ち")
	helper_11b80()
	if vm.skipping() then
		return skip(16)
	end
	event.Finish()
	event.SetQuestEtc(1, 9, 1)
end

--- Helper function.
local function helper_16298(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Sei molto pi[UNI00f9] veloce\ndi quanto pensassi.\nMi hai sorpreso!")
	else
		event.MesMake_2(0, "Se posso aiutarti in qualche\nmodo, non esitare a chiedere.")
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_164d0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_142d8(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_142d8(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_14550(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	do
		local out1, _, out3 = event.GetCharaPos(arg0)
		var4 = out1 or var4
		var6 = out3 or var6
	end
	if var4 < 1182.0 or 1183.0 < var4 or var6 < 210.0 or 211.0 < var6 then
		print("kokokokokokokokokoko\n")
		helper_146e0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 9) or var3
	if var3 == 0 then
		helper_14f84(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 1 then
		helper_15668(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if var3 == 2 then
		helper_16298(arg0, arg1)
		if vm.skipping() then
			return skip(7)
		end
		return
	end
end

--- Helper function.
local function helper_25164(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eb131214(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Mi hai visto al circo?\nNiente male, vero?<page>Per me [UNI00e8] un hobby,\npi[UNI00f9] che un lavoro."
		)
	else
		event.MesMake_2(0, "Allora, novit[UNI00e0]? Hai gi[UNI00e0] incontrato\nqualche osso duro nella miniera?")
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_253dc(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Il mio negozio [UNI00e8] specializzato\nin lame.<page>Ho delle armi da fuoco,\nma in realt[UNI00e0] non sono\naffatto il mio genere."
	)
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2557c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_e297c86b(44, 1)
		end
		if at <= 6 then
			helper_b1ca721b(1)
		end
		if at <= 7 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Tu sei Monica,\ngiusto?<page>Ho sentito dire che\nnon sei niente male con la spada.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Ma le spade non sono\ngiocattoli, lo sai.<page>Devi pensare a\ncosa hai davanti.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Se potenzi una spada di 2 livelli,\nmi convincer[UNI00f2] del tuo talento!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Perch[UNI00e9] non cominci\ncon il Gladio?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(44)
	helper_e297c86b(44, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_b1ca721b(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "[(!)]Se vuoi farti accettare da\n   Milane, dovrai potenziare il\n   Gladio di 2 livelli.")
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]Puoi anche comprare o trovare le armi.\n   L'importante [UNI00e8] procurarsene di\n   potenti, cos[UNI00ec] Milane ti aiuter[UNI00e0]."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 10, 1)
end

--- Helper function.
local function helper_25d30(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_11b80()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	argc = event.GetItemNum(67) or argc
	argc_2 = event.GetItemNum(69) or argc_2
	if argc <= 0 and argc_2 <= 0 then
		event.MesMake_2(
			0,
			"Che razza di spada [UNI00e8] quella?\nMa allora erano solo chiacchiere?<page>Vattene!\nPerdo solo tempo con te."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Wow, una spada\ndavvero impressionante!<page>Scusa se ti ho\nmesso alla prova.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Combattere con un principiante\n[UNI00e8] pericoloso anche per me.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Ma immagino di non dovermi\npreoccupare di questo con te.<page>Bene, andiamo\na combattere!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	helper_11b80()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 10, 1)
end

--- Helper function.
local function helper_263ac(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Il bagliore di una spada\nben fatta [UNI00e8] cos[UNI00ec] accecante!<page>Ti toglie il fiato!"
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Come si pu[UNI00f2] essere felici\nlucidando pietre?")
	else
		event.MesMake_2(0, "Allora, novit[UNI00e0]? Hai gi[UNI00e0] incontrato\nqualche osso duro nella miniera?")
	end
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_26774(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_25164(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		helper_25164(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_253dc(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_2557c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_25d30(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_263ac(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_26b00(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eb131214(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Sei un'amica di Max?<page>Bene, attenta a quello che fai.")
	else
		event.MesMake_2(
			0,
			"D'ora in poi aiuter[UNI00f2] Need e Cedric\na ricostruire il mondo. Dobbiamo\ntutti darci da fare."
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_26d58(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Sei in gamba con le macchine,\nma non credi sia giunto il momento\nd'imparare qualcosa sulle miniere?"
	)
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_26ed8(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_e297c86b(24, 1)
		end
		if at <= 6 then
			helper_b1ca721b(1)
		end
		if at <= 7 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Secondo Cedric,\nhai combinato\nqualcosa di recente.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Sai fare un sacco di cose,<page>ma, a quanto pare, non\nconcludi molto.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Quindi, quando chiedi aiuto,\nper me [UNI00e8] difficile prenderti\nveramente sul serio.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Prova a potenziare questa Pistola-\ntrombetta in Pistola-campana?<page>Pensi di potercela fare?"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(24)
	helper_e297c86b(24, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_b1ca721b(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Per farti accettare da\n   Gerald, devi portargli\n   una Pistola-campana.<page>[(!)]Puoi potenziare la tua arma,\n   comprarne una o\n   recuperarne una nei labirinti."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 11, 1)
end

--- Helper function.
local function helper_275dc(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_11b80()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	argc = event.GetItemNum(25) or argc
	if argc <= 0 then
		event.MesMake_2(
			0,
			"Che c'[UNI00e8] che non va?\nTi arrendi di nuovo?<page>Mi deludi!\n[UNI00c8] questo che succede ad armeggiare\ntroppo con le macchine?"
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"Oh! Sembra che tu sia diventato\nbravo anche con le armi!<page>Non serve guardarti sparare:\nsi vede gi[UNI00e0] da come la tieni."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"OK, ti aiuter[UNI00f2].\nMa non lo faccio per te.<page>Se questa citt[UNI00e0] [UNI00e8] in pericolo,\nnon posso stare con\nle mani in mano."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11b80()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 11, 1)
end

--- Helper function.
local function helper_27b5c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Le armi non sono giocattoli.<page>Attento a come le usi o\nrischi di farti male.")
	else
		event.MesMake_2(
			0,
			"D'ora in poi aiuter[UNI00f2] Need e Cedric\na ricostruire il mondo. Dobbiamo\ntutti darci da fare."
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_27dd4(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_26b00(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_26b00(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_26d58(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_26ed8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_275dc(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_27b5c(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_28160(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2056b079(arg0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Mpfffff...")
	helper_2056b079(arg0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "...1212,<page>No, no, era proprio 1122.<page>O forse 1010...")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Mpfffff...")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		'[(!)]Se non ti ha neppure sentito\n   dire "Salve." allora deve\n   avere dei problemi seri.<page>[(!)]Perch[UNI00e9] non provi pi[UNI00f9] tardi?\n   Potresti dargli una mano, o\n   un orecchio o qualcos\'altro.'
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
end

--- Helper function.
local function helper_285b0(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_187f0d3d(arg0, arg1)
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_187f0d3d(arg1, arg0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Mpfffff...")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Che vuoi dire con\n'cosa sto blaterando'?<page>Sto tentando di ricordare\nla combinazione della cassaforte."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Come sarebbe\n'quale cassaforte'?<page>La cassaforte nascosta dietro\nil quadro nel mio ufficio, no?"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	helper_187f0d3d(arg0, arg1)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(
		0,
		"Ah, mi hai messo una paura!<page>Oh, maledizione!<page>Mi son lasciato scappare il\nmio segreto pi[UNI00f9] grande!<page>Oh bene, ora lo sai.<page>Forse puoi darmi una mano\na risolvere il problema."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "Ho un grosso problema:\nnon riesco a ricordare\nla combinazione della cassaforte.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"[UNI00c8] un numero a 4 cifre. Ho usato\nla data di nascita di Claire,\nconvinto di ricordarmela sempre."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "Come posso essermela dimenticata?<page>Che padre snaturato sono!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Pare che il Sindaco sia nei guai.\n   Ascolta cosa dice del compleanno\n   di Claire e scopri la combinazione."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 12, 1)
end

--- Helper function.
local function helper_28f80(arg0: s32, arg1: s32)
	local var2: any = 0
	local var3: s32 = 0
	local var7: s32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 6 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 7 then
				var2 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 9 then
			return
		end
		if at <= 13 then
			if at <= 10 then
				helper_0c95681b(30)
			end
			if at <= 11 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 12 then
				helper_0c95681b(15)
			end
			return
		end
		if at <= 14 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_2ddedb3b(0)
		end
		if at <= 16 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_0c95681b(15)
		end
		if at <= 18 then
			helper_0c95681b(15)
		end
		if at <= 19 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 20 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 21 then
			helper_11b80()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	while true do
		event.MesMake_2(0, "Tempo fa, le regalai una spilla\ncon il suo segno zodiacale.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"Holly se ne era occupata per me.\nNon ricordo bene, ma son certo\nche fosse un animale a 4 zampe..."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"Che regali le ho fatto?<page>Mmh... molte giacche\ne sciarpe, credo.<page>Non so mai cosa prenderle.\nOgni anno [UNI00e8] una tragedia!"
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(
			0,
			"Il compleanno di Claire [UNI00e8] sempre un\ndramma! [UNI00c8] il giorno in cui c’[UNI00e8] la\nraccolta dei rifiuti combustibili e non.<page>A casa nostra [UNI00e8] compito mio\nportar fuori la spazzatura."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.MesMake_2(
			0,
			"I rifiuti non combustibili vengono\nraccolti i giorni divisibili per 7<page>e quelli combustibili\nnei giorni divisibili per 3."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.MesMake_2(0, "Ma tu non lo scorderesti,\nvero?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.SetMotion(arg0, "立ち")
		event.MesMake_2(
			0,
			"Trovato! Mistero svelato!\nLa combinazione [UNI00e8]...<page>Non so... Stiamo ad ascoltare..."
		)
		var2 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(8)
		end
		if var2 == 0 then
			break
		else
			if var2 == -1 then
				event.Finish()
				return
			end
			event.SetMotion(arg0, "会話")
		end
	end
	event.SetMenuEtc(0, "Inserisci il codice segreto.", "2112", 0)
	event.GotoMenu(5)
	if vm.wait() then
		return skip(9)
	end
	event.SetFadeIn(15)
	do
		local out1, _, _, _ = event.GetMenuParam_4()
		var3 = out1 or var3
	end
	if var3 == -1 then
		event.Finish()
		return
	end
	event.SetFadeOut(15)
	helper_0c95681b(15)
	if vm.skipping() then
		return skip(10)
	end
	var7 = event.GetSndId(2) or var7
	do
		local out1, out2, out3 = event.GetCharaPos(arg0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = event.GetCharaRot(arg0)
		var11 = out1 or var11
		var12 = out2 or var12
		var13 = out3 or var13
	end
	event.SetCharaPos(arg0, -100.0, 0.0, -110.0)
	event.SetCharaRot(arg0, 0.0, 3.1415927, 0.0)
	event.SetMotion(arg0, "立ち")
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = event.GetCharaRot(0)
		var17 = out1 or var17
		var18 = out2 or var18
		var19 = out3 or var19
	end
	var20 = event.Atan2f(-100.0 - var14, -110.0 - var16) or var20
	event.SetCharaRot(0, 0.0, var20, 0.0)
	event.SetMotion(0, "立ち")
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.GetCameraRef()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	event.SetCameraPos(64.64, 46.9, 92.64)
	event.SetCameraRef(-100.0, 20.0, -110.0)
	event.SetFadeIn(15)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(11)
	end
	if var3 == 0 then
		event.SetMotion(arg0, "会話")
		event.MesMake_2(0, "Mmh, non si apre. Oh cielo...<page>Ci sono documenti\nimportanti l[UNI00ec] dentro...")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(12)
		end
		event.SetMotion(arg0, "立ち")
		event.SetFadeOut(15)
		helper_0c95681b(15)
		if vm.skipping() then
			return skip(13)
		end
		event.SetCharaRot(0, var17, var18, var19)
		event.SetCharaPos(arg0, var8, var9, var10)
		event.SetCharaRot(arg0, var11, var12, var13)
		event.SetCameraPos(pos_x, pos_y, pos_z)
		event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
		event.SetFadeIn(15)
		event.Finish()
		return
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(0, "Er...Mmh...\n2,<page>1,<page>1,<page>2...")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.SetMotion(arg0, "立ち")
	event.SndSePlay(var7, 66)
	event.MesMake_2(0, "Evviva!<page>Grandioso,\nfunziona!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.EohSyncChara(0, arg0)
	event.ObjsInit(0, arg0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsReference(0, var14, var15, var16, 30)
	helper_2ddedb3b(0)
	if vm.skipping() then
		return skip(16)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(0, "Bene! Ora posso prendere\ni miei documenti importanti!<page>Oh, grazie!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	event.SetFadeOut(15)
	helper_0c95681b(15)
	if vm.skipping() then
		return skip(18)
	end
	event.SetCharaRot(0, var17, var18, var19)
	event.SetCharaPos(arg0, var8, var9, var10)
	event.SetCharaRot(arg0, var11, var12, var13)
	event.SetCameraPos(pos_x, pos_y, pos_z)
	event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
	event.SetFadeIn(15)
	helper_0c95681b(15)
	if vm.skipping() then
		return skip(19)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(
		0,
		"Quali documenti importanti?<page>Serviranno al Vicesindaco Morton\nper sostituirmi quando sar[UNI00f2] via.<page>Sono un po’ in pensiero,\nma sento che andr[UNI00e0] tutto bene."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(20)
	end
	event.MesMake_2(
		0,
		"Sono pronto anch’io a lasciare la<page>citt[UNI00e0]. Cedric mi ha detto tutto.<page>Forza, andiamo."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(21)
	end
	event.SetMotion(arg0, "立ち")
	helper_11b80()
	if vm.skipping() then
		return skip(22)
	end
	event.Finish()
	event.SetQuestEtc(1, 12, 1)
end

--- Helper function.
local function helper_2aed0(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Differenzia sempre i rifiuti e\nportali fuori nei giorni giusti!")
	else
		event.MesMake_2(
			0,
			"Detto tra noi, [UNI00e8] bene che tu\nsappia che la Miniera di Zelmite [UNI00e8]\npericolosa. Non fare sciocchezze."
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2b148(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_28160(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_28160(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_285b0(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_28f80(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2aed0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2be04(arg0: s32, arg1: any, arg2: s32)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eb131214(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var3 = event.GetChapter() or var3
	if arg2 ~= 0 and var3 == 8 then
		event.MesMake_2(0, "Prego che ci sia sempre\nla pace nel mondo.")
	else
		event.MesMake_2(0, "Se combatti per una giusta causa,\ndevi possedere la saggezza.")
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2c050(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Davvero? Hai bisogno di una mano?<page>Lascia che ti ponga un quesito.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Le candele nella chiesa sono\ngestite da un piccolo meccanismo.<page>Se sono accese le spegne\ne se sono spente le accende.<page>Se una di loro cambia,\nanche le candele accanto cambiano."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Se sarai cos[UNI00ec] saggio da spegnere\ntutte le candele, verr[UNI00f2] con te.<page>Se ci riesci, bene! Senn[UNI00f2], cerca\ndi capire: non posso aiutarti!"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Ecco un altro enigma. Fai\n   qualche tentativo e sfrutta\n   quel che apprendi ogni volta."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[(!)]Se rientri in chiesa, le\n   candele tornano come prima.\n   Quindi non temere, se sbagli.\n   La risposta [UNI00e8] semplice."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 13, 1)
end

--- Helper function.
local function helper_2b42c()
	local var0: { s32 } = table.create(14, 0)
	local var14: s32 = 0
	local var15: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var14 = 0
		var15 = 0
		var14 = var14 + 1
		var15 = var15 + 1
		return var14
	end
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m7")
	event.EohSyncObj(1, "p08_i01h07", "i01h07_13-m21")
	event.EohSyncObj(2, "p08_i01h07", "i01h07_13-m8")
	event.EohSyncObj(3, "p08_i01h07", "i01h07_13-m20")
	event.EohSyncObj(4, "p08_i01h07", "i01h07_13-m9")
	event.EohSyncObj(5, "p08_i01h07", "i01h07_13-m19")
	event.EohSyncObj(6, "p08_i01h07", "i01h07_13-m10")
	event.EohSyncObj(7, "p08_i01h07", "i01h07_13-m18")
	event.EohSyncObj(8, "p08_i01h07", "i01h07_13-m11")
	event.EohSyncObj(9, "p08_i01h07", "i01h07_13-m17")
	event.EohSyncObj(10, "p08_i01h07", "i01h07_13-m12")
	event.EohSyncObj(11, "p08_i01h07", "i01h07_13-m16")
	event.EohSyncObj(12, "p08_i01h07", "i01h07_13-m14")
	event.EohSyncObj(13, "p08_i01h07", "i01h07_13-m15")
	var0[1] = event.EohGetShow(0) or var0[1]
	var0[2] = event.EohGetShow(1) or var0[2]
	var0[3] = event.EohGetShow(2) or var0[3]
	var0[4] = event.EohGetShow(3) or var0[4]
	var0[5] = event.EohGetShow(4) or var0[5]
	var0[6] = event.EohGetShow(5) or var0[6]
	var0[7] = event.EohGetShow(6) or var0[7]
	var0[8] = event.EohGetShow(7) or var0[8]
	var0[9] = event.EohGetShow(8) or var0[9]
	var0[10] = event.EohGetShow(9) or var0[10]
	var0[11] = event.EohGetShow(10) or var0[11]
	var0[12] = event.EohGetShow(11) or var0[12]
	var0[13] = event.EohGetShow(12) or var0[13]
	var0[14] = event.EohGetShow(13) or var0[14]
	var14 = 0
	var15 = 0
	while var15 < 14 do
		if var0[var15 + 1] ~= 0 then
			var14 = vm.i32(var14 + 1)
		end
		var15 = var15 + 1
	end
	return var14
end

--- Helper function.
local function helper_2c78c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				var2 = helper_2b42c()
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_11b80()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = helper_2b42c()
	if 0 < var2 then
		event.MesMake_2(0, "Sembra che tu non sia\nancora abbastanza bravo.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Nutro molte speranze per te nel\nfuturo, ma al momento, purtroppo,\nnon posso aiutarti.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"Ben fatto.\nMagnifico.<page>Sono certo che\nnon mi deluderai.<page>Te lo avevo promesso, no?\nVerr[UNI00f2] con te."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11b80()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 13, 1)
end

--- Helper function.
local function helper_2cc6c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2be04(arg0, arg1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2cd04(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2be04(arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_2be04(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_2c050(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2c78c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2cc6c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2cff4(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eb131214(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Perch[UNI00e9] mi manca tanto la luna?<page>Magari [UNI00e8] da l[UNI00ec] che\nvengo...")
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2d164(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "S[UNI00ec], venire con te non mi dispiace,\nma ci sar[UNI00e0] una luna l[UNI00e0]?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Davvero? Magari lo dici cos[UNI00ec] per\ndire. Gli Umani sono bugiardi!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Veramente, ho cambiato idea.\nAspetter[UNI00f2] qui che la luna sorga.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "[(!)]Sar[UNI00e0] per qualcosa accaduto\n   in passato, ma Rufio non\n   crede agli Umani.")
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[(!)]Devi far s[UNI00ec] che Rufio ti creda.\n   Se gli dessi una foto della\n   luna, forse lo farebbe."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 14, 1)
end

--- Helper function.
local function helper_2d7c0(arg0: s32, arg1: s32)
	local photo: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_11b80()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	photo = event.CheckInventPhoto(193) or photo
	if photo <= 0 then
		event.MesMake_2(
			0,
			"Pensavo tu fossi diverso,\ninvece no: gli Umani sono Umani.<page>Non importa. Ci sono abituato\na voi Umani: dite sempre bugie."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Fantastico! [UNI00c8] una foto della luna!<page>Ora potr[UNI00f2] portarla sempre con me!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Venire con te?<page>Certo!\nNon saprei dove altro andare!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11b80()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 14, 1)
end

--- Helper function.
local function helper_2dcc0(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Mi hai dato la foto della luna.\nSei un bravo Umano.")
	else
		event.MesMake_2(
			0,
			"Se la Ferrovia Carbonero viagger[UNI00e0]\nper tutto il mondo, potremo\nvisitare un sacco di bei posti."
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2df18(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2cff4(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_2cff4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_2d164(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2d7c0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2dcc0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2e1fc(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eb131214(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Il mio hobby [UNI00e8] la pesca.<page>Vorrei prendere un Mardan Karayan!<page>Rispetto solo chi cattura pesci grossi."
	)
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2e38c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Vuoi che ti faccia un favore?<page>Ascoltami bene prima.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Ascolto solo quelli che rispetto.<page>E rispetto solo chi riesce a\nprendere pesci pi[UNI00f9] grossi di me."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Il pesce pi[UNI00f9] grande che ho preso\n[UNI00e8] stato un Nonky di 60 cm.<page>Sei sorpreso, eh?\nSe te la senti di sfidarmi,\nper me, quando vuoi!"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Sembra che l'unico modo di averlo\n   dalla tua sia pescare un Nonky\n   di pi[UNI00f9] di 60 cm. Dai, puoi farcela!"
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "[(!)]Comunque, prova un po' a pescare\n   nel lago di Vallecatini.")
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 15, 1)
end

--- Helper function.
local function helper_2ea38(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			if at <= 3 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_11b80()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.ExtTyped(564, "iiF", 2, 322) or var2
	if var2 <= 0 then
		event.MesMake_2(
			0,
			"Ehi, scommetto che non hai\nmai preso un Nonky per davvero!<page>Ah ah ah! Fai pena\ncome pescatore!"
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 < vm.f32(0.6) then
		var3 = vm.ftoi(vm.f32(var2 * 100.0))
		event.SetMesValue(0, 1, var3)
		event.MesMake_2(0, "Ah ah ah! Hai preso\nun pescetto di [数値１] cm!")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Non sei degno del mio aiuto!<page>Ricomincia pure da capo!")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "...Oh, ti avevo sottovalutato.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Non mi rimanger[UNI00f2] la parola data:<page>ti ascolter[UNI00f2], come avevo promesso.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "Parla quanto vuoi!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_11b80()
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(1, 15, 1)
end

--- Helper function.
local function helper_2f270(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Um, magari non subito, per[UNI00f2] un\ngiorno potresti svelarmi\ni tuoi trucchetti di pesca!"
		)
	else
		event.MesMake_2(
			0,
			"Non vedo l'ora di scovare i luoghi\nmigliori per pescare in giro\nper il mondo. Sar[UNI00e0] divertente!"
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2f4f8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2e1fc(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_2e1fc(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_2e38c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2ea38(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2f270(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2f7dc(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eb131214(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "I Firbit concedono\nfavori solo a chi [UNI00e8]\npi[UNI00f9] in gamba di loro.")
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2f93c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "I Firbit concedono\nfavori solo a chi [UNI00e8]\npi[UNI00f9] in gamba di loro.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "So il fatto mio quando\nsi tratta di pesci.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Ho sentito dire che gli Umani\norganizzano un evento in cui\nfanno competere i loro pesci.<page>Se hai un pesce, perch[UNI00e9]\nnon cerchi di arrivare primo?<page>Se ci riesci, sapr[UNI00f2]\nche sei degno del mio aiuto."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Sembra che parli della Corsa dei\n   Pesci. Prova a vincere la Categoria\n   Principianti! Poi forse ti aiuter[UNI00e0]."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 16, 1)
end

--- Helper function.
local function helper_2ff38(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_11b80()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(41) or flag
	if flag == 0 then
		event.MesMake_2(0, "Un pesce rispecchia il padrone.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Non parler[UNI00f2] mai col padrone \ndi un pesce tanto imbranato!")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"Stavo guardando, sai.\n[UNI00c8] stata una bella corsa.<page>Non avrei mai potuto allevare\nun pesce simile!<page>Ti prego, portami con te.\nTi prego, insegnami quel che sai!"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11b80()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 16, 1)
end

--- Helper function.
local function helper_3042c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Spero che un giorno salir[UNI00f2] anch'io\nsul podio del vincitore.")
	else
		event.MesMake_2(0, "Vorrei solo che Fabio\ns'interessasse a qualcos'altro,\noltre che alla pesca.")
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_30674(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2f7dc(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	flag = event.GetFlag(424) or flag
	if var2 ~= 2 or flag == 0 then
		helper_2f7dc(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 16) or var2
	if var2 == 0 then
		helper_2f93c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2ff38(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_3042c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_309b8(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0d70bce8(arg0, 0, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Ultimamente, non mi sento in forma.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Ho chiesto al Dottor Dell di\nvisitarmi, ma dice che sto bene.<page>Strano, eh?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_30c68(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_85ab2618(0, -1, arg1, arg0, 0)
			end
			return
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg1, arg0, 0)
		end
		if at <= 6 then
			helper_85ab2618(0, -1, arg1, arg0, 0)
		end
		if at <= 7 then
			helper_85ab2618(0, -1, arg1, arg0, 0)
		end
		if at <= 8 then
			helper_85ab2618(0, -1, arg1, arg0, 0)
		end
		if at <= 9 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Ultimamente, non mi sento in forma.<page>Non mi va di fare un viaggio.<page>Ho chiesto al Dottor Dell di\nvisitarmi, ma dice che sto bene."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Anche solo stare in piedi mi\nfa venire le vertigini.<page>[UNI00c8] difficile da spiegare. [UNI00c8] come\nse il mondo fosse deformato."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(0, "Mmh... se il Dottor Dell\nnon capisce di che si tratta,\nallora io non posso fare molto...")
		helper_85ab2618(0, -1, arg1, arg0, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.Finish()
		return
	end
	event.MesMake_2(0, "Ricordo quei sintomi.")
	helper_85ab2618(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Quando sono nata, il mondo\nera in pessimo stato, con molte\npi[UNI00f9] distorsioni temporali\ndi quanto voi possiate immaginare."
	)
	helper_85ab2618(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Di questo ne risentivano le\npersone pi[UNI00f9] deboli e fragili.<page>I pi[UNI00f9] esili lamentavano vertigini,\ni pi[UNI00f9] grossi non si reggevano in piedi."
	)
	helper_85ab2618(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Forse sei troppo sensibile\na questo genere di cose.<page>Senti persino le poche distorsioni\ntemporali che abbiamo qui!"
	)
	helper_85ab2618(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "Se eliminassimo le distorsioni pi[UNI00f9]\nvicine, forse staresti meglio.")
	helper_85ab2618(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMotion(arg1, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Eliminare distorsioni temporali, Spheda!\n   Se completi circa 10 livelli,\n   forse Mena star[UNI00e0] meglio."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	var3 = event.GetMenuEtc_2(0) or var3
	event.SetCnt(19, var3)
	event.SetQuestEtc(0, 17, 1)
end

--- Helper function.
local function helper_31854(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				print("start=", var3, ",now=", var2, ",clear=", var2 - var3, "\n")
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_11b80()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetMenuEtc_2(0) or var2
	var3 = event.GetCnt(19) or var3
	print("start=", var3, ",now=", var2, ",clear=", vm.i32(var2 - var3), "\n")
	if vm.i32(var2 - var3) < 10 then
		event.MesMake_2(0, "Ancora non mi sento bene.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"Sar[UNI00e0] qualcosa\ndi grave?<page>Forse neppure il Dottor Dell\npu[UNI00f2] aiutarmi ormai..."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Salve!<page>Come mi sento? Benissimo!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "[UNI00c8] incredibile, sto molto meglio.<page>Il mondo [UNI00e8] tornato a posto.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Oh s[UNI00ec], volevate un favore...<page>Far[UNI00f2] il possibile per aiutarvi.<page>Voi mi avete aiutato,\nquindi io aiuter[UNI00f2] voi."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_11b80()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 17, 1)
end

--- Helper function.
local function helper_31fb4(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Ricambier[UNI00f2] il vostro aiuto ma non\nportatemi dove ci sono insetti!")
	else
		event.MesMake_2(
			0,
			"Se la Ferrovia Carbonero si\nespander[UNI00e0] in tutto il mondo, forse\npotr[UNI00f2] girare il mondo anch'io."
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_3222c(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_309b8(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(314) or flag
	if flag == 0 then
		helper_309b8(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_30c68(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_31854(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_31fb4(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_324f8(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0d70bce8(arg0, 0, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(0, "Oh, Max! Ho sentito dire che\nsei stato fuori citt[UNI00e0] ultimamente.")
	else
		event.MesMake_2(0, "Ooh, Monica! Ho sentito dire che\nsei stata fuori citt[UNI00e0] ultimamente.")
	end
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Grandioso! Perch[UNI00e9] non\nmi porti con te?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_328a0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				var3 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 6 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 7 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 9 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 10 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 11 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 12 then
			helper_0c95681b(30)
		end
		if at <= 13 then
			helper_0c95681b(30)
		end
		if at <= 14 then
			helper_0c95681b(60)
		end
		if at <= 15 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(0, "Oh, Max! Ho sentito dire che\nsei stato fuori citt[UNI00e0] ultimamente.")
	else
		event.MesMake_2(0, "Ooh, Monica! Ho sentito dire che\nsei stata fuori citt[UNI00e0] ultimamente.")
	end
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Grandioso! Perch[UNI00e9] non\nmi porti con te?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Scommetto che mi reputi inutile\nsolo perch[UNI00e9] sono una ragazza.<page>Ma in realt[UNI00e0], porto alla gente\nun sacco di fortuna!"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Quando esco non piove mai\ne non ho mai perso\nalla lotteria!<page>Che ne pensi?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "OK allora.\nNo, mi spiace.")
	var3 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "会話")
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var3 ~= 0 then
		event.MesMake_2(0, "Perch[UNI00e9]? Non essere crudele!\nSei orribile!")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.MesMake_2(0, "Incapace!<page>Demente!<page>Idiota!")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Mi porterai con te?<page>Non credevo lo avresti fatto!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"Come mai devo chiedertelo io,\nmentre tu non fai che chiederlo\na tutti gli altri? <page>Se solo me l’avessi chiesto,\nti avrei aiutato subito."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(0, "Allora, se riesci a trovarmi,\nti aiuter[UNI00f2]. Che ne pensi?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(0, "Cio[UNI00e8]... giochiamo a nascondino!<page>Pronti, via!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.SetMotion(arg0, "立ち")
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(13)
	end
	event.SetFadeOut(30)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(14)
	end
	event.SetAi(1, arg0)
	event.CharaActive(0, arg0)
	event.DeleteVillager(arg0)
	event.SetFadeIn(30)
	helper_0c95681b(60)
	if vm.skipping() then
		return skip(15)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Oh bene... Forse faresti meglio a\n   trovare Corinne. Si sar[UNI00e0] nascosta\n   da qualche parte a Vallecatini."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 18, 1)
	event.SetCnt(11, 0)
end

--- Helper function.
local function helper_33990(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_0c95681b(30)
			end
			return
		end
		if at <= 4 then
			helper_11b80()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(11) or var2
	if var2 < 1 then
		event.MesMake_2(0, "Oh! Mi hai trovato!<page>Riesci a trovarmi un'altra volta?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		event.SetCnt(11, var2 + 1)
		event.SetFadeOut(30)
		helper_0c95681b(30)
		if vm.skipping() then
			return skip(3)
		end
		event.SetAi(1, arg0)
		event.CharaActive(0, arg0)
		event.DeleteVillager(arg0)
		event.SetFadeIn(30)
		return
	end
	event.MesMake_2(
		0,
		"Oh! Mi hai trovato...<page>Sto cominciando a stufarmi ora.<page>Nascondersi [UNI00e8]\ndavvero noioso!<page>Oh bene! Allora, partiamo\nper la nostra avventura!"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11b80()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 18, 1)
end

--- Helper function.
local function helper_33f08(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Nascondino [UNI00e8] un\ngioco da bambini.")
	else
		event.MesMake_2(
			0,
			"Non mi freghi! Lo so che sei\nstato in giro a divertirti. Quando\nhai tempo, raccontami tutto!"
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_34150(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_324f8(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_324f8(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_328a0(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_33990(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_33f08(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_34434(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eb131214(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"...<page>Ah! Salve!\nSono un po' sorda, ultimamente.<page>Non riesco a capire cosa dici\nse non parli lentamente."
	)
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_345b4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_11b80()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Che hai detto?<page>Puoi parlare pi[UNI00f9] lentamente?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetQuestEtc(0, 19, 1)
	event.SetMenuEtc(0, 'Scrivi "Andiamo insieme."', "Andiamo insieme.", 0)
	event.GotoMenu(5)
	if vm.wait() then
		return skip(3)
	end
	event.SetFadeIn(15)
	do
		local out1, _, _, _ = event.GetMenuParam_4()
		var2 = out1 or var2
	end
	if var2 == -1 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 == 0 then
		event.MesMake_2(0, "Cosa stai blaterando?\nNon capisco...")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Un'avventura?\nSarebbe carino.<page>Ma a cosa pu[UNI00f2] servirti\nuna vecchia come me?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	helper_11b80()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 19, 1)
end

--- Helper function.
local function helper_34c58(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_345b4(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_34ce4(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "A cosa pu[UNI00f2] servirti una\ndonna anziana come me?")
	else
		event.MesMake_2(
			0,
			'Quando la Ferrovia Carbonero sar[UNI00e0]\nterminata, mi piacerebbe tanto\nandare ai "Confini della Terra".'
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_34f4c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_34434(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_34434(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_345b4(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_34c58(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_34ce4(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_23098(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(12) or var2
	if var2 == 0 then
		event.MesMake_2(0, "Oh, stai\naiutando Polly?<page>Grandioso.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Che me ne faccio\ndi 20 pagnotte?<page>Beh, dar[UNI00f2] un\nfonduta-party oggi!")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			'Per fare un parallelo con le tue famose\n"invenzioni", [UNI00e8] una combo culinaria di<page>formaggio, pane e vino!'
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(
			0,
			"[UNI00c8] buono. Ne mangiano a tonnellate,\nper questo mi serve tanto pane.<page>Ma veramente non volevo che\nmi venisse consegnato qui."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.MesMake_2(
			0,
			"Scusa Max, potresti portarmele\na casa, per favore?<page>Sai dov'[UNI00e8], vero?\nVicino al campo di zucche."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetCnt(12, 1)
	end
	if var2 == 1 then
		event.MesMake_2(0, "Sai dov'[UNI00e8], vero?\nVicino al campo di zucche.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var2 == 2 then
		event.MesMake_2(0, "Niente pi[UNI00f9] party?!\nChe peccato!")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.MesMake_2(0, "In tal caso, il pane non mi serve.\nLo riporteresti a Polly per me?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(9)
		end
		event.SetCnt(12, 3)
	end
	if var2 == 3 then
		event.MesMake_2(0, "Scusa, riporteresti il\npane a Polly per me?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(10)
		end
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_35230(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local now_sub_map_no: s32 = 0
	local flag: s32 = 0
	local var7: any = 0
	local var8: any = 0
	local var9: s32 = 0
	local var10: s32 = 0
	local var11: any = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local var14: any = 0
	local var15: s32 = 0
	local var16: s32 = 0
	local var17: any = 0
	local var18: s32 = 0
	local active_chr_no: s32 = 0
	local var20: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_18908(arg0, arg1)
			end
			if at <= 2 then
				var7 = helper_975658d3(arg0, -1, 2, 0, 0, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				helper_0c95681b(30)
			end
			return
		end
		if at <= 8 then
			if at <= 7 then
				var8 = helper_975658d3(arg0, -1, 2, 0, 0, 0)
			end
			return
		end
		if at <= 11 then
			if at <= 9 then
				helper_0c95681b(30)
			end
			return
		end
		if at <= 17 then
			if at <= 12 then
				helper_1bc88(arg0, arg1)
			end
			if at <= 13 then
				helper_1d740(arg0, arg1)
			end
			if at <= 14 then
				helper_20118(arg0, arg1)
			end
			if at <= 15 then
				helper_22820(arg0, arg1)
			end
			if at <= 16 then
				var11 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 18 then
			return
		end
		if at <= 22 then
			if at <= 19 then
				helper_24dd8(arg0, arg1)
			end
			if at <= 20 then
				helper_164d0(arg0, arg1)
			end
			if at <= 21 then
				var14 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 23 then
			return
		end
		if at <= 28 then
			if at <= 24 then
				helper_26774(arg0, arg1)
			end
			if at <= 25 then
				helper_27dd4(arg0, arg1)
			end
			if at <= 26 then
				helper_2b148(arg0, arg1)
			end
			if at <= 27 then
				var17 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 29 then
			return
		end
		if at <= 38 then
			if at <= 30 then
				helper_2cd04(arg0, arg1)
			end
			if at <= 31 then
				helper_2df18(arg0, arg1)
			end
			if at <= 32 then
				helper_2f4f8(arg0, arg1)
			end
			if at <= 33 then
				helper_30674(arg0, arg1)
			end
			if at <= 34 then
				helper_3222c(arg0, arg1)
			end
			if at <= 35 then
				helper_34150(arg0, arg1)
			end
			if at <= 36 then
				helper_34f4c(arg0, arg1)
			end
			if at <= 37 then
				var20 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 39 then
			return
		end
		if at <= 40 then
			helper_eb131214(arg0, -1, 0, 0)
		end
		if at <= 41 then
			helper_eb131214(arg0, -1, 0, 0)
		end
		if at <= 42 then
			helper_eb131214(arg0, -1, 0, 0)
		end
		if at <= 43 then
			helper_eb131214(arg0, -1, 0, 0)
		end
		if at <= 44 then
			helper_eb131214(arg0, -1, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	event.SetMesShippo(0, 1)
	var2 = event.GetChapter() or var2
	var3 = event.GetEventData_2(14) or var3
	event.GetNowMapNo()
	now_sub_map_no = event.GetNowSubmapNo() or now_sub_map_no
	event.CtrlcStay()
	event.SetAi(0, arg0)
	if var3 == 3 then
		helper_1400c(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
	end
	if var3 == 5 then
		helper_18908(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			event.MesMake_2(0, "Fammi far compere\nIndaga per uno scoop")
			var7 = helper_975658d3(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(3)
			end
			if var7 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var7 == 1 then
				local t0 = helper_110f4(0)
				if vm.skipping() then
					return skip(4)
				end
				if t0 ~= 0 then
					event.SetFadeOut(25)
					helper_0c95681b(30)
					if vm.skipping() then
						return skip(5)
					end
					event.GotoMenu(6, 33)
					if vm.wait() then
						return skip(6)
					end
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_e518()
				if vm.skipping() then
					return skip(7)
				end
			end
		else
			event.MesMake_2(0, "Benvenuto!\nIndaga per uno scoop")
			var8 = helper_975658d3(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			if var8 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var8 == 1 then
				local t1 = helper_110f4(0)
				if vm.skipping() then
					return skip(9)
				end
				if t1 ~= 0 then
					event.SetFadeOut(25)
					helper_0c95681b(30)
					if vm.skipping() then
						return skip(10)
					end
					event.GotoMenu(6, 33)
					if vm.wait() then
						return skip(11)
					end
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_1a3f0(arg0, arg1)
				if vm.skipping() then
					return skip(12)
				end
			end
		end
	end
	if var3 == 7 then
		helper_1bc88(arg0, arg1)
		if vm.skipping() then
			return skip(13)
		end
	end
	if var3 == 8 then
		helper_1d740(arg0, arg1)
		if vm.skipping() then
			return skip(14)
		end
	end
	if var3 == 10 then
		helper_20118(arg0, arg1)
		if vm.skipping() then
			return skip(15)
		end
	end
	if var3 == 11 then
		helper_22820(arg0, arg1)
		if vm.skipping() then
			return skip(16)
		end
	end
	if var3 == 12 then
		var9 = event.GetQuestEtc(0, 0) or var9
		var10 = event.GetQuestEtc(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Salve\nBenvenuto!")
			var11 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(17)
			end
			if var11 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var11 == 1 then
				helper_24dd8(arg0, arg1)
				if vm.skipping() then
					return skip(18)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_e518()
			if vm.skipping() then
				return skip(19)
			end
		else
			helper_24dd8(arg0, arg1)
			if vm.skipping() then
				return skip(20)
			end
		end
	end
	if var3 == 14 then
		helper_164d0(arg0, arg1)
		if vm.skipping() then
			return skip(21)
		end
	end
	if var3 == 15 then
		var12 = event.GetQuestEtc(0, 0) or var12
		var13 = event.GetQuestEtc(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Salve\nBenvenuto!")
			var14 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(22)
			end
			if var14 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var14 == 1 then
				helper_26774(arg0, arg1)
				if vm.skipping() then
					return skip(23)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_e518()
			if vm.skipping() then
				return skip(24)
			end
		else
			helper_26774(arg0, arg1)
			if vm.skipping() then
				return skip(25)
			end
		end
	end
	if var3 == 16 then
		helper_27dd4(arg0, arg1)
		if vm.skipping() then
			return skip(26)
		end
	end
	if var3 == 17 then
		helper_2b148(arg0, arg1)
		if vm.skipping() then
			return skip(27)
		end
	end
	if var3 == 18 then
		var15 = event.GetQuestEtc(0, 0) or var15
		var16 = event.GetQuestEtc(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Salve\nBenvenuto!")
			var17 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(28)
			end
			if var17 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var17 == 1 then
				helper_2cd04(arg0, arg1)
				if vm.skipping() then
					return skip(29)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_e518()
			if vm.skipping() then
				return skip(30)
			end
		else
			helper_2cd04(arg0, arg1)
			if vm.skipping() then
				return skip(31)
			end
		end
	end
	if var3 == 19 then
		helper_2df18(arg0, arg1)
		if vm.skipping() then
			return skip(32)
		end
	end
	if var3 == 20 then
		helper_2f4f8(arg0, arg1)
		if vm.skipping() then
			return skip(33)
		end
	end
	if var3 == 21 then
		helper_30674(arg0, arg1)
		if vm.skipping() then
			return skip(34)
		end
	end
	if var3 == 23 then
		helper_3222c(arg0, arg1)
		if vm.skipping() then
			return skip(35)
		end
	end
	if var3 == 24 then
		helper_34150(arg0, arg1)
		if vm.skipping() then
			return skip(36)
		end
	end
	if var3 == 25 then
		helper_34f4c(arg0, arg1)
		if vm.skipping() then
			return skip(37)
		end
	end
	if var3 == 33 then
		var18 = event.GetQuestEtc(0, 8) or var18
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Fammi far compere\nSalve")
			var20 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(38)
			end
			if var20 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var20 == 1 then
				helper_23098(arg0, arg1)
				if vm.skipping() then
					return skip(39)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		helper_e518()
		if vm.skipping() then
			return skip(40)
		end
	end
	if var3 == 1 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "Ultimamente faccio fatica\na vedere le cose piccole.<page>Mmmh... sto\ninvecchiando...")
		else
			event.MesMake_2(
				0,
				"Vedere la Ferrovia Carbonero\noperativa su tutto il continente\n[UNI00e8] il sogno mio e di Need.<page>Possiamo contare su di te, vero?"
			)
		end
		helper_eb131214(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(41)
		end
	end
	if var3 == 2 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "Se non tengo le mani\ncontinuamente occupate,\nvado fuori di testa!")
		else
			event.MesMake_2(
				0,
				"Se trovano la Zelmite sar[UNI00f2]\nproprio impegnato. Gi[UNI00e0]!\nScavare, scavare e solo scavare!!!"
			)
		end
		helper_eb131214(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(42)
		end
	end
	if var3 == 6 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "Sai, in questi giorni, ho\nle penne piene di pulci:\nprudono terribilmente!")
		else
			event.MesMake_2(0, "Va bene passare il tempo\ncercando Zelmite, ma vedi di\nnon stancarti troppo, ragazzo!")
		end
		helper_eb131214(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(43)
		end
	end
	if var3 == 13 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"Che profumo la polvere da sparo!\nSono nato per questo lavoro!<page>Certo, il mio capo [UNI00e8] un terribile\ncapoccione e all'antica.\nMa... pazienza!"
			)
		else
			event.MesMake_2(0, "Ti piace proprio\nl'avventura, eh?")
		end
		helper_eb131214(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(44)
		end
	end
	if var3 == 22 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "A parte il fatto di essere nata\nda un quadro, non sono differente\nda chiunque altro.")
		else
			event.MesMake_2(0, "Ho un brutto presentimento sulla\nMiniera di Zelmite. Stai all'erta!")
		end
		helper_eb131214(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(45)
		end
	end
	event.SetAi(1, arg0)
end

--- Helper function.
local function helper_f340()
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local active_chr_no: s32 = 0
	local var7: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local active_chr_no_2: s32 = 0
	local active_chr_no_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
				var5 = 2
				var5 = 1
				helper_e518()
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			return
		end
		if at <= 7 then
			return
		end
		if at <= 8 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.GetControlChrid()
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	do
		local out1, out2 = event.GetMesEtc(0, 3, var2)
		var3 = out1 or var3
		var4 = out2 or var4
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		var5 = 2
	else
		var5 = 1
	end
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	if var2 == 1012 or var2 == 1015 or var2 == 1018 then
		helper_e518()
		if vm.skipping() then
			return skip(2)
		end
		event.SetAi(1, var1)
		return
	end
	if var2 == 50 then
		event.MesMake_2(0, "Ehi! Non [UNI00e8] permesso\noltrepassare questo punto.")
		helper_eb131214(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetAi(1, var1)
		return
	end
	var7 = event.GetChapter() or var7
	if var7 == 1 then
		flag = event.GetFlag(9) or flag
		if var2 == 2 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"Dai un'occhiata qui! Difficile\ncredere che un tempo filava\nche era una bellezza, vero?<page>Proprio cos[UNI00ec]... molto tempo fa.<page>Il mio sogno [UNI00e8] di rifarci un bel\nviaggetto! Ecco perch[UNI00e9] cerco\ndi tenerlo in perfetta forma.<page>Cos[UNI00ec], appena possibile,\n"
				)
			else
				event.MesMake_2(
					0,
					"Sai che devi fare esercizio tutti\ni giorni per restare in forma, no?\nLo stesso vale con le macchine."
				)
			end
			helper_eb131214(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(4)
			end
			event.SetAi(1, var1)
			return
		end
		if var2 == 63 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"Ehi salve, Max!\nLa ferrovia non funziona\nda parecchio tempo.<page>Ma io continuo a vigilare\nsulla stazione, tutti i giorni."
				)
			else
				event.MesMake_2(
					0,
					"Il Sindaco si [UNI00e8] finalmente mosso:\nha fatto ripartire i treni.\nMa non sono aperti al pubblico!<page>Cavoli, non vedo l'ora di farci\nsalire gli abitanti della citt[UNI00e0]..."
				)
			end
			helper_eb131214(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(5)
			end
			event.SetAi(1, var1)
			return
		end
		if var2 == 65 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"Ciao, Max. Sapevi che il\ncapostazione [UNI00e8] il mio pap[UNI00e0]?\nSorvegliamo la stazione insieme.<page>Aspettiamo che questa ferrovia\nriprenda a funzionare..."
				)
			else
				event.MesMake_2(
					0,
					"Il treno funziona!\nMa ci vorr[UNI00e0] del tempo prima\nche la stazione torni com'era..."
				)
			end
			helper_eb131214(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(6)
			end
			event.SetAi(1, var1)
			return
		end
	end
	if var7 == 8 then
		flag_2 = event.GetFlag(804) or flag_2
		if var2 == 61 then
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"Sono un ammiratore segreto\ndi Monica da tempo, ma\nnon la vedo da un po'.<page>Per questo non riesco a\nconcentrarmi sul lavoro!"
				)
			else
				active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
				if active_chr_no_2 ~= 1 then
					event.MesMake_2(0, "Ehi, Max!\nSembra che Monica sia tornata.\nNe saranno tutti felici!")
				else
					event.MesMake_2(0, "Monica! Dove sei stata?\nMi sei mancata tanto!")
				end
			end
			helper_eb131214(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetAi(1, var1)
			return
		end
		if var2 == 80 then
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"Avevo appena trovato il coraggio\ndi parlare a Monica normalmente,\nquando [UNI00e8] scomparsa.<page>Dai, Max...\ndimmi dov'[UNI00e8]... ti prego!"
				)
			else
				active_chr_no_3 = event.GetActiveChrNo() or active_chr_no_3
				if active_chr_no_3 ~= 1 then
					event.MesMake_2(0, "Monica [UNI00e8] tornata.\nCom'[UNI00e8] possibile?!?")
				else
					event.MesMake_2(0, "Monica, sei tornata!\nCom'[UNI00e8] possibile?!?")
				end
			end
			helper_eb131214(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			event.SetAi(1, var1)
			return
		end
	end
	event.MesMake_2(0, "Salve.\nTempo stupendo, vero?")
	event.MesMake_2(0, vm.i32(vm.i32(vm.i32(var3 * 10000) + vm.i32(var4 * 10)) + var5))
	helper_eb131214(var1, -1, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetAi(1, var1)
end

--- Helper function.
local function helper_10978()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f340()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_f340()
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_37c08()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_10978()
		end
	end
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	if var0 <= 34 then
		helper_35230(var1, player_chara)
		if vm.skipping() then
			return skip(1)
		end
	else
		helper_10978()
		if vm.skipping() then
			return skip(2)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	event.ResetCamera(1, 0.0, 10.0)
end

--- Program 150.
script[150] = function()
	local now_map_no: s32 = 0
	local now_sub_map_no: s32 = 0
	now_map_no = event.GetNowMapNo() or now_map_no
	now_sub_map_no = event.GetNowSubmapNo() or now_sub_map_no
	print(
		"##########################map_no=",
		now_map_no,
		",submap_no=",
		now_sub_map_no,
		"###########################\n"
	)
end

--- Program 401.
script[401] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_38800(0, 5)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 402.
script[402] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_38800(0, 4)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 403.
script[403] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_38800(0, 3)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 404.
script[404] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_38800(0, 2)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 405.
script[405] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_38800(0, 1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 406.
script[406] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_38800(0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 407.
script[407] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_38800(1, 6)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 408.
script[408] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_38800(1, 5)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 409.
script[409] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_38800(1, 4)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 410.
script[410] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_38800(1, 3)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 411.
script[411] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_38800(1, 2)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 412.
script[412] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_38800(1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 413.
script[413] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_38800(1, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 414.
script[414] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_38800(0, 6)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_37c08()
	if vm.skipping() then
		return skip(1)
	end
end

return script
