--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7d9e902a = require("@lib/event/helper_7d9e902a")

--- Helper function.
local function helper_48c23086()
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_7d9e902a()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.DngSetStageId(0)
	event.GotoMenu(3, 0)
	if vm.wait() then
		return skip(2)
	end
	do
		local _, _, out3, _ = event.GetMenuParam_4()
		var2 = out3 or var2
	end
	if var2 == 0 then
		event.MapJump(-1, "d01e01")
		if vm.wait() then
			return skip(3)
		end
	elseif var2 == 8 then
		helper_7d9e902a()
		if vm.skipping() then
			return skip(4)
		end
	else
		event.GotoDng(0, var2, 1010)
	end
end

return helper_48c23086
