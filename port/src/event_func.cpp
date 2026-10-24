#include "common.h"

#include <nlohmann/json.hpp>

#include <cstdio>
#include <cstring>
#include <exception>
#include <map>
#include <new>
#include <string_view>
#include <variant>

#include "dataread_port.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "log/log.hpp"
#include "luau_runtime.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "platform/legacy_encoding.hpp"
#include "platform/model_assets.hpp"
#include "ps2_printf.hpp"
#include "scene.hpp"

namespace {

/**
 * Appends an empty argument list using the event's next list identifier.
 */
ARG_LIST *AppendEventArgList(CEventScriptArg &script) {
    if (script.memory == nullptr) {
        return nullptr;
    }
    auto *created = new (script.memory->Alloc(3)) ARG_LIST;
    if (created == nullptr) {
        return nullptr;
    }
    created->id = script.next_id++;
    created->args = nullptr;
    created->arg_num = 0;
    created->next = nullptr;
    if (script.list_num <= 0) {
        script.list = created;
    } else {
        ARG_LIST *last = script.list;
        while (last->next != nullptr) {
            last = last->next;
        }
        last->next = created;
    }
    script.list_num++;
    return created;
}

/**
 * Allocates argument records from the event's memory arena.
 */
ARG_DATA *AllocateEventArgData(mgCMemory &memory, std::size_t count) {
    const std::size_t bytes = count * sizeof(ARG_DATA);
    const std::size_t words = (bytes + 15) / 16 + 2;
    return new (memory.Alloc(static_cast<u_int>(words))) ARG_DATA[count];
}

/**
 * Copies a converted argument string into the event's memory arena.
 */
char *CopyEventArgString(mgCMemory &memory, std::string_view source) {
    const std::size_t bytes = source.size() + 1;
    const std::size_t words = (bytes + 15) / 16 + 2;
    auto             *copy = new (memory.Alloc(static_cast<u_int>(words))) char[bytes];
    std::memcpy(copy, source.data(), source.size());
    copy[source.size()] = '\0';
    return copy;
}

/**
 * Outcome of applying one translated event argument command.
 */
enum class EventArgResult {
    Applied,       /**< The handler accepted the command. */
    Rejected,      /**< The arguments do not fit the command, so the module is malformed. */
    HandlerFailed, /**< The handler returned false, which retail reports as an illegal call. */
    NotFound,      /**< The command number has no handler in retail's table. */
};

/**
 * Records one argument list from the command's values, as retail's _DATA does.
 */
EventArgResult ApplyEventArgData(CEventScriptArg &script, const luau_runtime::EventArgAction &action) {
    // Retail keeps the list it already linked when its argument array cannot be allocated.
    ARG_LIST *list = AppendEventArgList(script);
    if (list == nullptr) {
        return EventArgResult::HandlerFailed;
    }
    ARG_DATA *args = AllocateEventArgData(*script.memory, action.args.size());
    if (args == nullptr) {
        return EventArgResult::HandlerFailed;
    }
    list->args = args;
    list->arg_num = static_cast<int>(action.args.size());
    for (std::size_t index = 0; index < action.args.size(); ++index) {
        if (const auto *integer = std::get_if<std::int32_t>(&action.args[index])) {
            args[index].type = RS_INT;
            args[index].i = *integer;
        } else if (const auto *number = std::get_if<float>(&action.args[index])) {
            args[index].type = RS_FLOAT;
            args[index].f = *number;
        } else {
            const std::string encoded = legacy_encoding::GameText(std::get<std::string>(action.args[index]));
            args[index].type = RS_STR;
            args[index].s = CopyEventArgString(*script.memory, encoded);
        }
    }
    return EventArgResult::Applied;
}

/**
 * Sets the next list identifier from the first value, as retail's _ID_OFFSET does, ignoring any extra values.
 */
EventArgResult ApplyEventArgIdOffset(CEventScriptArg &script, const luau_runtime::EventArgAction &action) {
    // Retail reads its first stack slot unconditionally, so without a value it would read a stale slot.
    if (action.args.empty()) {
        return EventArgResult::Rejected;
    }
    const luau_runtime::EventArgValue &first = action.args.front();
    if (const auto *offset = std::get_if<std::int32_t>(&first)) {
        script.next_id = *offset;
        return EventArgResult::Applied;
    }
    if (const auto *float_offset = std::get_if<float>(&first)) {
        script.next_id = static_cast<int>(*float_offset);
        return EventArgResult::Applied;
    }
    return EventArgResult::Rejected;
}

/**
 * Applies one translated event argument command to its argument-list state.
 */
EventArgResult ApplyEventArgAction(CEventScriptArg &script, const luau_runtime::EventArgAction &action) {
    switch (action.command) {
        case EVENT_ARG_DATA:
            return ApplyEventArgData(script, action);
        case EVENT_ARG_ID_OFFSET:
            return ApplyEventArgIdOffset(script, action);
        default:
            // Retail's table has no handler for command 2, so it is reported like any unknown number.
            return EventArgResult::NotFound;
    }
}

} // namespace

