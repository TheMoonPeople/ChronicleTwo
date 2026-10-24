--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3fa65582 = require("@lib/event/helper_3fa65582")
local helper_596cedb4 = require("@lib/event/helper_596cedb4")
local helper_5d894c49 = require("@lib/event/helper_5d894c49")
local helper_5ee42bbe = require("@lib/event/helper_5ee42bbe")

--- Helper function.
local function helper_38a7ae8c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_3fa65582(arg0, arg1)
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
		helper_3fa65582(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_596cedb4(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_5ee42bbe(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_5d894c49(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_38a7ae8c
