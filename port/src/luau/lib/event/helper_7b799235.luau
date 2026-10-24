--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffbc0d3 = require("@lib/event/helper_0ffbc0d3")
local helper_58664ea4 = require("@lib/event/helper_58664ea4")
local helper_a6ee0a26 = require("@lib/event/helper_a6ee0a26")
local helper_ab82d43e = require("@lib/event/helper_ab82d43e")

--- Helper function.
local function helper_7b799235(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_ab82d43e(arg0, arg1)
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
		helper_ab82d43e(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_58664ea4(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_0ffbc0d3(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_a6ee0a26(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_7b799235
