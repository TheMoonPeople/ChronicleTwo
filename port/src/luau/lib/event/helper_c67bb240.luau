--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3e77b5b1 = require("@lib/event/helper_3e77b5b1")
local helper_a8b5d854 = require("@lib/event/helper_a8b5d854")
local helper_b09f6907 = require("@lib/event/helper_b09f6907")

--- Helper function.
local function helper_c67bb240(arg0: s32)
	local active_chr_no: s32 = 0
	local var2: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_3e77b5b1(0, 21, 5, 256, 208)
			end
			return 0
		end
		if at <= 3 then
			helper_a8b5d854(30)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_3e77b5b1(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_3e77b5b1(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return 0
	end
	var2 = helper_b09f6907(arg0, -1)
	if vm.skipping() then
		return skip(3)
	end
	if var2 == 0 then
		event.SetFadeOut(30)
		helper_a8b5d854(30)
		if vm.skipping() then
			return skip(4)
		end
		event.Finish()
		return 1
	end
	event.Finish()
	return 0
end

return helper_c67bb240
