--!strict
--- Monster model lighting updates.

local vm = require("@lib/vm")

local lighting = {}

--- Turns model lighting off while rage hits remain and on otherwise.
function lighting.update_from_rage_hits()
	local rage_hits_left: s32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left > 0 then
		monster.set_model_lighting(0)
	else
		monster.set_model_lighting(1)
	end
end

return lighting
