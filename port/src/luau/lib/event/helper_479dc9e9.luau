--!strict
-- Shared event helper used by 127 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_479dc9e9()
	local argc: s32 = 0
	while true do
		argc = event.CheckLoadbgFile() or argc
		if argc == 0 then
			break
		else
			vm.wait(1)
		end
	end
end

return helper_479dc9e9
