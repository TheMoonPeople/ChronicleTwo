--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2e502f48 = require("@lib/event/helper_2e502f48")
local helper_4b5786ea = require("@lib/event/helper_4b5786ea")
local helper_5297c0d0 = require("@lib/event/helper_5297c0d0")
local helper_9c8e3c19 = require("@lib/event/helper_9c8e3c19")
local helper_ade04673 = require("@lib/event/helper_ade04673")

--- Helper function.
local function helper_d3e5df4d(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_ade04673(arg0, arg1)
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
		helper_ade04673(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_9c8e3c19(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_4b5786ea(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_5297c0d0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_2e502f48(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_d3e5df4d
