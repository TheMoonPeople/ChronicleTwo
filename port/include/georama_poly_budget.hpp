#pragma once

// Retail per-town polygon caps (ps2/src/editdata.cpp GetMaxPolyn) without host scaling.
int GetMaxPolynRetailCap(int map_no);

// Clamps host config values to the supported multiplier range.
int ClampGeoramaPolyMultiplier(int value);

// Applies multiplier to a retail cap; returns 0 when retail_cap is 0.
int ScaleGeoramaPolyBudget(int retail_cap, int multiplier);
