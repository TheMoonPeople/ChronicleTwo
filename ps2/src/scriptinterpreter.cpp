#include "common.h"

#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "scriptinterpreter.hpp"

// The inline members of the header are called here, never expanded.
#pragma dont_inline on

static int  SkipSpace(input_str &in);
static u8   CheckChar(char c);
static void PreProcess(input_str &in);

int input_str::GetLine(char *line, int line_size, char *terminator) {
    char crlf[] = "\r\n";
    int  length;
    int  count;
    int  found;
    int  c;

    if (terminator == NULL) {
        terminator = crlf;
    }

    length = strlen(terminator);
    count = 0;
    found = 1;

    for (;;) {
        if (memcmp(&buffer[position], terminator, length) == 0) {
            position += length;
            break;
        }

        if (!get(&c)) {
            found = 0;
            break;
        }

        if (count < line_size - 1) {
            line[count++] = c;
        }
    }

    line[count] = '\0';
    return found;
}

int spiGetStackInt(SPI_STACK *stack) {
    switch (stack->type) {
        case SPI_STACK_TYPE_INT:
            return stack->value.integer;
        case SPI_STACK_TYPE_FLOAT:
            return (int) stack->value.real;
        default:
            return 0;
    }
}

float spiGetStackFloat(SPI_STACK *stack) {
    switch (stack->type) {
        case SPI_STACK_TYPE_INT:
            return (float) stack->value.integer;
        case SPI_STACK_TYPE_FLOAT:
            return stack->value.real;
        default:
            return 0.0f;
    }
}

char *spiGetStackString(SPI_STACK *stack) {
    switch (stack->type) {
        case SPI_STACK_TYPE_STRING:
            return stack->value.string;
        default:
            return NULL;
    }
}

void spiGetStackVector(float *vector, SPI_STACK *stack) {
    vector[0] = spiGetStackFloat(stack++);
    vector[1] = spiGetStackFloat(stack++);
    vector[2] = spiGetStackFloat(stack++);
}

void CScriptInterpreter::PushStack(SPI_STACK argument) {
    if (stack_count >= stack_size) {
        printf("SPI stack over!!\n");
        return;
    }

    stack[stack_count] = argument;
    stack_count++;
}

int CScriptInterpreter::GetNextTAG(int call) {
    char      string_storage[SPI_STRING_BUFF_SIZE];
    SPI_STACK arguments[SPI_STACK_SIZE];
    int       index;
    int       c;
    int       argument_count;

    if (tag == NULL) {
        return -1;
    }

    SetStringBuff(string_storage, SPI_STRING_BUFF_SIZE);

    for (;;) {
        SetStack(arguments, SPI_STACK_SIZE);

        if (!SearchCommand(&index)) {
            return -1;
        }

        if (!binary) {
            if (index >= tag_count || index < 0) {
                // An unknown tag is passed over up to its semicolon.
                for (;;) {
                    if (!get(&c)) {
                        break;
                    }

                    if (c == ';') {
                        break;
                    }
                }

                continue;
            }

            argument_count = GetArg();

            if (call && tag[index].function != NULL) {
                tag[index].function(stack, argument_count);
            }
        } else {
            argument_count = GetArgBin();

            if (index < tag_count && index >= 0 && call && tag[index].function != NULL) {
                tag[index].function(stack, argument_count);
            }
        }

        return index;
    }
}

void CScriptInterpreter::Run() {
    while (GetNextTAG(1) >= 0) {
    }
}

int CScriptInterpreter::hash(char *name) {
    u8 value = 0;

    while (*name != '\0') {
        value = ((value << 8) + *name++) % SPI_HASH_BUCKET_COUNT;
    }

    return value;
}

void CScriptInterpreter::SetTag(SPI_TAG_PARAM *tags) {
    u8            *storage;
    SPI_TAG_PARAM *param;
    int            i;
    int            chain;
    SPI_TAG_HASH  *link;
    SPI_TAG_PARAM *scan;
    SPI_TAG_HASH  *entry;

    tag = tags;
    tag_count = 0;

    for (scan = tag, tag_count = 0; scan->name != NULL && scan->name[0] != '\0'; scan++) {
        tag_count++;
    }

    hash_table = NULL;

    if (tag_count < SPI_HASH_TAG_MAX) {
        // The first links of the chains, and then the links of the tags, are
        // taken in turn from one run of storage.
        storage = (u8 *) hash_buckets;
        hash_table = (SPI_TAG_HASH **) storage;
        storage += sizeof(hash_buckets) + sizeof(unk_1d4);

        for (i = 0; i < SPI_HASH_BUCKET_COUNT; i++) {
            hash_table[i] = NULL;
        }

        param = tag;

        for (i = 0; i < tag_count; i++, param++) {
            entry = (SPI_TAG_HASH *) storage;
            storage += sizeof(SPI_TAG_HASH);
            entry->next = NULL;
            entry->name = param->name;
            entry->index = i;

            // Each link is appended at the tail of its chain.
            chain = hash(param->name);
            link = hash_table[chain];

            if (link == NULL) {
                hash_table[chain] = entry;
            } else {
                for (; link != NULL; link = link->next) {
                    if (link->next == NULL) {
                        link->next = entry;
                        break;
                    }
                }
            }
        }
    }
}

