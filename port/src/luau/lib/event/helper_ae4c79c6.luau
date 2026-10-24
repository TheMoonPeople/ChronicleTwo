--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5948d2ba = require("@lib/event/helper_5948d2ba")
local helper_7185d9c0 = require("@lib/event/helper_7185d9c0")
local helper_e1028f3d = require("@lib/event/helper_e1028f3d")
local helper_eae0f562 = require("@lib/event/helper_eae0f562")
local helper_f7c069e5 = require("@lib/event/helper_f7c069e5")

--- Helper function.
local function helper_ae4c79c6(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_eae0f562(arg0, arg1)
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
		helper_eae0f562(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_5948d2ba(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_7185d9c0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_e1028f3d(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_f7c069e5(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_ae4c79c6