PORT_OVERRIDE int _LOAD_CHARA_sub(int stack_no, char **name, int chara_no, u32 *model, int mode) {
    if (!EventScene || !name) {
        return 0;
    }
    if (!*name) {
        const auto path = DataReadBufferPath(model);
        if (!path) {
            return 0;
        }
        std::string error;
        const auto  game = model_assets::ReadGameplay(*path, error);
        if (!game) {
            CT_LOG_ERROR(Data, "character: {}", error);
            return 0;
        }
        static std::map<std::string, std::string> selected_profiles;
        auto                                     &profile = selected_profiles[*path];
        profile = game->value("default_profile", std::string{});
        if (profile.empty()) {
            return 0;
        }
        *name = profile.data();
    }
    auto     *memory = EventScene->GetStack(stack_no);
    const int texture_block = EventScene->GetCharaTexb(chara_no);
    if (!memory || texture_block < 0) {
        return 0;
    }
    mgTexManager.DeleteBlock(texture_block);
    if (chara_no >= 8) {
        std::snprintf(mgTexManager.name_suffix, sizeof(mgTexManager.name_suffix), "ev%d", chara_no);
    }
    const int result = EventScene->LoadChara(chara_no, model, *name, memory, memory, memory, texture_block, mode);
    if (chara_no >= 8) {
        mgTexManager.name_suffix[0] = 0;
    }
    EventScene->SetType(SCENE_DATA_CHARA, chara_no, SCENE_CHARA_TYPE_EVENT);
    return result;
}

PORT_OVERRIDE void CEventScriptArg::BuildArgData(u32 *program) {
    const auto module = luau_runtime::HandleModule(program);
    if (!module) {
        PortRetailBuildArgData(program);
        return;
    }

    const auto actions = luau_runtime::ReadEventArgData(*module);
    if (!actions) {
        CT_LOG_ERROR(Script, "luau: {}: could not import event argument data", *module);
        return;
    }

    for (const luau_runtime::EventArgAction &action : *actions) {
        if (action.args.size() >= EVENT_ARG_STACK_NUM) {
            CT_LOG_ERROR(Script, "luau: {}: invalid event argument command {}", *module, action.command);
            continue;
        }
        try {
            switch (ApplyEventArgAction(*this, action)) {
                case EventArgResult::Applied:
                    break;
                case EventArgResult::Rejected:
                    CT_LOG_ERROR(Script, "luau: {}: invalid event argument command {}", *module, action.command);
                    break;
                case EventArgResult::HandlerFailed:
                    CtPs2Printf("illegal function call ext %d\n", action.command);
                    break;
                case EventArgResult::NotFound:
                    CtPs2Printf("not found ext %d\n", action.command);
                    break;
            }
        } catch (const std::exception &error) {
            CT_LOG_ERROR(Script, "luau: {}: could not encode argument string: {}", *module, error.what());
        }
    }
}
