--!strict
-- dungeon/act_script/f26a.stb: action script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1512c7e0 = require("@lib/action/helper_1512c7e0")
local helper_1eb83da1 = require("@lib/action/helper_1eb83da1")
local helper_37f14ce7 = require("@lib/action/helper_37f14ce7")
local helper_42e38fa0 = require("@lib/action/helper_42e38fa0")
local helper_9559fe61 = require("@lib/action/helper_9559fe61")
local helper_9da84b8b = require("@lib/action/helper_9da84b8b")

--- Helper function.
local function helper_f7c()
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local var10: s32 = 0
	action.SetMos("攻撃２", -1, 6)
	helper_9559fe61(vm.f32(0.48), vm.f32(0.52))
	do
		local out1, out2, out3 = action.GetObjectPos("dcol02")
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	do
		local out1, out2, out3 = action.GetRot()
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	var10 = action.GetAttkPoint(0) or var10
	action.EsmCreate_1("石化弾Ｌ")
	action.EsmSetVect1(-1, var4, var5, var6)
	action.EsmSetVect2(-1, rot_x, rot_y, rot_z)
	action.EsmSetValue(-1, 0, var10)
	helper_9da84b8b()
	action.ProgSet(0)
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the character up when its script is initialised.
function script.init()
	action.SetDmg2("dcol01", "null73", "モンスター剣", 2.5, 1.0, "攻撃１", 0.54, 0.58)
end

--- Runs the character's normal behaviour.
function script.loop()
	local prog: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	action.ProgSet(0)
	while true do
		prog = action.ProgGet() or prog
		if prog >= 100 and prog < 199 then
			action.SetTrgAngle(40.0, 5.0)
			helper_1eb83da1()
		end
		if prog >= 200 and prog < 299 then
			action.SetTrgAngle(40.0, 5.0)
			helper_f7c()
		end
		prog = action.ProgGet() or prog
		if prog == 0 then
			action.RunMainMove()
			var3 = action.GetBtn_2(50) or var3
			var4 = action.GetBtn_2(51) or var4
			if var3 ~= 0 then
				prog = 100
			end
			if var4 ~= 0 then
				prog = 200
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
