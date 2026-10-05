#include "common.h"
#include "password.hpp"

#include <cstdio>
#include <cstring>

/**
 * Holds the 58 characters a password digit can be, leaving out
 * the easily confused l, o, I and O.
 */
// Initialised data (.data)
static char txt_table__2[] = "0123456789abcdefghijkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ";

/**
 * Holds the state of the scrambling generator.
 */
// Small initialised data (.sdata)
static unsigned int random_seed = 1;
extern const unsigned char at_211__DATA[];

#pragma optimization_level 0
// Code (.text)
#pragma unsigned_char off
/**
 * Gives the digit value of a password character,
 * or -1 when the character is not a digit.
 */
static int search_txt(char c)
{
    for (int i = 0; i < 58; i++)
    {
        if (c == txt_table__2[i])
        {
            return i;
        }
    }
    return -1;
}
#pragma unsigned_char reset
#pragma optimization_level reset

#pragma optimization_level 0
/**
 * Writes a value as eleven base-58 password digits,
 * least significant first, without terminating the text.
 */
static void ConvLongToTxt(unsigned long value, char* text)
{
    s32 i;
    s32 digit;
    for (i = 0; i < 11; i++) {
        text[i] = txt_table__2[0];
    }
    i = 0;
    while (value != 0) {
        digit = value % 58;
        text[i++] = txt_table__2[digit];
        value = value / 58;
    }
}
#pragma optimization_level reset

#pragma optimization_level 0
#pragma unsigned_char off
/**
 * Reads eleven base-58 password digits back into a value
 * and gives 1, or 0 when a character is not a digit.
 */
static int ConvTxtToLong(char* text, unsigned long* value)
{
    long result = 0;
    s32 digit;
    long weight = 1;
    s32 i;
    for (i = 0; i < 11; i++) {
        digit = search_txt(text[i]);
        if (digit < 0)
            return 0;
        result += (s32)digit * weight;
        weight = weight * 58;
    }
    *value = result;
    return 1;
}
#pragma unsigned_char reset
#pragma optimization_level reset

#pragma optimization_level 0
int ConvertBinToTxt(u8* data, int size, char* text)
{
    s32 remaining = size;
    u8 *cursor = data;
    union {
        unsigned long value;
        u8 bytes[8];
    } packed;
    char group[12];
    unsigned long decoded;
    s32 count;
    s32 i;
    *text = 0;
    while (remaining > 0) {
        packed.value = 0;
        count = remaining;
        if (count > 8) {
            count = 8;
        }
        for (i = 0; i < count; i++) {
            packed.bytes[i] = *cursor++;
        }
        ConvLongToTxt(packed.value, group);
        group[11] = 0;
        if (ConvTxtToLong(group, &decoded) == 0 || packed.value != decoded) {
            printf((const char *)at_211__DATA, packed.value);
            return -1;
        }
        strcat(text, group);
        remaining -= count;
    }
    return strlen(text);
}
#pragma optimization_level reset

#pragma optimization_level 0
int ConvertTxtToBin(char* text, u8* data)
{
    char *in = text;
    u8 *out = data;
    s32 length;
    s32 written;
    s32 pos;
    s32 i;
    union {
        unsigned long value;
        u8 bytes[8];
    } decoded;
    length = strlen(text);
    written = 0;
    if (length % 11 != 0) {
        return -1;
    }
    for (pos = 0; pos < length; pos += 11) {
        if (ConvTxtToLong(in, &decoded.value) == 0) {
            return -1;
        }
        in += 11;
        written += 8;
        for (i = 0; i < 8; i++) {
            *out++ = decoded.bytes[i];
        }
    }
    return written;
}
#pragma optimization_level reset

#pragma optimization_level 0
/**
 * Gives the inverted CRC-16/CCITT checksum
 * of a block of bytes.
 */
