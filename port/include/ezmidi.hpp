#pragma once

#include "common.h"

/**
 * @file
 * Declares the EE client of the EZMIDI IOP sound server and the EE-to-IOP transfer helper.
 */

/**
 *
 * Bits of an EZMIDI command word that change how its argument and response
 * are exchanged with the IOP server.
 *
 */
enum EzMidiCommandFlag {
    EZMIDI_ARGUMENT_BLOCK = 0x1000, /**< The argument is the EE address of a 64-byte block sent in place of the argument word. */
    EZMIDI_RESPONSE = 0x8000        /**< The server sends back 64 bytes, the first word of which is returned. */
};

/**
 *
 * SIF RPC server number of the EZMIDI IOP sound server.
 *
 */
enum EzMidiRpcServer {
    EZMIDI_RPC_SERVER = 0x12346 /**< Server that ezMidiInit binds and ezMidi calls. */
};

/**
 *
 * Connects the EE client to the EZMIDI RPC server, waiting until the
 * server is bound.
 *
 * @mangled ezMidiInit__Fv
 * @address 0x18C770
 * @size 0x90
 */
int ezMidiInit();

/**
 *
 * Sends one command to the EZMIDI RPC server and returns the first word
 * of its response.
 *
 * @mangled ezMidi__Fii
 * @address 0x18C800
 * @size 0xC0
 */
int ezMidi(int command, int argument);

/**
 *
 * Transfers a block of EE memory into IOP memory and waits for the
 * transfer to complete.
 *
 * @mangled ezTransToIOP2__FPvPvi
 * @address 0x18C8C0
 * @size 0xB0
 */
int ezTransToIOP2(void *iop_address, void *ee_address, int size);
