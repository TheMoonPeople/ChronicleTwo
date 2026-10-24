#include <gtest/gtest.h>

#include <array>
#include <filesystem>
#include <string>
#include <vector>

#include "event_func.hpp"
#include "luau_runtime.hpp"
#include "mg_memory.hpp"

namespace {

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

    arguments.BuildArgData(reinterpret_cast<unsigned int *>(handle.data()));

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

    arguments.BuildArgData(reinterpret_cast<unsigned int *>(handle.data()));

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

    arguments.BuildArgData(reinterpret_cast<unsigned int *>(handle.data()));

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

    arguments.BuildArgData(reinterpret_cast<unsigned int *>(handle.data()));

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

    arguments.BuildArgData(reinterpret_cast<unsigned int *>(handle.data()));

    ASSERT_EQ(arguments.list_num, 2);
    EXPECT_EQ(arguments.list->id, 40);
    EXPECT_EQ(arguments.list->next->id, 41);
    EXPECT_EQ(arguments.next_id, 42);
}

TEST_F(EventArgData, DataWithoutMemoryRecordsNothingAndLaterOffsetStillApplies) {
    CEventScriptArg arguments;
    std::string     handle = luau_runtime::MakeHandle("event_arg/null_memory_arg");

    arguments.BuildArgData(reinterpret_cast<unsigned int *>(handle.data()));

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

    arguments.BuildArgData(reinterpret_cast<unsigned int *>(handle.data()));

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

    arguments.BuildArgData(reinterpret_cast<unsigned int *>(handle.data()));

    ASSERT_EQ(arguments.list_num, 1);
    EXPECT_EQ(arguments.list->id, 12);
    EXPECT_EQ(arguments.next_id, 13);
}

} // namespace
