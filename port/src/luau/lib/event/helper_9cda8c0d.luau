--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_538625a2 = require("@lib/event/helper_538625a2")
local helper_94fbb1ab = require("@lib/event/helper_94fbb1ab")
local helper_a86c4a59 = require("@lib/event/helper_a86c4a59")
local helper_c3e76d51 = require("@lib/event/helper_c3e76d51")
local helper_f557f0a6 = require("@lib/event/helper_f557f0a6")

--- Helper function.
local function helper_9cda8c0d(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_f557f0a6(arg0, arg1)
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
		helper_f557f0a6(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_c3e76d51(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_94fbb1ab(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_538625a2(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_a86c4a59(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_9cda8c0d
