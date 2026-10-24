--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0b72ed2c = require("@lib/event/helper_0b72ed2c")
local helper_752cc752 = require("@lib/event/helper_752cc752")
local helper_7c3bcc46 = require("@lib/event/helper_7c3bcc46")
local helper_9b404a75 = require("@lib/event/helper_9b404a75")
local helper_cf2af952 = require("@lib/event/helper_cf2af952")

--- Helper function.
local function helper_c7525334(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_752cc752(arg0, arg1)
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
		helper_752cc752(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_9b404a75(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_cf2af952(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_0b72ed2c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_7c3bcc46(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_c7525334
