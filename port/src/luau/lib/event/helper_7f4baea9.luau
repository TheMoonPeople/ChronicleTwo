--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_00115374 = require("@lib/event/helper_00115374")
local helper_7342df63 = require("@lib/event/helper_7342df63")
local helper_7812a96a = require("@lib/event/helper_7812a96a")
local helper_9badc557 = require("@lib/event/helper_9badc557")

--- Helper function.
local function helper_7f4baea9(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_7812a96a(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_7812a96a(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_7342df63(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_00115374(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_9badc557(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_7f4baea9
