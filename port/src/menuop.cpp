#include "common.h"

#include <algorithm>

#include "stubs/menuop.hpp"

// Retail clamps the Options cursor to op_cursorlimmit while the list scrolls. PAL's bottom limit lies
// above the ninth shown row, so this moves it down to the selected row's place in the settled list:
// the cursor's y less how far the button form still has to move. It never moves the limit up.
int PortOptionCursorBottom(int limit, int cursor_y, int form_y, int rest_form_y) {
    return std::max(limit, cursor_y - form_y + rest_form_y);
}
