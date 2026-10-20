--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_100ac525 = require("@lib/event/helper_100ac525")
local helper_81c9dac7 = require("@lib/event/helper_81c9dac7")

--- Helper function.
local function helper_2b7a517c()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_100ac525(30)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	var0 = helper_81c9dac7(5, 97)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		event.SetFadeOut(30)
		helper_100ac525(30)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	end
	return 0
end

return helper_2b7a517c
