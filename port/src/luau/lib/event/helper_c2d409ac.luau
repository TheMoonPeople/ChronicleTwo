--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8d6da5b2 = require("@lib/event/helper_8d6da5b2")
local helper_bdbefa67 = require("@lib/event/helper_bdbefa67")

--- Helper function.
local function helper_c2d409ac()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bdbefa67(30)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	var0 = helper_8d6da5b2(4, -1)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		event.SetFadeOut(30)
		helper_bdbefa67(30)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	end
	return 0
end

return helper_c2d409ac
