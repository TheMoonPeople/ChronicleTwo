#include "common.h"

#include "editanalyze.hpp"
#include "georama_poly_budget.hpp"
#include "platform/config.hpp"

int ClampGeoramaPolyMultiplier(int value) {
    if (value < 1) {
        return 1;
    }
    if (value > 6) {
        return 6;
    }
    return value;
}

int GetMaxPolynRetailCap(int map_no) {
    int max_polygons = 0xFA0;

    if (map_no != EDIT_ANALYZE_MAP_MOON_FLOWER) {
        max_polygons = 0x1770;

        switch (map_no) {
            case EDIT_ANALYZE_MAP_SHARLOT:
                return 0xFA0;
            case EDIT_ANALYZE_MAP_STERA:
                return 0x1770;
            case EDIT_ANALYZE_MAP_BENIETIO:
                return 0x1770;
            case EDIT_ANALYZE_MAP_HEIM:
                return max_polygons;
            default:
                return 0;
        }
    }

    return max_polygons;
}

int ScaleGeoramaPolyBudget(int retail_cap, int multiplier) {
    if (retail_cap == 0) {
        return 0;
    }
    return retail_cap * ClampGeoramaPolyMultiplier(multiplier);
}

PORT_OVERRIDE int GetMaxPolyn(int map_no) {
    const int retail = GetMaxPolynRetailCap(map_no);
    if (retail == 0) {
        return 0;
    }
    return ScaleGeoramaPolyBudget(retail, ConfigGet().georama_poly_multiplier);
}
