--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2d3d2cce = require("@lib/event/helper_2d3d2cce")
local helper_6bcfb077 = require("@lib/event/helper_6bcfb077")
local helper_9d315033 = require("@lib/event/helper_9d315033")
local helper_9f4edac7 = require("@lib/event/helper_9f4edac7")
local helper_b249db22 = require("@lib/event/helper_b249db22")

--- Helper function.
local function helper_8873340a(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_6bcfb077(arg0, arg1)
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
		helper_6bcfb077(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_9d315033(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_9f4edac7(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_2d3d2cce(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_b249db22(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_8873340a
