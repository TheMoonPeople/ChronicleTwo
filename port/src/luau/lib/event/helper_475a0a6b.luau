--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_403f0e66 = require("@lib/event/helper_403f0e66")
local helper_b1529437 = require("@lib/event/helper_b1529437")
local helper_c049c42a = require("@lib/event/helper_c049c42a")
local helper_dae2ac4c = require("@lib/event/helper_dae2ac4c")

--- Helper function.
local function helper_475a0a6b(arg0: s32, arg1: s32)
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
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
		if at <= 9 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
		if at <= 10 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_b1529437(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Max, ich muss unbedingt diesem\nBaum helfen.<page>Na ja, und daf[UNI00fc]r brauche\nich ...")
	helper_403f0e66(0, -1, arg0, arg1, 0)
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
		event.MesMake_2(0, "Max, so klappt das nicht.<page>Ich brauche Weihwasser\nvon Priester Bruno.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Ja - das ist es, Max! Jetzt\nkann ich den Baum versorgen!<page>Danke, Max.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Meine Arbeit ist vorerst\nerledigt.<page>Jetzt kann ich dich auf\ndeinem Abenteuer begleiten!<page>Oh, und sag deinem Vater\nnichts von dem Weihwasser, ja?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "Gordon reist jetzt mit.")
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		'[(!)]Seine Fertigkeiten verwendest\n   du [UNI00fc]ber den Statusbefehl unter\n   "Charakter" im Hauptmen[UNI00fc].<page>[(!)]Wenn du weitere Begleiter\n   gewinnst,\n   steigen diese in den Zug.'
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		'[(!)]Sprich jemand im Zug an,\n   um ihn oder sie als drittes\n   Gruppen-Mitglied zu aktivieren.<page>[(!)]Um einen deiner Begleiter in ein\n   Haus zu bewegen, w[UNI00e4]hle im T[UNI00fc]r-\n   Men[UNI00fc] des Hauses "Belegen".'
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(
		0,
		"[(!)]Es gibt bestimmt noch\n   viele, die mit dir kommen wollen.\n   Halte Ausschau nach ihnen!"
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMesPreset(0, 0)
	var4 = event.GetEventData_2(14) or var4
	event.SetNpcStatus(var4, 130)
	event.Finish()
	event.SetQuestEtc(1, 0, 1)
end

return helper_475a0a6b
