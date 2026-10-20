--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_176067a2 = require("@lib/event/helper_176067a2")
local helper_22965ea3 = require("@lib/event/helper_22965ea3")
local helper_4666f2a8 = require("@lib/event/helper_4666f2a8")
local helper_51c73b1c = require("@lib/event/helper_51c73b1c")

--- Helper function.
local function helper_90240f38(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_176067a2(arg0, arg1)
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
		helper_176067a2(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_4666f2a8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_22965ea3(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_51c73b1c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_90240f38
