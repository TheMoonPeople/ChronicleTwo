--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_474c5bc8 = require("@lib/event/helper_474c5bc8")
local helper_8330ad5d = require("@lib/event/helper_8330ad5d")

--- Helper function.
local function helper_4d759d26(arg0: s32)
	local var1: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var1 = helper_8330ad5d(2, -1)
		end
		if at <= 2 then
			helper_474c5bc8(30)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	if arg0 == 1 then
		var1 = helper_8330ad5d(1, -1)
		if vm.skipping() then
			return skip(1)
		end
	else
		var1 = helper_8330ad5d(2, -1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var1 == 0 then
		event.SetFadeOut(30)
		helper_474c5bc8(30)
		if vm.skipping() then
			return skip(3)
		end
		return 1
	else
		event.Finish()
		return 0
	end
end

return helper_4d759d26
