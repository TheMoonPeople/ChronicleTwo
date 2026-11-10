--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_473930cd = require("@lib/event/helper_473930cd")
local helper_59c8e763 = require("@lib/event/helper_59c8e763")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_db89f583(arg0: s32, arg1: s32)
	local item: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "Te he estado esperando.<page>R[UNI00e1]pido, dame la Pintura para\ndar vida a mi cuadro.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_use_item_menu(376)
	vm.wait(3)
	item = vmhost.used_item() or item
	if item <= 0 then
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	if item ~= 376 then
		event.open_message_window_2(
			0,
			"[UNI00a1]Est[UNI00e1]s de broma!<page>Lo que necesito es Pintura dorada.\n[UNI00a1]No te equivoques!"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(376)
	event.open_message_window_2(0, "O sea que esta es la Pintura dorada...\nLa probar[UNI00e9] ahora mismo.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Es... Es real...<page>[UNI00a1]Incre[UNI00ed]ble, es perfecta!")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Gracias, Max.\nNo he olvidado mi promesa. Usa mi\nnuevo poder cuando quieras.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_473930cd()
	event.set_npc_party_status(22, 130)
	helper_59c8e763(22)
	event.finish_event()
	event.set_quest_request(1, 1, 1)
end

return helper_db89f583
