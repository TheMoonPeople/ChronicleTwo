--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_b8f871c8 = require("@lib/event/helper_b8f871c8")

--- Helper function.
local function helper_04b07a49(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	event.SetMotion(arg1, "立ち")
	event.MesMake_2(0, "Hmm, dieser Baum ... sieht nicht\ngut aus. Ich muss etwas tun.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "[(!)]Gordon musst du offenbar\n   ansprechen, sonst merkt er nichts.")
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
end

return helper_04b07a49
