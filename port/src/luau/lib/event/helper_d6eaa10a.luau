--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_07daf832 = require("@lib/event/helper_07daf832")
local helper_0d2d6d07 = require("@lib/event/helper_0d2d6d07")
local helper_10a01038 = require("@lib/event/helper_10a01038")
local helper_de72c09f = require("@lib/event/helper_de72c09f")
local helper_fbd093d9 = require("@lib/event/helper_fbd093d9")

--- Helper function.
local function helper_d6eaa10a(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_fbd093d9(arg0, arg1)
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
		helper_fbd093d9(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_07daf832(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_0d2d6d07(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_10a01038(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_de72c09f(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_d6eaa10a
