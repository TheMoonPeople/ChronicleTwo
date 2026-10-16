#include "port_options.hpp"

#ifdef PORT

#include <iterator>

#include "options/config_bool.hpp"
#include "menuaqua.hpp"
#include "menucls1.hpp"
#include "menumain.hpp"
#include "menuop.hpp"
#include "options/registry.hpp"
#include "options/retail_system_mes.hpp"
#include "platform/config.hpp"
#include "stubs/menuop.hpp"

namespace {
// Same column windows as CMenuOption::CalcTex (first three manual list slots).
constexpr int kOptionLabelMesWindows[] = {2, 4, 5};
constexpr int kOptionLabelRowsPerWindow = 10;
// Retail option script lays out up to 16 rows (10 in column 0, 6 in column 1 for English).
constexpr int kRetailOptionInlineMessageRows = 17;

s32 g_retail_choice[OPTION_ITEM_MAX];

CDC2Mes *RetailLabelMesWindow(int retail_row) {
    if (retail_row < 0) {
        return nullptr;
    }
    const int column = retail_row / kOptionLabelRowsPerWindow;
    if (column < 0 || column >= static_cast<int>(std::size(kOptionLabelMesWindows))) {
        return nullptr;
    }
    return MenuDCMsg[kOptionLabelMesWindows[column]];
}

int RetailLabelMesSlot(int retail_row) { return retail_row % kOptionLabelRowsPerWindow; }

void SyncBoolFromConfig(const port_settings::Descriptor &entry) {
    if (entry.kind != port_settings::Kind::Bool || entry.retail_row < 0 ||
        entry.retail_row >= OPTION_ITEM_MAX) {
        return;
    }
    const Config config = ConfigGet();
    g_retail_choice[entry.retail_row] = port_settings::ReadConfigBool(config, entry.config_key) ? 1 : 0;
}

bool PatchRetailColumnWindowLabel(const port_settings::Descriptor &entry) {
    if (entry.retail_row < kOptionLabelRowsPerWindow) {
        return false;
    }
    CDC2Mes *mes = RetailLabelMesWindow(entry.retail_row);
    if (mes == nullptr || mes->mes_no <= 0 || mes->buff == nullptr) {
        return false;
    }
    const int slot = RetailLabelMesSlot(entry.retail_row);
    if (!PortRetailReplaceMenuMessageLine(mes->buff, mes->mes_no, slot, entry.label)) {
        return false;
    }
    mes->msg_change = 1;
    return true;
}

bool PatchRetailInlineMenuLabel(const port_settings::Descriptor &entry) {
    if (entry.retail_row < 0 || entry.retail_row >= kRetailOptionInlineMessageRows) {
        return false;
    }
    bool     changed = false;
    short   *main_table = GetMenuMainMessageBuffer();
    CDC2Mes *mes = RetailLabelMesWindow(entry.retail_row);
    short   *window_table = mes != nullptr ? mes->buff : nullptr;

    if (main_table != nullptr &&
        PortRetailReplaceMenuMessageLine(main_table, kRetailOptionMenuMessageColumn0, entry.retail_row,
                                         entry.label)) {
        changed = true;
    }
    if (window_table != nullptr && window_table != main_table &&
        PortRetailReplaceMenuMessageLine(window_table, kRetailOptionMenuMessageColumn0, entry.retail_row,
                                         entry.label)) {
        changed = true;
    }
    if (changed && mes != nullptr) {
        mes->msg_change = 1;
    }
    return changed;
}

} // namespace

void PortOptionsRefreshRetailLabels() {
    for (const auto &entry : port_settings::Descriptors()) {
        if (!port_settings::HasSurface(entry.surfaces, port_settings::Surface::Retail)) {
            continue;
        }
        const int row = entry.retail_row;
        if (row < 0 || row >= OPTION_ITEM_MAX) {
            continue;
        }
        PatchRetailInlineMenuLabel(entry);
        if (row >= kOptionLabelRowsPerWindow) {
            PatchRetailColumnWindowLabel(entry);
            CDC2Mes *mes = RetailLabelMesWindow(row);
            if (mes == nullptr) {
                continue;
            }
            const int slot = RetailLabelMesSlot(row);
            const int sys_id = PortRetailSyntheticSysMesId(row);
            if (mes->item_mes[slot] != sys_id) {
                mes->item_mes[slot] = sys_id;
                mes->msg_change = 1;
            }
            PortRetailRegisterSystemMessageOverride(sys_id, entry.label);
        }
    }
}

void PortOptionsBindRetailValues(CMenuOption *menu) {
    if (menu == nullptr) {
        return;
    }
    for (const auto &entry : port_settings::Descriptors()) {
        if (port_settings::HasSurface(entry.surfaces, port_settings::Surface::Retail) &&
            entry.retail_row >= 0 && entry.retail_row < OPTION_ITEM_MAX) {
            menu->value[entry.retail_row] = &g_retail_choice[entry.retail_row];
        }
    }
}

void PortOptionsAfterScript() {
    PortRetailClearSystemMessageOverrides();
    for (const auto &entry : port_settings::Descriptors()) {
        if (!port_settings::HasSurface(entry.surfaces, port_settings::Surface::Retail)) {
            continue;
        }
        SyncBoolFromConfig(entry);
    }
    PortOptionsRefreshRetailLabels();
    if (CMenuOptionPtr != nullptr) {
        CMenuOptionPtr->UpdateOptionForm();
    }
}

bool PortOptionsOnDecide(int select, int choice) {
    const port_settings::Descriptor *entry = port_settings::FindByRetailRow(select);
    if (entry == nullptr ||
        !port_settings::HasSurface(entry->surfaces, port_settings::Surface::Retail)) {
        return false;
    }
    if (entry->kind == port_settings::Kind::Bool && entry->retail_row >= 0 &&
        entry->retail_row < OPTION_ITEM_MAX) {
        g_retail_choice[entry->retail_row] = choice;
        Config config = ConfigGet();
        port_settings::WriteConfigBool(config, entry->config_key, choice != 0);
        ConfigChange(config);
        return true;
    }
    return false;
}

#endif
