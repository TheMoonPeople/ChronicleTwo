--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1e45929d = require("@lib/event/helper_1e45929d")
local helper_47e5998b = require("@lib/event/helper_47e5998b")
local helper_7f2d11e6 = require("@lib/event/helper_7f2d11e6")
local helper_a692aa0b = require("@lib/event/helper_a692aa0b")
local helper_eeb191d4 = require("@lib/event/helper_eeb191d4")

--- Helper function.
local function helper_641f9f31(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1e45929d(arg0, arg1)
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
		helper_1e45929d(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_7f2d11e6(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_eeb191d4(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_a692aa0b(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_47e5998b(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_641f9f31
