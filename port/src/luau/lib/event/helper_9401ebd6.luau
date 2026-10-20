--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3771a85f = require("@lib/event/helper_3771a85f")
local helper_402a36bb = require("@lib/event/helper_402a36bb")
local helper_75fd854d = require("@lib/event/helper_75fd854d")
local helper_ae638bc4 = require("@lib/event/helper_ae638bc4")
local helper_e3152f3c = require("@lib/event/helper_e3152f3c")

--- Helper function.
local function helper_9401ebd6(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_e3152f3c(arg0, arg1)
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
		helper_e3152f3c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_ae638bc4(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_402a36bb(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_75fd854d(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_3771a85f(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_9401ebd6
