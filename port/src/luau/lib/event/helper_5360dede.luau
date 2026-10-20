--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_81ba7dbe = require("@lib/event/helper_81ba7dbe")
local helper_941ed74e = require("@lib/event/helper_941ed74e")
local helper_e5219064 = require("@lib/event/helper_e5219064")

--- Helper function.
local function helper_5360dede(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_81ba7dbe(arg0)
		end
		if at <= 2 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_941ed74e(0, -1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Grumble, grumble...")
	helper_81ba7dbe(arg0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "...1212,<page>No, no, I'm sure it was 1122.<page>Or maybe it was 1010.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Grumble, grumble...")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]If he doesn't even notice you \n   trying to say, \"Hello.\" He must \n   have some pretty serious problems.<page>[(!)]Why don't you try back later?\n   Maybe you could lend him a hand or\n   an ear or something."
	)
	helper_941ed74e(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
end

return helper_5360dede
