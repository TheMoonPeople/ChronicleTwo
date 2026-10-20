--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_50f608a6 = require("@lib/event/helper_50f608a6")
local helper_7af655af = require("@lib/event/helper_7af655af")
local helper_9624ebf4 = require("@lib/event/helper_9624ebf4")
local helper_bc9b0a53 = require("@lib/event/helper_bc9b0a53")
local helper_d4c3a155 = require("@lib/event/helper_d4c3a155")

--- Helper function.
local function helper_03edd65b(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_7af655af(arg0, arg1)
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
	if active_chr_no == 0 then
		helper_7af655af(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_bc9b0a53(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_9624ebf4(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_d4c3a155(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_50f608a6(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_03edd65b
