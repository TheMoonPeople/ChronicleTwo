--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_020f0385 = require("@lib/event/helper_020f0385")
local helper_08cf235d = require("@lib/event/helper_08cf235d")
local helper_0f75e109 = require("@lib/event/helper_0f75e109")
local helper_a13a28b3 = require("@lib/event/helper_a13a28b3")
local helper_d0b2a465 = require("@lib/event/helper_d0b2a465")

--- Helper function.
local function helper_16701010(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_d0b2a465(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_d0b2a465(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_a13a28b3(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_020f0385(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_08cf235d(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_0f75e109(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_16701010
