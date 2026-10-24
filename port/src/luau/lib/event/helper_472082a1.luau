--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a2a9cc01 = require("@lib/event/helper_a2a9cc01")

--- Helper function.
local function helper_472082a1(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a2a9cc01(2030010)
		end
		if at <= 2 then
			helper_a2a9cc01(2030015)
		end
		if at <= 3 then
			helper_a2a9cc01(2030020)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(0, "上見立ち", 4)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(2, "スコップ立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_a2a9cc01(2030010)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_a2a9cc01(2030015)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_a2a9cc01(2030020)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
end

return helper_472082a1
