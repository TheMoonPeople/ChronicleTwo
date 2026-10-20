--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_09b38077 = require("@lib/event/helper_09b38077")
local helper_2c02de2d = require("@lib/event/helper_2c02de2d")
local helper_53c7c76a = require("@lib/event/helper_53c7c76a")
local helper_62ff4ba4 = require("@lib/event/helper_62ff4ba4")
local helper_abe32bff = require("@lib/event/helper_abe32bff")

--- Helper function.
local function helper_ebd67bb2(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_62ff4ba4(arg0, arg1)
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
		helper_62ff4ba4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_09b38077(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_53c7c76a(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_abe32bff(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_2c02de2d(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_ebd67bb2
