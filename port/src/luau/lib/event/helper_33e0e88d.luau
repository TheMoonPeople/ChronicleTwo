--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2f481f12 = require("@lib/event/helper_2f481f12")
local helper_a58ad5bc = require("@lib/event/helper_a58ad5bc")

--- Helper function.
local function helper_33e0e88d()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2f481f12(30)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	var0 = helper_a58ad5bc(2, -1)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		event.SetFadeOut(30)
		helper_2f481f12(30)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	else
		event.Finish()
		return 0
	end
end

return helper_33e0e88d
