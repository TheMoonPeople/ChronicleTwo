--!strict
-- Shared event helper used by 35 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_581cb30c = require("@lib/event/helper_581cb30c")

--- Helper function.
local function helper_c24a11db()
	local language_code: s32 = 0
	local tex_bank: s32 = 0
	local var2: s32 = 0
	vm.wait(1)
	language_code = event.GetLanguage() or language_code
	var2 = event.SphidaGetScore(-1) or var2
	tex_bank = event.SphidaGetTexb() or tex_bank
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "omake_sfida", tex_bank)
	event.SpriteSetPos(0, 256, 192)
	if language_code == 3 then
		event.SpriteSetUvsize(0, 0, 38, 162, 34)
		event.SpriteSetPutsize(0, 162, 34)
	else
		event.SpriteSetUvsize(0, 0, 38, 182, 34)
		event.SpriteSetPutsize(0, 182, 34)
	end
	event.SpriteSetColor(0, 128, 128, 128, 128)
	event.SpriteSetDraw(0, 1)
	event.SpriteInit(1)
	event.SpriteSetDraw(1, 0)
	event.SpriteInit(2)
	event.SpriteSetType(2, 0)
	event.SpriteSetTexture(2, "omake_sfida", tex_bank)
	event.SpriteSetUvsize(2, 136, 0, 104, 38)
	event.SpriteSetPos(2, 278, 224)
	event.SpriteSetPutsize(2, 104, 38)
	event.SpriteSetColor(2, 128, 128, 128, 128)
	event.SpriteSetDraw(2, 1)
	event.SpriteInit(3)
	event.SpriteSetType(3, 0)
	event.SpriteSetTexture(3, "omake_sfida", tex_bank)
	event.SpriteSetUvsize(3, vm.i32(vm.imod(var2, 10) * 28), 96, 28, 32)
	event.SpriteSetPos(3, 208, 224)
	event.SpriteSetPutsize(3, 28, 32)
	event.SpriteSetColor(3, 128, 128, 128, 128)
	event.SpriteSetDraw(3, 1)
	if vm.idiv(var2, 10) > 0 then
		event.SpriteInit(4)
		event.SpriteSetType(4, 0)
		event.SpriteSetTexture(4, "omake_sfida", tex_bank)
		event.SpriteSetUvsize(4, vm.i32(vm.idiv(var2, 10) * 28), 96, 28, 32)
		event.SpriteSetPos(4, 184, 224)
		event.SpriteSetPutsize(4, 28, 32)
		event.SpriteSetColor(4, 128, 128, 128, 128)
		event.SpriteSetDraw(4, 1)
	end
	while true do
		if helper_581cb30c(0) ~= 0 then
			break
		else
			vm.wait(2)
		end
	end
end

return helper_c24a11db
