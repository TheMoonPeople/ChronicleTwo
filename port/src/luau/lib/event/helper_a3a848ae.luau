--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7595bb3d = require("@lib/event/helper_7595bb3d")

--- Helper function.
local function helper_a3a848ae()
	vm.section(function()
		event.Initialize()
		event.InitDramaScene()
		event.SetMesWindowMode(0, 7)
		event.CmrsInit()
		vm.wait(1)
		event.SetCameraPos(0.0, 0.0, 0.0)
		event.SetCameraRef(1.0, 0.0, 0.0)
		event.CharaActive(0, 0)
		helper_7595bb3d()
	end)
	event.CancelDramaScene()
	event.CharaActive(1, 0)
	event.SetFlag(56, 0)
end

return helper_a3a848ae
