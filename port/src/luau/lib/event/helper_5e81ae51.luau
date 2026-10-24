--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_539d1eec = require("@lib/event/helper_539d1eec")
local helper_563c0311 = require("@lib/event/helper_563c0311")
local helper_6e617c14 = require("@lib/event/helper_6e617c14")
local helper_bd6fc897 = require("@lib/event/helper_bd6fc897")

--- Helper function.
local function helper_5e81ae51(arg0: s32, arg1: s32)
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
		helper_bd6fc897(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_563c0311(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_6e617c14(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_539d1eec(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_5e81ae51
