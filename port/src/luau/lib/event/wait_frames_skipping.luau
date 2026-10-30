--!strict
-- Shared event helper used by 665 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- What skip mode runs of wait_frames: one pass of its count, without waiting.
local function wait_frames_skipping(frames: any)
	local _ = frames > 0
	local _ = frames >= 0
	frames = vm.wrap(frames - 1)
end

return wait_frames_skipping
