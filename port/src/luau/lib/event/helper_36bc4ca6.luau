--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_212346ac = require("@lib/event/helper_212346ac")
local helper_596e7ecf = require("@lib/event/helper_596e7ecf")
local helper_b91b92c1 = require("@lib/event/helper_b91b92c1")
local helper_bf70e668 = require("@lib/event/helper_bf70e668")

--- Helper function.
local function helper_36bc4ca6(arg0: s32, arg1: s32)
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
		helper_596e7ecf(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_212346ac(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_bf70e668(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_b91b92c1(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_36bc4ca6
