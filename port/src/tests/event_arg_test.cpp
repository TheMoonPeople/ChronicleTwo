#include <gtest/gtest.h>

#include <array>
#include <cstddef>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <limits>
#include <span>
#include <string>
#include <vector>

#include "event_func.hpp"
#include "luau_runtime.hpp"
#include "mg_memory.hpp"
#include "platform/arena.hpp"

namespace {

std::span<u8> HandleBytes(std::string &handle) {
    return {reinterpret_cast<u8 *>(handle.data()), handle.size()};
}

struct StringArgumentProgram {
    RS_PROG_HEADER          header{};
    RS_PROGDATA             entry{.no = 100, .func = offsetof(StringArgumentProgram, function)};
    funcdata                function{};
    std::array<vmcode_t, 4> code{};
    std::array<char, 201>   name{};

    StringArgumentProgram() {
        std::memcpy(header.magic, "SB2", 3);
        header.main = offsetof(StringArgumentProgram, function);
        header.code = offsetof(StringArgumentProgram, code);
        header.prog = offsetof(StringArgumentProgram, entry);
        header.prog_num = 1;
        code[0] = {.op = RS_OP_PUSH_CONST, .arg1 = RS_CONST_INT, .arg2 = EVENT_ARG_DATA};
        code[1] = {.op = RS_OP_PUSH_CONST, .arg1 = RS_CONST_STR, .arg2 = offsetof(StringArgumentProgram, name) - offsetof(StringArgumentProgram, code)};
        code[2] = {.op = RS_OP_EXT, .arg1 = 2, .arg2 = 0};
        code[3] = {.op = RS_OP_END, .arg1 = 0, .arg2 = 0};
        name.fill('x');
        name.back() = '\0';
    }

    std::span<u8> Bytes() { return {reinterpret_cast<u8 *>(this), sizeof *this}; }
};

class EventArgData : public ::testing::Test {
protected:
    void SetUp() override {
        root = std::filesystem::temp_directory_path() /
               ("ct-event-arg-data-" +
                std::string(::testing::UnitTest::GetInstance()->current_test_info()->name()));
        std::error_code ec;
        std::filesystem::remove_all(root, ec);
        std::filesystem::create_directories(root, ec);
        ASSERT_FALSE(ec);
        std::filesystem::copy(std::filesystem::path(CT_TEST_LUAU_DIR) / "event_arg", root / "event_arg",
                              std::filesystem::copy_options::recursive, ec);
        ASSERT_FALSE(ec);
        luau_runtime::SetScriptsRoot(root);
    }

    void TearDown() override {
        luau_runtime::Shutdown();
        luau_runtime::SetScriptsRoot({});
        std::error_code ec;
        std::filesystem::remove_all(root, ec);
    }

