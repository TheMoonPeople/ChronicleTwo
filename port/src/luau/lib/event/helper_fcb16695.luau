--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6855fc81 = require("@lib/event/helper_6855fc81")

--- Helper function.
local function helper_fcb16695()
	local parts_id: s32 = 0
	local var1: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
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
	var5 = event.DngGetFloorId() or var5
	if var5 >= 1 and var5 < 16 and var5 ~= 8 then
		event.EohSyncObj(0, parts_id, "d05d05_3-m0")
		event.EohSetShow(0, 1)
		event.FuncPointShow(parts_id, "eff_d05ef-0", 0)
		event.FuncPointShow(parts_id, "door01", 0)
		event.EohSyncObj(0, parts_id, "d05d05_2-m0")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, parts_id, "d05da05b-a")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, parts_id, "d05dv05-c")
		event.EohSetShow(0, 0)
	else
		event.FuncPointShow(parts_id, "door01", 0)
		var6 = event.PartsNameStrcmp(parts_id, "door04") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 0)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door05") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 0)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door06") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 0)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door07") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 0)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door12") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 1)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door13") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 1)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door14") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 1)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door15") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 1)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door20") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 2)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door21") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 2)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door22") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 2)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door23") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 2)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door32") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 3)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door33") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 3)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door34") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 3)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door35") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 3)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door40") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 4)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door41") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 4)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door42") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 4)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door43") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 4)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door48") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 5)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door49") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 5)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door50") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 5)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door51") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 5)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door68") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 6)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door69") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 6)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door70") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 6)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door71") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 6)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door76") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 7)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door77") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 7)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door78") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 7)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door79") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 7)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door84") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 8)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door85") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 8)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door86") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 8)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door87") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 8)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door96") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 9)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door97") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 9)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door98") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 9)
		end
		var6 = event.PartsNameStrcmp(parts_id, "door99") or var6
		if var6 == 0 then
			helper_6855fc81(parts_id, 9)
		end
	end
end

return helper_fcb16695
