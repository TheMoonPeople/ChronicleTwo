--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_39715509 = require("@lib/event/helper_39715509")
local helper_7fed7304 = require("@lib/event/helper_7fed7304")
local helper_993850b3 = require("@lib/event/helper_993850b3")

--- Helper function.
local function helper_c0195a7d()
	local flag: s32 = 0
	local at: number = 0
	return vm.guard(function()
		at = 1
		vm.entry(1)
		flag = event.get_save_flag(508) or flag
		if helper_7fed7304() ~= 0 and flag == 0 then
			event.add_inventory_item(372, 1)
			at = 2
			helper_39715509()
			return 1
		end
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_39715509()
				return vm.continue_with(function()
					return 1
				end)
			end
			local _ = helper_993850b3()
			return 1
		end
		return nil
	end)
end

return helper_c0195a7d
