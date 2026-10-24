--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3bf9bb87 = require("@lib/event/helper_3bf9bb87")
local helper_8b85412e = require("@lib/event/helper_8b85412e")
local helper_a7e1b259 = require("@lib/event/helper_a7e1b259")
local helper_ca731477 = require("@lib/event/helper_ca731477")
local helper_fd56d101 = require("@lib/event/helper_fd56d101")

--- Helper function.
local function helper_14a7bf87(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_a7e1b259(arg0, arg1)
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
		helper_a7e1b259(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_8b85412e(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_3bf9bb87(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_fd56d101(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_ca731477(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_14a7bf87
