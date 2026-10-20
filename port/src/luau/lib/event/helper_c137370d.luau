--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_c137370d(arg0: s32, arg1: s32, arg2: f32, arg3: f32, arg4: f32, arg5: f32)
	if arg1 == 51 or arg1 == 81 or arg1 == 166 then
		event.LoadChara(4, "chara/p01_19a.gltf", "info", arg0)
	end
	if arg1 == 54 or arg1 == 60 or arg1 == 76 or arg1 == 83 or arg1 == 169 then
		event.LoadChara(4, "chara/p01_20a.gltf", "info", arg0)
	end
	if arg1 == 90 or arg1 == 70 or arg1 == 80 then
		event.LoadChara(4, "chara/p01_21a.gltf", "info", arg0)
	end
	if arg1 == 55 or arg1 == 62 or arg1 == 94 or arg1 == 77 or arg1 == 84 or arg1 == 168 then
		event.LoadChara(4, "chara/p01_22a.gltf", "info", arg0)
	end
	if arg1 == 59 or arg1 == 91 or arg1 == 71 or arg1 == 159 then
		event.LoadChara(4, "chara/p01_23a.gltf", "info", arg0)
	end
	if arg1 == 95 or arg1 == 75 or arg1 == 85 or arg1 == 172 then
		event.LoadChara(4, "chara/p01_24a.gltf", "info", arg0)
	end
	if arg1 == 57 or arg1 == 64 or arg1 == 98 or arg1 == 74 or arg1 == 87 or arg1 == 157 or arg1 == 158 then
		event.LoadChara(4, "chara/p03_20a.gltf", "info", arg0)
	end
	if arg1 == 58 or arg1 == 69 or arg1 == 99 or arg1 == 79 or arg1 == 89 or arg1 == 167 then
		event.LoadChara(4, "chara/p03_22a.gltf", "info", arg0)
	end
	if arg1 == 53 or arg1 == 68 or arg1 == 93 or arg1 == 73 or arg1 == 86 or arg1 == 164 or arg1 == 165 then
		event.LoadChara(4, "chara/p03_24a.gltf", "info", arg0)
	end
	if arg1 == 40 then
		event.LoadChara(4, "chara/p03_26a.gltf", "info", arg0)
	end
	if arg1 == 41 then
		event.LoadChara(4, "chara/p03_27a.gltf", "info", arg0)
	end
	if arg1 == 42 then
		event.LoadChara(4, "chara/p03_28a.gltf", "info", arg0)
	end
	if arg1 == 67 or arg1 == 65 or arg1 == 97 or arg1 == 88 then
		event.LoadChara(4, "chara/p03_30a.gltf", "info", arg0)
	end
	if arg1 == 63 then
		event.LoadChara(4, "chara/p03_32a.gltf", "info", arg0)
	end
	if arg1 == 66 then
		event.LoadChara(4, "chara/p03_33a.gltf", "info", arg0)
	end
	if arg1 == 52 or arg1 == 61 or arg1 == 92 or arg1 == 161 or arg1 == 163 then
		event.LoadChara(4, "chara/p03_37a.gltf", "info", arg0)
	end
	if arg1 == 56 or arg1 == 96 or arg1 == 78 or arg1 == 170 or arg1 == 171 then
		event.LoadChara(4, "chara/p03_38a.gltf", "info", arg0)
	end
	if arg1 == 72 or arg1 == 162 then
		event.LoadChara(4, "chara/p03_39a.gltf", "info", arg0)
	end
	if arg1 == 82 or arg1 == 160 then
		event.LoadChara(4, "chara/p03_40a.gltf", "info", arg0)
	end
	event.SetCharaPos(arg0, arg2, arg3, arg4)
	event.SetCharaRot(arg0, 0.0, arg5, 0.0)
	event.SetCharaNo(arg0, arg1)
	event.RegisterVillager(arg0, arg1)
	event.CharaActive(arg0)
end

return helper_c137370d
