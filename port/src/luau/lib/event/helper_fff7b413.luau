--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8efd9cbc = require("@lib/event/helper_8efd9cbc")

--- Helper function.
local function helper_fff7b413(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8efd9cbc(arg0, var8)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	do
		local out1, _, out3 = event.GetCharaPos(arg0)
		var2 = out1 or var2
		var4 = out3 or var4
	end
	do
		local out1, _, out3 = event.GetCharaPos(arg1)
		var5 = out1 or var5
		var7 = out3 or var7
	end
	var8 = event.GetRotLookPos(var5 - var2, var7 - var4) or var8
	helper_8efd9cbc(arg0, var8)
	if vm.skipping() then
		return skip(2)
	end
	event.SetCharaRot(arg0, 0.0, var8, 0.0)
	event.SetMotion(arg0, "立ち")
end

return helper_fff7b413
