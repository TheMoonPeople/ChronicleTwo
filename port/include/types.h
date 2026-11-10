#pragma once

#include <kazarov/types.hpp>

#include <cstddef>
#include <cstdint>

/**
 * @file
 * Defines the fixed-width integer aliases and basic C types used by the game.
 */

/** Unsigned 8-bit integer. */
using u8 = std::uint8_t;
/** Unsigned 16-bit integer. */
using u16 = std::uint16_t;
/** Unsigned 32-bit integer. */
using u32 = std::uint32_t;
/** Unsigned 64-bit integer. */
using u64 = std::uint64_t;

/** Signed 8-bit integer. */
using s8 = std::int8_t;
/** Signed 16-bit integer. */
using s16 = std::int16_t;
/** Signed 32-bit integer. */
using s32 = std::int32_t;
/** Signed 64-bit integer. */
using s64 = std::int64_t;

/** SDK spelling for an unsigned byte. */
using u_char = u8;
/** SDK spelling for an unsigned halfword. */
using u_short = u16;
/** SDK spelling for an unsigned word. */
using u_int = u32;
/** SDK spelling for an unsigned long. */
using u_long = u64;
/** SDK spelling for an unsigned quadword. */
using u_long128 = unsigned __int128;

/** An address held in an unsigned native integer. */
using uptr = kz::uptr;
/** An address offset held in a signed native integer. */
using sptr = kz::sptr;
