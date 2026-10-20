--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_56873f6e = require("@lib/event/helper_56873f6e")
local helper_79b63d51 = require("@lib/event/helper_79b63d51")
local helper_b8bfb1b2 = require("@lib/event/helper_b8bfb1b2")
local helper_cb1e3e44 = require("@lib/event/helper_cb1e3e44")

--- Helper function.
local function helper_ca619fb1(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_56873f6e(arg0, arg1)
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
		helper_56873f6e(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_cb1e3e44(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_79b63d51(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_b8bfb1b2(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_ca619fb1
