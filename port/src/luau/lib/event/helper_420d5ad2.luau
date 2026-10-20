--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4eedff96 = require("@lib/event/helper_4eedff96")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_b8f871c8 = require("@lib/event/helper_b8f871c8")

--- Helper function.
local function helper_420d5ad2(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
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
				helper_635ee3fd(0, -1, arg1, arg0, 0)
			end
			return
		end
		if at <= 5 then
			helper_635ee3fd(0, -1, arg1, arg0, 0)
		end
		if at <= 6 then
			helper_635ee3fd(0, -1, arg1, arg0, 0)
		end
		if at <= 7 then
			helper_635ee3fd(0, -1, arg1, arg0, 0)
		end
		if at <= 8 then
			helper_635ee3fd(0, -1, arg1, arg0, 0)
		end
		if at <= 9 then
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_4eedff96(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Ultimamente, non mi sento in forma.<page>Non mi va di fare un viaggio.<page>Ho chiesto al Dottor Dell di\nvisitarmi, ma dice che sto bene."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Anche solo stare in piedi mi\nfa venire le vertigini.<page>[UNI00c8] difficile da spiegare. [UNI00c8] come\nse il mondo fosse deformato."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(0, "Mmh... se il Dottor Dell\nnon capisce di che si tratta,\nallora io non posso fare molto...")
		helper_635ee3fd(0, -1, arg1, arg0, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.Finish()
		return
	end
	event.MesMake_2(0, "Ricordo quei sintomi.")
	helper_635ee3fd(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Quando sono nata, il mondo\nera in pessimo stato, con molte\npi[UNI00f9] distorsioni temporali\ndi quanto voi possiate immaginare."
	)
	helper_635ee3fd(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Di questo ne risentivano le\npersone pi[UNI00f9] deboli e fragili.<page>I pi[UNI00f9] esili lamentavano vertigini,\ni pi[UNI00f9] grossi non si reggevano in piedi."
	)
	helper_635ee3fd(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Forse sei troppo sensibile\na questo genere di cose.<page>Senti persino le poche distorsioni\ntemporali che abbiamo qui!"
	)
	helper_635ee3fd(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "Se eliminassimo le distorsioni pi[UNI00f9]\nvicine, forse staresti meglio.")
	helper_635ee3fd(0, -1, arg1, arg0, 0)
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
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	var3 = event.GetMenuEtc_2(0) or var3
	event.SetCnt(19, var3)
	event.SetQuestEtc(0, 17, 1)
end

return helper_420d5ad2
