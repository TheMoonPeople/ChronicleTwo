"""Float32 rounding and the shortest decimal spellings of script float constants.

A retail float constant is a float32, and the transpiler writes it as the shortest decimal that rounds back to the same
float32. The reference VM in double mode models a constant as that spelling, so its value matches the Luau source.
"""

from __future__ import annotations

import math
import struct


def float32(value: float) -> float:
    """Round a double to the nearest float32, overflowing to a signed infinity."""
    try:
        return struct.unpack("<f", struct.pack("<f", value))[0]
    except OverflowError:
        return math.copysign(math.inf, value)


def shortest(value: float) -> str:
    """Shortest decimal text of a finite magnitude that rounds to the same float32, without a sign."""
    target = float32(value)
    text = f"{value:.9g}"
    for digits in range(1, 10):
        candidate = f"{value:.{digits}g}"
        if float32(float(candidate)) == target:
            text = candidate
            break
    # repr gives the shortest round-tripping spelling with a fraction or exponent.
    return repr(float(text))


def literal(value: float) -> float:
    """The double the Luau source spells for a float constant, keeping its sign; non-finite values are unchanged."""
    if not math.isfinite(value):
        return value
    return math.copysign(float(shortest(abs(value))), value)
