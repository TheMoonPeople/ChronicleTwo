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
    int i;

    for (i = 0; i < 11; i++)
    {
        text[i] = txt_table__2[0];
    }

    i = 0;
    while (value != 0)
    {
        text[i++] = txt_table__2[value % 58];
        value /= 58;
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
    unsigned long result = 0;
    unsigned long place = 1;

    for (int i = 0; i < 11; i++)
    {
        int digit = search_txt(text[i]);
        if (digit < 0)
        {
            return 0;
        }
        result += digit * place;
        place *= 58;
    }

    *value = result;
    return 1;
}
#pragma unsigned_char reset
#pragma optimization_level reset

#pragma optimization_level 0
int ConvertBinToTxt(u8* data, int size, char* text)
{
    text[0] = '\0';

    for (int remaining = size; remaining > 0;)
    {
        unsigned long value = 0;
        char group[12];
        unsigned long check;

        int count = remaining;
        if (count > 8)
        {
            count = 8;
        }
        for (int i = 0; i < count; i++)
        {
            ((u8*)&value)[i] = *data++;
        }

        ConvLongToTxt(value, group);
        group[11] = '\0';

        if (ConvTxtToLong(group, &check) == 0 || value != check)
        {
            printf("err %lu\n", value);
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
    int length = strlen(text);
    int count = 0;

    if (length % 11 != 0)
    {
        return -1;
    }

    for (int pos = 0; pos < length; pos += 11)
    {
        unsigned long value;

        if (ConvTxtToLong(text, &value) == 0)
        {
            return -1;
        }
        text += 11;
        count += 8;

        for (int i = 0; i < 8; i++)
        {
            *data++ = ((u8*)&value)[i];
        }
    }

    return count;
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
    unsigned int crc = GetCRC(data, size - 2) ^ 0x62D3 ^ GetCRC(key, key_size);
    data[size - 2] = crc;
    data[size - 1] = crc >> 8;

    random_seed = crc + 0x5888F27;
    for (int i = 0; i < size - 2; i++)
    {
        data[i] ^= (u8)(random() >> 24);
    }

    random_seed = 0x14A76E0;
    u8 low = data[size - 2];
    unsigned int swap = random() % (size - 2);
    data[size - 2] = data[swap];
    data[swap] = low;
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
    random_seed = 0x14A76E0;
    u8 low = data[size - 2];
    unsigned int swap = random() % (size - 2);
    data[size - 2] = data[swap];
    data[swap] = low;

    int crc = data[size - 2] | (data[size - 1] << 8);
    random_seed = crc + 0x5888F27;
    for (int i = 0; i < size - 2; i++)
    {
        data[i] ^= (u8)(random() >> 24);
    }

    if ((crc ^ GetCRC(key, key_size) ^ 0x62D3) != GetCRC(data, size - 2))
    {
        return 0;
    }
    return 1;
}
#pragma optimization_level reset
#pragma divbyzerocheck reset

#pragma optimization_level 0
int EncodePassword(u8* data, int size, u8* key, int key_size, char* text, int text_size)
{
    if (size % 8 != 0)
    {
        return 0;
    }
    if (text_size < size / 8 * 11 + 1)
    {
        return 0;
    }

    EncodeBinData(data, size, key, key_size);
    if (ConvertBinToTxt(data, size, text) <= 0)
    {
        return 0;
    }
    return 1;
}
#pragma optimization_level reset

#pragma optimization_level 0
int DecodePassword(char* text, u8* data, int size, u8* key, int key_size)
{
    int length = strlen(text);

    if (length % 11 != 0)
    {
        return 0;
    }
    if (size < length / 11 * 8)
    {
        return 0;
    }
    if (ConvertTxtToBin(text, data) <= 0)
    {
        return 0;
    }
    if (DecodeBinData(data, size, key, key_size) == 0)
    {
        return 0;
    }
    return 1;
}
#pragma optimization_level reset

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/password", at_211__DATA);
