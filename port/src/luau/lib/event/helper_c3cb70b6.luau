--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_082956d4 = require("@lib/event/helper_082956d4")
local helper_89dc0363 = require("@lib/event/helper_89dc0363")
local helper_c2ab395d = require("@lib/event/helper_c2ab395d")
local helper_c423ce3f = require("@lib/event/helper_c423ce3f")
local helper_d3f302e5 = require("@lib/event/helper_d3f302e5")

--- Helper function.
local function helper_c3cb70b6(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_c423ce3f(arg0, arg1)
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
		helper_c423ce3f(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_c2ab395d(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_082956d4(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_89dc0363(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_d3f302e5(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_c3cb70b6
