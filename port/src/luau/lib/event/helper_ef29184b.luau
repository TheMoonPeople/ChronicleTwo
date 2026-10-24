--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_ae84ddfa = require("@lib/event/helper_ae84ddfa")
local helper_b8f871c8 = require("@lib/event/helper_b8f871c8")

--- Helper function.
local function helper_ef29184b(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ae84ddfa(arg0)
		end
		if at <= 2 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Grummel, grummel ...")
	helper_ae84ddfa(arg0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "... 1212,<page>Nein, nein, es war bestimmt 1122.<page>Oder vielleicht auch 1010.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Grummel, grummel ...")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		'[(!)]Wenn er nicht einmal Notiz\n  von dir nimmt, wenn du "Hallo." sagst, hat er \n   wohl ernsthafte Probleme.<page>[(!)]Versuch\'s doch sp[UNI00e4]ter nochmal.\n   Vielleicht kannst du ihm zur\n   Hand gehen oder ein Ohr leihen.'
	)
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
end

return helper_ef29184b
