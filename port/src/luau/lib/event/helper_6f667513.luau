--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0b7600c7 = require("@lib/event/helper_0b7600c7")
local helper_41b1236d = require("@lib/event/helper_41b1236d")

--- Helper function.
local function helper_6f667513(arg0: s32, arg1: s32)
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
	if helper_0b7600c7() ~= 0 then
		var6 = 1051
	elseif arg0 ~= 0 then
		return
	end
	if arg1 ~= 0 then
		var6 = var6 + 10
	end
	event.MesMake_2(1, var6)
	helper_41b1236d(1, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_6f667513
