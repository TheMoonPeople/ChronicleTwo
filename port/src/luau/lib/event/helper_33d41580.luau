--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_638fb8b6 = require("@lib/event/helper_638fb8b6")
local helper_8c015ae2 = require("@lib/event/helper_8c015ae2")
local helper_91b580ed = require("@lib/event/helper_91b580ed")
local helper_a4f4ca7f = require("@lib/event/helper_a4f4ca7f")
local helper_f7b795ef = require("@lib/event/helper_f7b795ef")

--- Helper function.
local function helper_33d41580(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_f7b795ef(arg0, arg1)
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
		helper_f7b795ef(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_8c015ae2(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_a4f4ca7f(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_91b580ed(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_638fb8b6(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_33d41580
