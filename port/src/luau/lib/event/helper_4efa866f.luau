--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0282f3fd = require("@lib/event/helper_0282f3fd")
local helper_98e8044b = require("@lib/event/helper_98e8044b")
local helper_ad4b3d48 = require("@lib/event/helper_ad4b3d48")
local helper_d26d6cf5 = require("@lib/event/helper_d26d6cf5")

--- Helper function.
local function helper_4efa866f(arg0: s32, arg1: s32)
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
		helper_98e8044b(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_d26d6cf5(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_ad4b3d48(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_0282f3fd(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_4efa866f