void CScriptInterpreter::SetScript(char *script, int script_size) {
    buffer = script;
    size = script_size;
    position = 0;
    stack_count = 0;
    binary = 0;

    if (strncmp(script, "BIN", 3) == 0) {
        binary = 1;
        // The "BIN" header and its terminator.
        position += 4;
    } else {
        PreProcess(*this);
    }
}

CScriptInterpreter::CScriptInterpreter() {
    buffer = NULL;
    size = 0;
    position = 0;
    stack_count = 0;
    stack = NULL;
    tag = NULL;
}

int CScriptInterpreter::GetArgBin() {
    s8        types[SPI_TOKEN_SIZE];
    SPI_STACK argument;
    int       count;
    int       i;
    int       padding;
    int       length;

    count = *(s16 *) &buffer[position];
    position += 2;

    if (count == 0) {
        return 0;
    }

    for (i = 0; i < count; i++) {
        switch ((u8) buffer[position++]) {
            case SPI_BINARY_ARG_TYPE_INT:
                types[i] = SPI_STACK_TYPE_INT;
                break;
            case SPI_BINARY_ARG_TYPE_FLOAT:
                types[i] = SPI_STACK_TYPE_FLOAT;
                break;
            case SPI_BINARY_ARG_TYPE_STRING:
                types[i] = SPI_STACK_TYPE_STRING;
                break;
        }
    }

    // The values start on a four-byte boundary.
    padding = position % 4;

    if (padding != 0) {
        position += 4 - padding;
    }

    for (i = 0; i < count; i++) {
        argument.type = types[i];

        switch (argument.type) {
            case SPI_STACK_TYPE_INT:
                argument.value.integer = *(int *) &buffer[position];
                position += 4;
                break;
            case SPI_STACK_TYPE_FLOAT:
                argument.value.real = *(float *) &buffer[position];
                position += 4;
                break;
            case SPI_STACK_TYPE_STRING:
                argument.value.string = &buffer[position];
                length = strlen(argument.value.string) + 1;
                padding = length % 4;

                if (padding != 0) {
                    length += 4 - padding;
                }

                position += length;
                break;
        }

        PushStack(argument);
    }

    return count;
}

int CScriptInterpreter::GetArg() {
    char      text[SPI_TOKEN_SIZE];
    SPI_STACK argument;
    int       c;
    int       following;
    int       length;
    int       i;
    char     *value_text;
    int       count;
    int       more;
    int       type;
    int       quotes;
    int       invalid;
    int       non_numeric;

    if (!SkipSpace(*this)) {
        return 0;
    }

    count = 0;
    more = 1;

    do {
        if (!SkipSpace(*this)) {
            return count;
        }

        // Gather the text of one argument, up to a comma or semicolon outside
        // quotes; while this runs, i is non-zero inside quotes.
        length = 0;
        i = 0;

        for (;;) {
            if (!get(&c)) {
                return count;
            }

            if (c == '"') {
                i = !i;
            }

            if (i) {
                if (c & 0x80) {
                    if (c < 0xA1 || c > 0xDF) {
                        // The lead byte of a two-byte Shift-JIS character.
                        text[length++] = c;

                        if (!get(&c)) {
                            return count;
                        }
                    }
                } else if (c == '\\') {
                    if (!get(&following)) {
                        back();
                    } else if (following != '"') {
                        back();
                    } else {
                        c = following;
                    }
                }
            }

            if (!i) {
                if (c == ',') {
                    break;
                }

                if (c == ';') {
                    more = 0;
                    break;
                }
            }

            text[length++] = c;
        }

        if (length == 0 && c == ';') {
            break;
        }

        text[length] = '\0';
        count++;

        // Tell the kind of the argument from its text.
        i = 0;
        type = SPI_STACK_TYPE_INT;
        quotes = 0;
        invalid = 0;
        non_numeric = 0;

        if (text[0] == '"') {
            quotes++;
        }

        if (text[(u32) length - 1] == '"') {
            text[(u32) length - 1] = '\0';
            quotes++;
        }

        for (; text[i] != '\0'; i++) {
            char ch = text[i];

            if (quotes == 0) {
                if (quotes == 0 && ch == '.') {
                    type = SPI_STACK_TYPE_FLOAT;
                }

                if (CheckChar(ch) && text[i] != '-' && text[i] != '.' && (text[i] < '0' || text[i] > '9')) {
                    non_numeric = 1;
                }

                if (!CheckChar(text[i])) {
                    text[i] = '\0';
                    break;
                }
            }
        }

        if (quotes == 2) {
            type = SPI_STACK_TYPE_STRING;
        }

        if (non_numeric && type != SPI_STACK_TYPE_STRING) {
            invalid = 1;
        }

        if (i == 0) {
            invalid = 1;
        }

        argument.type = type;

        if (invalid) {
            argument.value.string = NULL;
            argument.type = SPI_STACK_TYPE_INVALID;
        }

        value_text = text;

        if (type == SPI_STACK_TYPE_STRING) {
            // The text inside the quotes is kept in the string buffer.
            value_text = &text[1];

            if (string_buff_next + strlen(value_text) + 1 > string_buff + string_buff_size) {
                printf("SPI string buffer over!!\n");
                argument.value.string = NULL;
            } else {
                argument.value.string = string_buff_next;
                strcpy(string_buff_next, value_text);
                string_buff_next += strlen(value_text) + 1;
            }
        }

        if (argument.type == SPI_STACK_TYPE_INT) {
            argument.value.integer = atoi(value_text);
        }

        if (argument.type == SPI_STACK_TYPE_FLOAT) {
            argument.value.real = atof(value_text);
        }

        PushStack(argument);
    } while (more);

    return count;
}

