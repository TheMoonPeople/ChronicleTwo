--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a255005b = require("@lib/event/helper_a255005b")
local helper_b6cae226 = require("@lib/event/helper_b6cae226")

--- Helper function.
local function helper_9e35d629(arg0: s32, arg1: s32)
	local var5: s32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var5 = event.GetChapter() or var5
	if var5 >= 8 then
		return
	end
	event.SetMesWindowMode(1, 8)
	event.SetMotion(0, "立ち")
	var6 = 1050
	if helper_b6cae226() ~= 0 then
		var6 = 1051
	elseif arg0 ~= 0 then
		return
	end
	if arg1 ~= 0 then
		var6 = var6 + 10
	end
	event.MesMake_2(1, var6)
	helper_a255005b(1, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_9e35d629
