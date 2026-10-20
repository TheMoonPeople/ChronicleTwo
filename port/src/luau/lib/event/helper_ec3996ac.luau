--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")
local helper_f4bcb68c = require("@lib/event/helper_f4bcb68c")

--- Helper function.
local function helper_ec3996ac(arg0: s32)
	local var1: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_aafd6a80(20)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	var1 = helper_f4bcb68c(5, arg0)
	if vm.skipping() then
		return skip(1)
	end
	if var1 == 0 then
		event.SetFadeOut(20)
		helper_aafd6a80(20)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	end
	return 0
end

return helper_ec3996ac
