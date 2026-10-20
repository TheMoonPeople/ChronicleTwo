--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_c1dfffc1 = require("@lib/event/helper_c1dfffc1")

--- Helper function.
local function helper_8b30bbe1()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_c1dfffc1()
	end
	print("slope-------------------off\t\n")
	event.EohSyncObj(0, "p01_train01", "train07-m0")
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.EohSetPos(0, pos_x + 56.0, pos_y, pos_z)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSyncObj(0, "p01_train01", "train07-m1")
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.EohSetPos(0, pos_x + 56.0, pos_y, pos_z)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSyncObj(0, "p01_train01", "train07-m2")
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.EohSetPos(0, pos_x + 56.0, pos_y, pos_z)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSyncObj(0, "p01_train01", "train07-m3")
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.EohSetPos(0, pos_x - 56.0, pos_y, pos_z)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSyncObj(0, "p01_train01", "train07-m4")
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.EohSetPos(0, pos_x - 56.0, pos_y, pos_z)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSyncObj(0, "p01_train01", "train07-m5")
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.EohSetPos(0, pos_x - 56.0, pos_y, pos_z)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	if vm.wait() then
		return skip(1)
	end
	helper_c1dfffc1()
end

return helper_8b30bbe1
