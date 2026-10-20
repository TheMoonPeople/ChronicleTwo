--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_e3231669()
	local parts_id: s32 = 0
	local var1: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	parts_id = event.GetDoorPartsId() or parts_id
	event.EohSyncFuncp(0, parts_id, "door01")
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
	event.EohSyncObj(0, parts_id, "d07d05_3-m0")
	do
		local out1, out2, out3 = event.EohGetRot(0)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	rot_y = vm.f32(rot_y + 100.0)
	event.EohSyncObj(1, parts_id, "d07d05_1-m0")
	event.EohSyncObj(2, parts_id, "d07d05_1-m1")
	do
		local out1, out2, out3 = event.EohGetPos(1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	pos_y_2 = vm.f32(pos_y_2 + 100.0)
	do
		local out1, out2, out3 = event.EohGetPos(2)
		pos_x_3 = out1 or pos_x_3
		pos_y_3 = out2 or pos_y_3
		pos_z_3 = out3 or pos_z_3
	end
	pos_y_3 = vm.f32(pos_y_3 + 100.0)
	event.EohSetPos(0, rot_x, rot_y, rot_z)
	event.EohSetPos(1, pos_x_2, pos_y_2, pos_z_2)
	event.EohSetPos(2, pos_x_3, pos_y_3, pos_z_3)
	event.EohSyncObj(0, parts_id, "d07da05a-a")
	event.EohSetShow(0, 0)
	event.EohSyncObj(0, parts_id, "d07dv05a-c")
	event.EohSetShow(0, 0)
	event.EohSyncObj(0, parts_id, "d07da05b-a")
	event.EohSetShow(0, 1)
	event.EohSyncObj(0, parts_id, "d07dv05b-c")
	event.EohSetShow(0, 1)
	event.FuncPointShow(parts_id, "door01", 0)
end

return helper_e3231669
