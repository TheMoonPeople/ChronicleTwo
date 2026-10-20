--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2da790ea = require("@lib/event/helper_2da790ea")
local helper_7f115eb8 = require("@lib/event/helper_7f115eb8")
local helper_abdb8009 = require("@lib/event/helper_abdb8009")
local helper_b4d2c2e6 = require("@lib/event/helper_b4d2c2e6")
local helper_f9e179e1 = require("@lib/event/helper_f9e179e1")

--- Helper function.
local function helper_a11a83f8(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_b4d2c2e6(arg0, arg1)
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
		helper_b4d2c2e6(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_f9e179e1(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_2da790ea(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_7f115eb8(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_abdb8009(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_a11a83f8