int CScriptInterpreter::SearchCommand(int *tag_index) {
    char          name[SPI_TOKEN_SIZE];
    SPI_TAG_HASH *link;
    s16           index;
    int           length;
    int           c;
    int           i;

    if (binary) {
        if (position >= size) {
            return 0;
        }

        index = *(s16 *) &buffer[position];
        position += 2;
        *tag_index = index;
        return index >= 0;
    }

    if (!SkipSpace(*this)) {
        return 0;
    }

    length = 0;

    for (;;) {
        if (!get(&c)) {
            return 0;
        }

        if (!CheckChar(c) || c == ';') {
            // The semicolon ends the arguments, so it is read again by GetArg.
            if (c == ';') {
                back();
            }

            break;
        }

        name[length++] = c;
    }

    name[length] = '\0';

    if (name[0] < 'A' || name[0] > 'Z') {
        *tag_index = -1;
        return 1;
    }

    if (hash_table != NULL) {
        for (link = hash_table[hash(name)]; link != NULL; link = link->next) {
            if (strcmp(name, link->name) == 0) {
                *tag_index = link->index;
                return 1;
            }
        }
    } else {
        for (i = 0; i < tag_count; i++) {
            if (strcmp(tag[i].name, name) == 0) {
                *tag_index = i;
                return 1;
            }
        }
    }

    *tag_index = -1;
    return 1;
}

/**
 *
 * Moves a reader past spaces, tabs and line breaks;
 * gives 1 when text remains to be read and 0 at its end.
 *
 */
static int SkipSpace(input_str &in) {
    char *buffer = in.buffer;
    int   position = in.position;

    while (position < in.size) {
        if (CheckChar(buffer[position])) {
            break;
        }

        position++;
    }

    in.position = position;

    if (position >= in.size) {
        return 0;
    }

    return 1;
}

/**
 *
 * Tells whether a character is part of a word: gives 0 for
 * a space, a tab or a line break and 1 for anything else.
 *
 */
static u8 CheckChar(char c) {
    int space = 0;

    if (c == ' ') {
        space = 1;
    }

    if (c == '\t') {
        space = 1;
    }

    if (c == '\n') {
        space = 1;
    }

    if (c == '\r') {
        space = 1;
    }

    return (space != 0) ^ 1;
}

/**
 *
 * Overwrites the line comments and block comments of a text
 * script with spaces, so that the parser passes over them.
 *
 */
static void PreProcess(input_str &in) {
    u8 *text = (u8 *) in.buffer;
    int i = 0;

    while (i < in.size) {
        if (text[i] == '/' && text[i + 1] == '/') {
            for (; i < in.size; i++) {
                if (text[i] == '\n' || text[i] == '\r') {
                    break;
                }

                text[i] = ' ';
            }
        }

        if (text[i] == '/' && text[i + 1] == '*') {
            for (; i < in.size; i++) {
                if (text[i] == '*' && text[i + 1] == '/') {
                    text[i] = ' ';
                    text[i + 1] = ' ';
                    break;
                }

                text[i] = ' ';
            }
        } else {
            i++;
        }
    }
}
