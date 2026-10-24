--!strict
-- Shared event helper used by 36 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_9e7d1511 = require("@lib/event/helper_9e7d1511")

--- Helper function.
local function helper_59ffae1f()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no ~= 0 then
			event.SetMesWindowMode(0, 4)
			at = 1
			helper_9e7d1511(0, 2000, 8, 0, 0)
			return 1
		end
		var1 = event.GetEquipItemno(0, 0) or var1
		if var1 ~= 9 and var1 ~= 10 and var1 ~= 11 and var1 ~= 12 and var1 ~= 13 and var1 ~= 14 then
			event.SetMesWindowMode(0, 4)
			at = 2
			helper_9e7d1511(0, 2001, 8, 0, 0)
			return 1
		end
		event.SetMesWindowMode(0, 1)
		event.SphidaSetCulbNo(var1)
		event.PadAutoRepeatOff()
		return 0
	end, function(received: { any })
		if at <= 1 then
			return 1
		end
		if at <= 2 then
			return 1
		end
		return nil
	end)
end

return helper_59ffae1f
