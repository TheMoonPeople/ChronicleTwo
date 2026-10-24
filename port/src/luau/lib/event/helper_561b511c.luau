--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_561b511c()
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
	event.EohSyncFuncp(0, parts_id, "key1")
	var1 = event.EohGetShow(0) or var1
	if parts_id < 0 or var1 == 0 then
		return
	end
	event.EohSyncObj(0, parts_id)
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.MinimapDoorEnable(pos_x, pos_y, pos_z)
	event.EohSyncObj(0, parts_id, "d06d00_4-m")
	event.EohSetShow(0, 1)
	event.EohSyncObj(0, parts_id, "d06d00_3-m")
	event.EohSetShow(0, 0)
	event.SetMpcharaMotion(parts_id, "d06d00_2-m", "全停止", 4)
	event.EohSyncObj(0, parts_id, "d06da00_2-a")
	event.EohSetShow(0, 0)
	event.EohSyncObj(0, parts_id, "d06dv00_1-c")
	event.EohSetShow(0, 0)
	event.FuncPointShow(parts_id, "key1", 0)
end

return helper_561b511c
