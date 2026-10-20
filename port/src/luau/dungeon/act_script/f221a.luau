--!strict
-- dungeon/act_script/f221a.stb: action script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1512c7e0 = require("@lib/action/helper_1512c7e0")
local helper_1eb83da1 = require("@lib/action/helper_1eb83da1")
local helper_37f14ce7 = require("@lib/action/helper_37f14ce7")
local helper_42e38fa0 = require("@lib/action/helper_42e38fa0")
local helper_bac4ec65 = require("@lib/action/helper_bac4ec65")

--- Helper function.
local function helper_f6c()
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local var10: s32 = 0
	action.SetMos("攻撃２loop")
	helper_bac4ec65(20)
	var10 = action.GetAttkPoint(0) or var10
	do
		local out1, out2, out3 = action.GetObjectPos("magic_coll")
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
	action.EsmCreate_1("呪い弾Ｆ")
	action.EsmSetVect1(-1, var4, var5, var6)
	action.EsmSetVect2(-1, rot_x, rot_y, rot_z)
	action.EsmCreate_1("呪い弾Ｌ")
	action.EsmSetVect1(-1, var4, var5, var6)
	action.EsmSetVect2(-1, rot_x, rot_y, rot_z)
	action.EsmSetValue(-1, 0, var10)
	action.ProgSet(0)
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the character up when its script is initialised.
function script.init()
	action.SetDmg2("null48", "", "モンスター攻撃", 2.5, 1.0, "攻撃１", 0.37, 0.43)
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
			helper_f6c()
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
