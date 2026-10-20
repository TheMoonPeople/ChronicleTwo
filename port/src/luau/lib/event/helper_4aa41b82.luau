--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_481c5bcc = require("@lib/event/helper_481c5bcc")
local helper_59e544a8 = require("@lib/event/helper_59e544a8")
local helper_64144c15 = require("@lib/event/helper_64144c15")
local helper_7e5870d1 = require("@lib/event/helper_7e5870d1")
local helper_84904320 = require("@lib/event/helper_84904320")

--- Helper function.
local function helper_4aa41b82(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_59e544a8(arg0, arg1)
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
		helper_59e544a8(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_84904320(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_481c5bcc(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_64144c15(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_7e5870d1(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_4aa41b82
