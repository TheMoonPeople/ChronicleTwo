--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_455597c0()
	local parts_id: s32 = 0
	local var1: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	parts_id = event.GetDoorPartsId() or parts_id
	event.EohSyncFuncp(0, parts_id, "key")
	var1 = event.EohGetShow(0) or var1
	if parts_id < 0 or var1 == 0 then
		return
	end
	event.EohSyncObj(20, parts_id)
	do
		local out1, out2, out3 = event.EohGetPos(20)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.MinimapDoorEnable(pos_x, pos_y, pos_z)
	event.EohSyncObj(21, parts_id, "d01d01_00-m0")
	event.EohSetPos(21, 0.0, 80.0, 0.0)
	event.FuncPointShow(parts_id, "key", 0)
	event.EohSyncObj(22, parts_id, "d01da00-a")
	event.EohSetPos(22, 0.0, 80.0, 0.0)
	event.EohSyncObj(23, parts_id, "d01dv00-c")
	event.EohSetShow(23, 0)
end

return helper_455597c0
