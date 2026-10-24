--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1df9d08a = require("@lib/event/helper_1df9d08a")
local helper_ccf7aeb2 = require("@lib/event/helper_ccf7aeb2")

--- Helper function.
local function helper_2690eb2a()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ccf7aeb2(30)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち", 4)
	var0 = helper_1df9d08a(6, 16)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		event.SetFadeOut(30)
		helper_ccf7aeb2(30)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	end
	return 0
end

return helper_2690eb2a
