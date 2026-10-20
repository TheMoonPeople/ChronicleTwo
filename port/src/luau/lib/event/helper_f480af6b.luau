--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f1049565 = require("@lib/event/helper_f1049565")

--- Helper function.
local function helper_f480af6b(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"T[UNI00fa] me has ayudado, as[UNI00ed] que te debo una,\npero no me lleves a ning[UNI00fa]n sitio donde haya insectos."
		)
	else
		event.MesMake_2(
			0,
			"Si el Ferrocarril Blackstone se extiende\npor todo el mundo, quiz[UNI00e1]\nyo deba recorrer todo el mundo tambi[UNI00e9]n."
		)
	end
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_f480af6b
