--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a45deb91 = require("@lib/event/helper_a45deb91")
local helper_b8950300 = require("@lib/event/helper_b8950300")
local helper_d1353c5b = require("@lib/event/helper_d1353c5b")

--- Helper function.
local function helper_57f324d0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_b8950300(0, -1, arg1, arg0, 0)
			end
			return
		end
		if at <= 5 then
			helper_b8950300(0, -1, arg1, arg0, 0)
		end
		if at <= 6 then
			helper_b8950300(0, -1, arg1, arg0, 0)
		end
		if at <= 7 then
			helper_b8950300(0, -1, arg1, arg0, 0)
		end
		if at <= 8 then
			helper_b8950300(0, -1, arg1, arg0, 0)
		end
		if at <= 9 then
			helper_d1353c5b(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a45deb91(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Mir geht's in letzter Zeit nicht gut.<page>Eine Reise schaffe ich nicht.<page>Dr. Dell war hier und hat mich\nuntersucht, aber er findet nichts."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Aber selbst wenn ich nur stehe,\ndenke ich, ich kippe gleich um.<page>Es ist schwer zu erkl[UNI00e4]ren. Als\nob die Welt verzerrt w[UNI00e4]re."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(
			0,
			"Hmmm ...\nWenn Dr. Dell nicht wei[UNI00df], was los\nist, kann ich auch nichts weiter tun ..."
		)
		helper_b8950300(0, -1, arg1, arg0, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.Finish()
		return
	end
	event.MesMake_2(0, "Ich erkenne die Symptome.")
	helper_b8950300(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"In der Zeit, in der ich geboren\nwurde, ging es der Welt schlecht -\nes gab mehr Zeitverzerrungen\nals du dir vorstellen kannst."
	)
	helper_b8950300(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Das wirkte sich auf schwache\nund gebrechliche Menschen aus.<page>Leichten Menschen wurde schwindlig,\nund schwere konnten\neinfach nicht mehr stehen."
	)
	helper_b8950300(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Vielleicht bist du besonders\nempfindlich f[UNI00fc]r so etwas.<page>Selbst die wenigen Zeit-\nverzerrungen hier wirken auf dich."
	)
	helper_b8950300(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "Wenn wir einige der nahe\ngelegenen Verzerrungen beseitigen,\ngeht's dir vielleicht besser.")
	helper_b8950300(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMotion(arg1, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Zeitverzerrungen beheben ... Spheda!\n   Wenn du etwa 10 Runden schaffst,\n   geht es Mina vielleicht besser."
	)
	helper_d1353c5b(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	var3 = event.GetMenuEtc_2(0) or var3
	event.SetCnt(19, var3)
	event.SetQuestEtc(0, 17, 1)
end

return helper_57f324d0
