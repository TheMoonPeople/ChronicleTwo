#pragma once

#include "common.h"

/**
 * @file
 * Declares the EE client of the EZBGM IOP stream server, which plays
 * streamed audio files on numbered stream channels.
 */

/**
 *
 * Command words of the EZBGM server that change how a request's argument
 * is exchanged; the low four bits of a command word carry the channel.
 *
 */
// clang-format off
enum EzBgmCommand {
    EZBGM_CHANNEL_MASK    = 0x000F, /**< Bits of a command word holding the stream channel. */
    EZBGM_COMMAND_MASK    = 0xFFF0, /**< Bits of a command word holding the command itself. */
    EZBGM_PRELOAD         = 0x0040, /**< Starts an opened channel buffering; sent without waiting for the server. */
    EZBGM_OPEN            = 0x8020, /**< Opens a stream file; the argument is the address of a 64-byte block holding its name. */
    EZBGM_OPEN_FROM_PACK  = 0x80F0, /**< Opens a stream file held in a file pack; the argument is the address of a 64-byte block holding the names. */
    EZBGM_UNK_8A00        = 0x8A00, /**< Takes the address of a 64-byte block as its argument. */
};

// clang-format on

/**
 *
 * Connects the EE client to the EZBGM RPC server, waiting until the
 * server is bound.
 *
 * @mangled ezBgmInit__Fv
 * @address 0x28EB50
 * @size 0xA0
 */
int ezBgmInit();

/**
 *
 * Sends one command to the EZBGM RPC server and returns the first word
 * of its response, or zero when the server is still busy.
 *
 * @mangled ezBgm__Fii
 * @address 0x28EBF0
 * @size 0x190
 */
int ezBgm(int command, int argument);
