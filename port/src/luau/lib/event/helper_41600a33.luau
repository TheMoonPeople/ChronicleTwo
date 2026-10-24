--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0d596c08 = require("@lib/event/helper_0d596c08")
local helper_26f87341 = require("@lib/event/helper_26f87341")
local helper_4e8a485b = require("@lib/event/helper_4e8a485b")
local helper_8078c41b = require("@lib/event/helper_8078c41b")

--- Helper function.
local function helper_41600a33(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_8078c41b(arg0, arg1, 0)
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
		helper_8078c41b(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_0d596c08(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_26f87341(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_4e8a485b(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_41600a33
