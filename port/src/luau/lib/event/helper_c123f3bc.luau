--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0452df0a = require("@lib/event/helper_0452df0a")
local helper_52a998dc = require("@lib/event/helper_52a998dc")
local helper_55a9cab6 = require("@lib/event/helper_55a9cab6")
local helper_a23755c2 = require("@lib/event/helper_a23755c2")
local helper_b828bdda = require("@lib/event/helper_b828bdda")

--- Helper function.
local function helper_c123f3bc(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_0452df0a(arg0, arg1)
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
		helper_0452df0a(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_55a9cab6(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_b828bdda(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_a23755c2(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_52a998dc(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_c123f3bc
