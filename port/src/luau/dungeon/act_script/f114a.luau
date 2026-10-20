--!strict
-- dungeon/act_script/f114a.stb: action script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1512c7e0 = require("@lib/action/helper_1512c7e0")
local helper_37f14ce7 = require("@lib/action/helper_37f14ce7")
local helper_42e38fa0 = require("@lib/action/helper_42e38fa0")
local helper_9559fe61 = require("@lib/action/helper_9559fe61")
local helper_bac4ec65 = require("@lib/action/helper_bac4ec65")

--- Helper function.
local function helper_d24()
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local front_x: f32 = 0
	local front_y: f32 = 0
	local front_z: f32 = 0
	local var14: s32 = 0
	local monster_id: s32 = 0
	action.ProgGet()
	action.SetMos("攻撃１", -1, 6)
	action.SetMos("攻撃１", -1, 6)
	helper_9559fe61(vm.f32(0.4), vm.f32(0.45))
	do
		local out1, out2, out3 = action.GetObjectPos("dcol0")
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	do
		local out1, out2, out3 = action.GetFrontVec()
		front_x = out1 or front_x
		front_y = out2 or front_y
		front_z = out3 or front_z
	end
	do
		local out1, out2, out3 = action.GetRot()
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	var14 = action.GetAttkPoint(0) or var14
	monster_id = action.GetMonsId() or monster_id
	if monster_id == 112 then
		action.EsmCreate_1("火弾Ｆ")
	end
	if monster_id == 116 then
		action.EsmCreate_1("氷弾Ｆ")
	end
	if monster_id == 120 then
		action.EsmCreate_1("雷弾Ｆ")
	end
	if monster_id == 124 then
		action.EsmCreate_1("風弾Ｆ")
	end
	if monster_id == 128 then
		action.EsmCreate_1("聖弾Ｆ")
	end
	action.EsmSetVect1(-1, var4, var5 - vm.f32(2.6), var6)
	action.EsmSetVect2(-1, rot_x, rot_y, rot_z)
	helper_9559fe61(vm.f32(0.45), vm.f32(0.52))
	if monster_id == 112 then
		action.EsmCreate_1("火弾Ｌ３")
	end
	if monster_id == 116 then
		action.EsmCreate_1("氷弾Ｌ２")
	end
	if monster_id == 120 then
		action.EsmCreate_1("雷弾Ｌ２")
	end
	if monster_id == 124 then
		action.EsmCreate_1("風弾Ｌ２")
	end
	if monster_id == 128 then
		action.EsmCreate_1("聖弾Ｌ２")
	end
	action.EsmSetVect1(-1, var4, var5 - vm.f32(2.6), var6)
	action.EsmSetVect2(-1, front_x, front_y, front_z)
	action.EsmSetValue(-1, 0, var14)
	action.EsmSetValueFloat(-1, 1, 12.0)
	helper_bac4ec65(2)
	action.ProgSet(0)
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the character up when its script is initialised.
function script.init()
	action.SetMoveSpeed(3.4)
end

--- Runs the character's normal behaviour.
function script.loop()
	local prog: s32 = 0
	local var3: s32 = 0
	action.ProgSet(0)
	while true do
		prog = action.ProgGet() or prog
		if prog >= 100 and prog < 199 then
			action.SetTrgAngle(40.0, 5.0)
			helper_d24()
		end
		prog = action.ProgGet() or prog
		if prog == 0 then
			action.RunMainMove()
			var3 = action.GetBtn_2(50) or var3
			if var3 ~= 0 then
				prog = 100
			end
			action.ProgSet(prog)
		end
		vm.wait()
	end
end

--- Reacts to a small hit.
script.on_small_damage = helper_1512c7e0

--- Holds the character in place.
script.on_hold = helper_1512c7e0

--- Reacts to a large hit.
script.on_large_damage = helper_42e38fa0

--- Follows up a melee hit that the character has landed.
-- Defined empty, so the engine runs this instead of its default.
function script.on_melee_hit() end

--- Runs the character's death.
script.on_death = helper_37f14ce7

return script