static int GetCRC(u8* data, int size)
{
    int crc = 0xFFFF;

    for (unsigned int i = 0; i < (unsigned int)size; i++)
    {
        crc ^= data[i] << 8;
        for (unsigned int bit = 0; bit < 8; bit++)
        {
            if (crc & 0x8000)
            {
                crc = (crc << 1) ^ 0x1021;
            }
            else
            {
                crc <<= 1;
            }
        }
    }

    return ~crc & 0xFFFF;
}
#pragma optimization_level reset

#pragma schedule off
/**
 * Advances the scrambling generator
 * and gives its new state.
 */
static unsigned int random()
{
    random_seed = random_seed * 0x21FC436 + 1;
    return random_seed;
}
#pragma schedule reset

#pragma divbyzerocheck on
#pragma optimization_level 0
/**
 * Stores a checksum of the data and key in the block's last two bytes,
 * then scrambles the rest with it and hides the checksum's low byte among them.
 */
static void EncodeBinData(u8* data, int size, u8* key, int key_size)
{
    s32 i;
    u8 mask;
    u32 check;
    u32 swap;
    u32 keyCheck;
    u8 saved;
    check = GetCRC(data, size - 2);
    keyCheck = GetCRC(key, key_size);
    check ^= 0x62D3;
    check ^= keyCheck;
    data[size - 2] = check & 0xFF;
    data[size - 1] = (check >> 8) & 0xFF;
    random_seed = check + 0x5888F27;
    for (i = 0; i < size - 2; i++) {
        mask = (u32)random() >> 24;
        data[i] = (s8)mask ^ (s8)data[i];
    }
    random_seed = 0x14A76E0;
    saved = data[size - 2];
    swap = (u32)random() % (u32)(size - 2);
    data[size - 2] = data[swap];
    data[swap] = saved;
}
#pragma optimization_level reset
#pragma divbyzerocheck reset

#pragma divbyzerocheck on
#pragma optimization_level 0
/**
 * Undoes EncodeBinData's scrambling and gives 1 when the stored
 * checksum agrees with the data and the key, otherwise 0.
 */
static int DecodeBinData(u8* data, int size, u8* key, int key_size)
{
    s32 i;
    u8 mask;
    u32 check;
    u32 swap;
    u8 saved;
    u32 keyCheck;
    u32 crc;
    random_seed = 0x14A76E0;
    saved = data[size - 2];
    swap = (u32)random() % (u32)(size - 2);
    data[size - 2] = data[swap];
    data[swap] = saved;
    check = data[size - 2];
    check |= data[size - 1] << 8;
    random_seed = check + 0x5888F27;
    for (i = 0; i < size - 2; i++) {
        mask = (u32)random() >> 24;
        data[i] = (s8)mask ^ (s8)data[i];
    }
    keyCheck = GetCRC(key, key_size);
    check ^= keyCheck;
    check ^= 0x62D3;
    crc = GetCRC(data, size - 2);
    if (check != crc) {
        return 0;
    }
    return 1;
}
#pragma optimization_level reset
#pragma divbyzerocheck reset

#pragma optimization_level 0
int EncodePassword(u8* data, int size, u8* key, int key_size, char* text, int text_size)
{
    if (size % 8 != 0) {
        return 0;
    }
    if (text_size < size / 8 * 11 + 1) {
        return 0;
    }
    EncodeBinData(data, size, key, key_size);
    s32 length = ConvertBinToTxt(data, size, text);
    if (length <= 0) {
        return 0;
    }
    return 1;
}
#pragma optimization_level reset

#pragma optimization_level 0
int DecodePassword(char* text, u8* data, int size, u8* key, int key_size)
{
    s32 length = strlen(text);
    if (length % 11 != 0) {
        return 0;
    }
    if (size < length / 11 * 8) {
        return 0;
    }
    s32 converted = ConvertTxtToBin(text, data);
    if (converted <= 0) {
        return 0;
    }
    if (DecodeBinData(data, size, key, key_size) == 0) {
        return 0;
    }
    return 1;
}
#pragma optimization_level reset

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/password", at_211__DATA);
