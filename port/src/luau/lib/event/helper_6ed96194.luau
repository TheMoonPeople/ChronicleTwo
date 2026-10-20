--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3059398d = require("@lib/event/helper_3059398d")
local helper_7299d8ef = require("@lib/event/helper_7299d8ef")
local helper_bf3c1f9c = require("@lib/event/helper_bf3c1f9c")
local helper_cc911ace = require("@lib/event/helper_cc911ace")
local helper_e2cf6bc0 = require("@lib/event/helper_e2cf6bc0")

--- Helper function.
local function helper_6ed96194(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_bf3c1f9c(arg0, arg1)
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
		helper_bf3c1f9c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_3059398d(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_cc911ace(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_e2cf6bc0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_7299d8ef(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_6ed96194
