--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0e6c3540 = require("@lib/event/helper_0e6c3540")
local helper_322847c0 = require("@lib/event/helper_322847c0")
local helper_3e6ec553 = require("@lib/event/helper_3e6ec553")
local helper_708b059c = require("@lib/event/helper_708b059c")
local helper_ecad1b74 = require("@lib/event/helper_ecad1b74")

--- Helper function.
local function helper_4aab852b(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_708b059c(arg0, arg1)
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
		helper_708b059c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_322847c0(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_ecad1b74(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_0e6c3540(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_3e6ec553(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_4aab852b
