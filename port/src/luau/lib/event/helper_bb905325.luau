--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_68b3b239 = require("@lib/event/helper_68b3b239")
local helper_ca922d4a = require("@lib/event/helper_ca922d4a")
local helper_efffcfbb = require("@lib/event/helper_efffcfbb")

--- Helper function.
local function helper_bb905325()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_68b3b239(0, 21, 5, 256, 208)
			end
			return 0
		end
		if at <= 3 then
			helper_efffcfbb(30)
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
			helper_68b3b239(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_68b3b239(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return 0
	end
	var1 = helper_ca922d4a(2, -1)
	if vm.skipping() then
		return skip(3)
	end
	if var1 == 0 then
		event.SetFadeOut(30)
		helper_efffcfbb(30)
		if vm.skipping() then
			return skip(4)
		end
		event.Finish()
		return 1
	end
	event.Finish()
	return 0
end

return helper_bb905325
