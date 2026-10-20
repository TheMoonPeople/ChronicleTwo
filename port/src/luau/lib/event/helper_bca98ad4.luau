--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ab135cc = require("@lib/event/helper_0ab135cc")
local helper_ab393aea = require("@lib/event/helper_ab393aea")
local helper_eaea82db = require("@lib/event/helper_eaea82db")
local helper_f0379408 = require("@lib/event/helper_f0379408")

--- Helper function.
local function helper_bca98ad4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
		if at <= 3 then
			return
		end
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_f0379408(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_0ab135cc(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_eaea82db(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_ab393aea(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_bca98ad4
