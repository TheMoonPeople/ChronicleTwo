--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_100ac525 = require("@lib/event/helper_100ac525")
local helper_81c9dac7 = require("@lib/event/helper_81c9dac7")
local helper_a77b24cf = require("@lib/event/helper_a77b24cf")

--- Helper function.
local function helper_eb344bc3()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_a77b24cf(0, 20, 5, 256, 208)
			end
			if at <= 2 then
				helper_a77b24cf(0, 21, 5, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			helper_100ac525(30)
		end
		return 1
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_a77b24cf(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		else
			helper_a77b24cf(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(3)
			end
		end
		event.Finish()
		return 0
	end
	var1 = helper_81c9dac7(4, -1)
	if vm.skipping() then
		return skip(4)
	end
	if var1 == 0 then
		event.SetFadeOut(30)
		helper_100ac525(30)
		if vm.skipping() then
			return skip(5)
		end
		return 1
	end
	return 0
end

return helper_eb344bc3
