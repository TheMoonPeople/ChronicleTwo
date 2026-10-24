--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_72f8861f = require("@lib/event/helper_72f8861f")
local helper_85b1f1a3 = require("@lib/event/helper_85b1f1a3")
local helper_b99e2631 = require("@lib/event/helper_b99e2631")
local helper_cb5b2ae9 = require("@lib/event/helper_cb5b2ae9")

--- Helper function.
local function helper_806f6df3(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_72f8861f(arg0, arg1, 0)
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
		helper_72f8861f(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_b99e2631(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_85b1f1a3(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_cb5b2ae9(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_806f6df3
