--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_66f3d184 = require("@lib/event/helper_66f3d184")
local helper_9365687c = require("@lib/event/helper_9365687c")
local helper_a9369b63 = require("@lib/event/helper_a9369b63")
local helper_c454ae5b = require("@lib/event/helper_c454ae5b")

--- Helper function.
local function helper_bff74834(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_66f3d184(arg0, arg1)
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
		helper_66f3d184(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_a9369b63(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_9365687c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_c454ae5b(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_bff74834