    std::filesystem::path root;
};

TEST_F(EventArgData, BuildsTypedListsInCommandOrderAndCopiesJapaneseTextToCp932) {
    alignas(16) std::array<u_long128, 64> storage{};
    mgCMemory                             memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    CEventScriptArg arguments;
    arguments.memory = &memory;
    std::string handle = luau_runtime::MakeHandle("event_arg/sample_arg");

    arguments.BuildArgData(HandleBytes(handle));

    ASSERT_EQ(arguments.list_num, 2);
    ASSERT_NE(arguments.list, nullptr);
    EXPECT_EQ(arguments.list->id, 40);
    ASSERT_EQ(arguments.list->arg_num, 3);
    EXPECT_EQ(arguments.list->args[0].type, RS_INT);
    EXPECT_EQ(arguments.list->args[0].i, 17);
    EXPECT_EQ(arguments.list->args[1].type, RS_FLOAT);
    EXPECT_FLOAT_EQ(arguments.list->args[1].f, 1.5F);
    EXPECT_EQ(arguments.list->args[2].type, RS_STR);
    EXPECT_STREQ(arguments.list->args[2].s, "\x83\x51\x83\x62\x83\x67");
    ASSERT_NE(arguments.list->next, nullptr);
    EXPECT_EQ(arguments.list->next->id, 41);
    EXPECT_EQ(arguments.next_id, 42);
}

TEST_F(EventArgData, EmptyModuleBuildsNoLists) {
    alignas(16) std::array<u_long128, 64> storage{};
    mgCMemory                             memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    CEventScriptArg arguments;
    arguments.memory = &memory;
    std::string handle = luau_runtime::MakeHandle("event_arg/empty_arg");

    arguments.BuildArgData(HandleBytes(handle));

    EXPECT_EQ(arguments.list, nullptr);
    EXPECT_EQ(arguments.list_num, 0);
    EXPECT_EQ(arguments.next_id, 0);
}

TEST_F(EventArgData, MalformedModuleDoesNotBuildLists) {
    alignas(16) std::array<u_long128, 64> storage{};
    mgCMemory                             memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    CEventScriptArg arguments;
    arguments.memory = &memory;
    std::string handle = luau_runtime::MakeHandle("event_arg/malformed_arg");

    arguments.BuildArgData(HandleBytes(handle));

    EXPECT_EQ(arguments.list, nullptr);
    EXPECT_EQ(arguments.list_num, 0);
    EXPECT_EQ(arguments.next_id, 0);
}

TEST_F(EventArgData, RejectsCommandsThatExceedTheRetailStack) {
    alignas(16) std::array<u_long128, 64> storage{};
    mgCMemory                             memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    CEventScriptArg arguments;
    arguments.memory = &memory;
    std::string handle = luau_runtime::MakeHandle("event_arg/too_many_args_arg");

    arguments.BuildArgData(HandleBytes(handle));

    EXPECT_EQ(arguments.list, nullptr);
    EXPECT_EQ(arguments.list_num, 0);
}

TEST_F(EventArgData, IdOffsetUsesItsFirstValueAndIgnoresExtras) {
    alignas(16) std::array<u_long128, 64> storage{};
    mgCMemory                             memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    CEventScriptArg arguments;
    arguments.memory = &memory;
    std::string handle = luau_runtime::MakeHandle("event_arg/id_offset_extra_arg");

    arguments.BuildArgData(HandleBytes(handle));

    ASSERT_EQ(arguments.list_num, 2);
    EXPECT_EQ(arguments.list->id, 40);
    EXPECT_EQ(arguments.list->next->id, 41);
    EXPECT_EQ(arguments.next_id, 42);
}

TEST_F(EventArgData, DataWithoutMemoryRecordsNothingAndLaterOffsetStillApplies) {
    CEventScriptArg arguments;
    std::string     handle = luau_runtime::MakeHandle("event_arg/null_memory_arg");

    arguments.BuildArgData(HandleBytes(handle));

    EXPECT_EQ(arguments.list, nullptr);
    EXPECT_EQ(arguments.list_num, 0);
    EXPECT_EQ(arguments.next_id, 50);
}

TEST_F(EventArgData, UnknownCommandDoesNotStopLaterLists) {
    alignas(16) std::array<u_long128, 64> storage{};
    mgCMemory                             memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    CEventScriptArg arguments;
    arguments.memory = &memory;
    std::string handle = luau_runtime::MakeHandle("event_arg/unknown_command_arg");

    arguments.BuildArgData(HandleBytes(handle));

    ASSERT_EQ(arguments.list_num, 2);
    EXPECT_EQ(arguments.list->id, 0);
    ASSERT_NE(arguments.list->next, nullptr);
    EXPECT_EQ(arguments.list->next->id, 1);
    EXPECT_EQ(arguments.list->next->args[0].i, 3);
    EXPECT_EQ(arguments.next_id, 2);
}

TEST_F(EventArgData, FloatOffsetTruncatesToItsIntegerPart) {
    alignas(16) std::array<u_long128, 64> storage{};
    mgCMemory                             memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    CEventScriptArg arguments;
    arguments.memory = &memory;
    std::string handle = luau_runtime::MakeHandle("event_arg/float_offset_arg");

    arguments.BuildArgData(HandleBytes(handle));

    ASSERT_EQ(arguments.list_num, 1);
    EXPECT_EQ(arguments.list->id, 12);
    EXPECT_EQ(arguments.next_id, 13);
}

TEST_F(EventArgData, TruncatedModuleHandleCreatesNoArgumentList) {
    alignas(16) std::array<u_long128, 64> storage{};
    mgCMemory                             memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    CEventScriptArg arguments;
    arguments.memory = &memory;
    std::string handle = luau_runtime::MakeHandle("event_arg/sample_arg");
    auto        bytes = HandleBytes(handle);
    arguments.BuildArgData(bytes.first(7));
    EXPECT_EQ(arguments.list_num, 0);
    EXPECT_EQ(arguments.list, nullptr);
}

TEST_F(EventArgData, BytecodeStringListPreflightsItsEntireArenaAllocation) {
    StringArgumentProgram                program;
    alignas(16) std::array<u_long128, 3> small_storage{};
    mgCMemory                            small_memory;
    small_memory.stSetBuffer(small_storage.data(), static_cast<int>(small_storage.size()));
    ASSERT_LT(small_memory.stGetRest(), 21);
    CEventScriptArg small_arguments;
    small_arguments.memory = &small_memory;
    small_arguments.BuildBytecodeArgData(program.Bytes());
    EXPECT_EQ(small_arguments.list_num, 0);
    EXPECT_EQ(small_arguments.list, nullptr);
    EXPECT_EQ(small_memory.stGetUsed(), 0);

    alignas(16) std::array<u_long128, 64> large_storage{};
    mgCMemory                             large_memory;
    large_memory.stSetBuffer(large_storage.data(), static_cast<int>(large_storage.size()));
    CEventScriptArg large_arguments;
    large_arguments.memory = &large_memory;
    large_arguments.BuildBytecodeArgData(program.Bytes());
    ASSERT_EQ(large_arguments.list_num, 1);
    ASSERT_NE(large_arguments.list, nullptr);
    ASSERT_EQ(large_arguments.list->arg_num, 1);
    EXPECT_STREQ(large_arguments.list->args[0].s, program.name.data());
}

TEST_F(EventArgData, TranslatedListsRejectStrictEndAndLockedArenasWithoutAllocating) {
    std::string handle = luau_runtime::MakeHandle("event_arg/sample_arg");
    static char key;
    auto       *storage = reinterpret_cast<u_long128 *>(ArenaBlock(&key, 3 * sizeof(u_long128)));
    mgCMemory   memory;
    memory.stSetBuffer(storage, 3);
    ASSERT_EQ(memory.stGetSize(), 3);
    CEventScriptArg arguments;
    arguments.memory = &memory;
    arguments.BuildArgData(HandleBytes(handle));
    EXPECT_EQ(arguments.list_num, 0);
    EXPECT_EQ(arguments.list, nullptr);
    EXPECT_EQ(memory.stack_used, 0);
    memory.stSetLocked(true);
    arguments.BuildArgData(HandleBytes(handle));
    EXPECT_EQ(arguments.list_num, 0);
    EXPECT_EQ(arguments.list, nullptr);
    EXPECT_EQ(memory.stack_used, 0);
}

TEST_F(EventArgData, ATranslatedStringFailureKeepsItsListEmptyAndNeverPublishesIncompleteArguments) {
    constexpr std::size_t words = 3 + (3 * sizeof(ARG_DATA) + sizeof(u_long128) - 1) / sizeof(u_long128) + 2 + 1;
    static char           key;
    auto                 *storage = reinterpret_cast<u_long128 *>(ArenaBlock(&key, words * sizeof(u_long128)));
    mgCMemory             memory;
    memory.stSetBuffer(storage, static_cast<int>(words));
    ASSERT_EQ(memory.stGetSize(), static_cast<int>(words));
    CEventScriptArg arguments;
    arguments.memory = &memory;
    std::string handle = luau_runtime::MakeHandle("event_arg/sample_arg");
    arguments.BuildArgData(HandleBytes(handle));
    ASSERT_EQ(arguments.list_num, 1);
    ASSERT_NE(arguments.list, nullptr);
    EXPECT_EQ(arguments.list->arg_num, 0);
    EXPECT_EQ(arguments.list->next, nullptr);
    EXPECT_EQ(memory.stack_used, static_cast<int>(words - 1));
}

TEST_F(EventArgData, ReusingTheArenaDiscardsTheRetiredHeadBeforeFollowingAnyOldLink) {
    std::array<u_long128, 64> storage{};
    mgCMemory                 memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    CEventScriptArg arguments;
    arguments.memory = &memory;
    std::string handle = luau_runtime::MakeHandle("event_arg/sample_arg");
    arguments.BuildArgData(HandleBytes(handle));
    ASSERT_EQ(arguments.list_num, 2);
    const auto retired_head = arguments.list_storage;
    memory.stClearUsed();
    std::memset(memory.stack, 0xA5, storage.size() * sizeof(u_long128));
    arguments.BuildArgData(HandleBytes(handle));
    EXPECT_TRUE(retired_head.Bytes().empty());
    ASSERT_EQ(arguments.list_num, 2);
    ASSERT_NE(arguments.list, nullptr);
    EXPECT_EQ(arguments.list->id, 40);
    EXPECT_EQ(arguments.list->arg_num, 3);
    EXPECT_FALSE(arguments.list_storage.Bytes().empty());
}

TEST_F(EventArgData, MaximumListIdentifierRejectsTheAppendBeforeIncrementingIt) {
    {
        std::ofstream output(root / "event_arg" / "limit_arg.luau");
        output << "return {{command=1,args={{type='int',value=2147483647}}},"
                  "{command=0,args={{type='int',value=1}}}}";
    }
    std::array<u_long128, 64> storage{};
    mgCMemory                 memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    CEventScriptArg arguments;
    arguments.memory = &memory;
    std::string handle = luau_runtime::MakeHandle("event_arg/limit_arg");
    arguments.BuildArgData(HandleBytes(handle));
    EXPECT_EQ(arguments.next_id, std::numeric_limits<int>::max());
    EXPECT_EQ(arguments.list_num, 0);
    EXPECT_EQ(arguments.list, nullptr);
    EXPECT_EQ(memory.stack_used, 0);
}

} // namespace
