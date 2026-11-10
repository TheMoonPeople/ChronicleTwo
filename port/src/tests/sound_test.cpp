#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <cfloat>
#include <climits>
#include <cmath>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iterator>
#include <limits>
#include <memory>
#include <string>
#include <vector>

#include "audio/hdbank.hpp"
#include "audio/hsmsg.hpp"
#include "audio/mixer.hpp"
#include "audio/sound_runtime.hpp"
#include "audio/sq.hpp"
#include "audio_bank_fixture.hpp"
#include "dataread.hpp"
#include "ezbgm.hpp"
#include "mg_memory.hpp"
#include "platform/archive_mount.hpp"
#include "platform/arena.hpp"
#include "platform/paths.hpp"
#include "platform/vfs.hpp"
#include "snd_mngr.hpp"
#include "snd_seseq.hpp"
#include "sound.hpp"

namespace fx = dc::test;
namespace fs = std::filesystem;

namespace {

constexpr std::string_view kLoopSequence = R"({"schema_version":1,"kind":"effect_sequence","tick_rate":60,"events":[{"delta":0,"status":176,"data":[110,0]},{"delta":1,"status":176,"data":[110,127]}]})";

bool CreateSequenceMetadata(sndBankInfo &bank, mgCMemory &memory) {
    bank.seseq = dc2::memory::NewArray<sndCSeSeqData>(memory, 1);
    bank.se = dc2::memory::NewArray<sndSeInfo>(memory, 1);
    if (!bank.seseq || !bank.se) {
        return false;
    }
    bank.seseq_num = 1;
    bank.se_num = 1;
    bank.seseq_storage = dc2::memory::ArenaBuffer::Bind(memory,
                                                        {reinterpret_cast<u8 *>(bank.seseq), sizeof(sndCSeSeqData)});
    bank.se_storage = dc2::memory::ArenaBuffer::Bind(memory,
                                                     {reinterpret_cast<u8 *>(bank.se), sizeof(sndSeInfo)});
    std::memset(bank.se, 0, sizeof(sndSeInfo));
    bank.se[0].def_vol = 42;
    bank.seseq[0].name = dc2::memory::ArenaText::Copy(bank.seseq_storage, "sound/loop.json");
    return bank.seseq[0].name.Text().has_value();
}

TEST(SoundMemory, SnapshotSurvivesSourceResetAndPoisonedAddressReuse) {
    static char identity;
    mgCMemory   memory;
    memory.stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(&identity, 512 * sizeof(u_long128))), 512);
    sndBankInfo bank;
    ASSERT_TRUE(CreateSequenceMetadata(bank, memory));
    bank.seseq[0].LoadSMF(kLoopSequence, &memory);
    const auto record = bank.GetSeSeqData(0);
    ASSERT_TRUE(record);
    ASSERT_FALSE(dc2::audio::SequenceEvents(*record).empty());
    ASSERT_TRUE(bank.GetSe(0));
    EXPECT_EQ(bank.GetSe(0)->def_vol, 42);
    int name_index = -1;
    EXPECT_EQ(bank.SearchSeq("SOUND/LOOP.JSON", name_index), SND_SE_TYPE_SESEQ);
    EXPECT_EQ(name_index, 0);
    sndCSeSeq player;
    ASSERT_TRUE(dc2::audio::StartSequence(player, dc2::audio::SequenceEvents(*record), record->tick_rate));
    player.track_num = 0;
    ASSERT_EQ(player.Step(1), 0);
    const auto *old_metadata = bank.seseq;
    memory.stReset();
    auto *replacement = dc2::memory::NewArray<sndCSeSeqData>(memory, 1);
    ASSERT_EQ(replacement, old_metadata);
    std::memset(replacement, 0xA5, sizeof(sndCSeSeqData));
    EXPECT_FALSE(bank.GetSeSeqData(0));
    EXPECT_FALSE(bank.GetSe(0));
    EXPECT_EQ(bank.SearchSeq("sound/loop.json", name_index), SND_SE_TYPE_NONE);
    EXPECT_FALSE(record->name.Text());
    EXPECT_TRUE(dc2::audio::SequenceEvents(*record).empty());
    EXPECT_EQ(player.Step(1), 0);
    EXPECT_TRUE(dc2::audio::SequencePlaying(player));
    ASSERT_NE(player.event, nullptr);
    EXPECT_EQ(player.event->data[1], SND_MIDI_LOOP_START);
    player.Stop();
    EXPECT_FALSE(dc2::audio::SequencePlaying(player));
}

TEST(SoundMemory, SnapshotOutlivesItsMetadataAllocatorAndRejectsItsReconstructedIdentity) {
    static char                                                 identity;
    alignas(mgCMemory) std::array<std::byte, sizeof(mgCMemory)> owner_storage{};
    const auto                                                  destroy = [](mgCMemory *value) { std::destroy_at(value); };
    std::unique_ptr<mgCMemory, decltype(destroy)>               owner(
        std::construct_at(reinterpret_cast<mgCMemory *>(owner_storage.data())), destroy);
    owner->stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(&identity, 512 * sizeof(u_long128))), 512);
    sndBankInfo bank;
    ASSERT_TRUE(CreateSequenceMetadata(bank, *owner));
    bank.seseq[0].LoadSMF(kLoopSequence, owner.get());
    const auto record = bank.GetSeSeqData(0);
    ASSERT_TRUE(record);
    sndCSeSeq player;
    ASSERT_TRUE(dc2::audio::StartSequence(player, dc2::audio::SequenceEvents(*record), record->tick_rate));
    player.track_num = 0;
    owner.reset();
    EXPECT_FALSE(bank.GetSeSeqData(0));
    owner.reset(std::construct_at(reinterpret_cast<mgCMemory *>(owner_storage.data())));
    owner->stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(&identity, 512 * sizeof(u_long128))), 512);
    auto *replacement = dc2::memory::NewArray<sndCSeSeqData>(*owner, 1);
    EXPECT_EQ(replacement, bank.seseq);
    EXPECT_FALSE(bank.GetSeSeqData(0));
    EXPECT_TRUE(dc2::audio::SequenceEvents(*record).empty());
    EXPECT_EQ(player.Step(1), 0);
    EXPECT_TRUE(dc2::audio::SequencePlaying(player));
    player.Stop();
    owner.reset();
}

TEST(SoundMemory, HeapRetirementKeepsPlaybackAndInvalidatesOnlyTheFreedMetadata) {
    static char identity;
    mgCMemory   memory;
    memory.SetHeapMem(reinterpret_cast<u_long128 *>(ArenaBlock(&identity, 512 * sizeof(u_long128))), 512);
    auto *metadata_block = memory.StartStackMode(MG_STACK_MODE_FIT, 32);
    ASSERT_NE(metadata_block, nullptr);
    sndBankInfo bank;
    ASSERT_TRUE(CreateSequenceMetadata(bank, memory));
    memory.EndStackMode();
    auto *events_block = memory.StartStackMode(MG_STACK_MODE_FIT, 16);
    ASSERT_NE(events_block, nullptr);
    bank.seseq[0].LoadSMF(kLoopSequence, &memory);
    memory.EndStackMode();
    const auto record = bank.GetSeSeqData(0);
    ASSERT_TRUE(record);
    const auto events = dc2::audio::SequenceEvents(*record);
    ASSERT_FALSE(events.empty());
    sndCSeSeq player;
    ASSERT_TRUE(dc2::audio::StartSequence(player, events, record->tick_rate));
    player.track_num = 0;
    auto *unrelated = memory.StartStackMode(MG_STACK_MODE_FIT, 8);
    ASSERT_NE(unrelated, nullptr);
    ASSERT_NE(memory.Alloc(2), nullptr);
    memory.EndStackMode();
    memory.Free(unrelated);
    EXPECT_TRUE(bank.GetSeSeqData(0));
    EXPECT_FALSE(dc2::audio::SequenceEvents(*record).empty());
    memory.Free(events_block);
    EXPECT_TRUE(bank.GetSeSeqData(0));
    EXPECT_TRUE(dc2::audio::SequenceEvents(*record).empty());
    EXPECT_TRUE(record->name.Text());
    auto *reused_block = memory.StartStackMode(MG_STACK_MODE_FIT, 16);
    ASSERT_EQ(reused_block, events_block);
    bank.seseq[0].LoadSMF(kLoopSequence, &memory);
    memory.EndStackMode();
    const auto replacement = bank.GetSeSeqData(0);
    ASSERT_TRUE(replacement);
    ASSERT_FALSE(dc2::audio::SequenceEvents(*replacement).empty());
    EXPECT_EQ(dc2::audio::SequenceEvents(*replacement).data(), events.data());
    EXPECT_TRUE(dc2::audio::SequenceEvents(*record).empty());
    memory.Free(metadata_block);
    EXPECT_FALSE(bank.GetSeSeqData(0));
    EXPECT_FALSE(bank.GetSe(0));
    EXPECT_FALSE(record->name.Text());
    EXPECT_EQ(player.Step(1), 0);
    EXPECT_TRUE(dc2::audio::SequencePlaying(player));
    player.Stop();
}

TEST(SoundMemory, PortAtTheArrayEndHasNoSequenceState) {
    sndStopSeSeq(SND_PORT_NUM);
}

TEST(SoundMemory, ReusedSequenceStorageStartsWithSilentOwnedVoiceState) {
    alignas(sndCSeSeq) std::array<std::byte, sizeof(sndCSeSeq)> storage{};
    std::memset(storage.data(), 0xA5, storage.size());
    auto *player = std::construct_at(reinterpret_cast<sndCSeSeq *>(storage.data()));
    EXPECT_EQ(player->port, -1);
    EXPECT_EQ(player->bank, -1);
    EXPECT_FALSE(dc2::audio::SequencePlaying(*player));
    EXPECT_EQ(player->track_num, 8);
    for (const auto &track : player->track) {
        EXPECT_EQ(track.voice_num, 1);
        EXPECT_EQ(track.unk_7, 0);
        for (const auto &voice : track.voice) {
            EXPECT_EQ(voice.active, 0);
            EXPECT_EQ(voice.prog, 0);
            EXPECT_EQ(voice.key, 0);
            EXPECT_EQ(voice.se_id, 0);
        }
    }
    std::destroy_at(player);
    std::memset(storage.data(), 0x5A, storage.size());
    player = std::construct_at(reinterpret_cast<sndCSeSeq *>(storage.data()));
    EXPECT_EQ(player->track[0].voice[0].prog, 0);
    EXPECT_EQ(player->track[0].voice[0].key, 0);
    EXPECT_EQ(player->track[0].voice[0].se_id, 0);
    std::destroy_at(player);
}

TEST(SoundMemory, LoopSequenceAllocationRejectsInvalidCountsBeforeWriting) {
    alignas(u_long128) u_long128 storage[16]{};
    mgCMemory                    memory;
    memory.stSetBuffer(storage, 4);
    CLoopSeMngr loops;
    EXPECT_EQ(loops.Create(-1, &memory), 0);
    EXPECT_EQ(loops.Create(std::numeric_limits<int>::max(), &memory), 0);
    EXPECT_EQ(memory.stGetUsed(), 0);
    EXPECT_TRUE(loops.Entries().empty());
    EXPECT_EQ(loops.Create(1, &memory), 1);
    EXPECT_EQ(loops.Entries().size(), 1u);
    EXPECT_FALSE(loops.Entries().empty());
    const auto *next = memory.Alloc(1);
    EXPECT_GE(reinterpret_cast<std::uintptr_t>(next),
              reinterpret_cast<std::uintptr_t>(loops.Entries().data() + 1));
}

TEST(SoundMemory, EffectSequenceLoopStopsAtItsTerminator) {
    sndSeSeqEvent events[3]{};
    events[0].status = SND_MIDI_CTRL_CHG;
    events[0].data[0] = SND_MIDI_CTRL_LOOP;
    events[0].data[1] = SND_MIDI_LOOP_START;
    events[1].status = SND_MIDI_CTRL_CHG;
    events[1].data[0] = SND_MIDI_CTRL_LOOP;
    events[1].data[1] = SND_MIDI_LOOP_END;
    sndCSeSeq player;
    ASSERT_TRUE(dc2::audio::StartSequence(player, std::span(events), 60));
    player.track_num = 0;
    for (int repetition = 0; repetition < 3; ++repetition) {
        EXPECT_EQ(player.Step(1.0f), 0);
        EXPECT_EQ(player.event, player.loop_event);
        EXPECT_NE(player.event, events);
    }
    player.Count(FLT_MAX);
    EXPECT_EQ(player.tick, INT_MAX);
    EXPECT_EQ(player.wait, INT_MAX);
}

TEST(SoundMemory, NegativeEffectSequenceDeltaIsRejectedBeforeAllocation) {
    char                         document[] = R"({"schema_version":1,"kind":"effect_sequence","tick_rate":60,"events":[{"delta":-1,"status":176,"data":[110,127]}]})";
    sndCSeSeqData                sequence;
    alignas(u_long128) u_long128 storage[16]{};
    mgCMemory                    memory;
    memory.stSetBuffer(storage, 16);
    sequence.LoadSMF(std::string_view(document, sizeof document - 1), &memory);
    EXPECT_TRUE(dc2::audio::SequenceEvents(sequence).empty());
    EXPECT_EQ(sequence.event_num, 0);
    EXPECT_EQ(memory.stGetUsed(), 0);
}

TEST(SoundMemory, EffectSequenceNumericKindsAndLimitsRejectBeforeAllocation) {
    const std::array<std::string, 4> documents{
        R"({"schema_version":1,"kind":"effect_sequence","tick_rate":60,"events":[{"delta":1e100,"status":176,"data":[110,127]}]})",
        R"({"schema_version":1,"kind":"effect_sequence","tick_rate":60,"events":[{"delta":18446744073709551615,"status":176,"data":[110,127]}]})",
        R"({"schema_version":1,"kind":"effect_sequence","tick_rate":1e100,"events":[]})",
        R"({"schema_version":1,"kind":"effect_sequence","tick_rate":60,"events":[{"delta":0,"status":176.5,"data":[110,127]}]})"};
    std::array<u_long128, 8> storage{};
    std::memset(storage.data(), 0xA5, sizeof(storage));
    const auto original = storage;
    mgCMemory  memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    sndCSeSeqData sequence;
    for (auto document : documents) {
        sequence.LoadSMF(document, &memory);
        EXPECT_TRUE(dc2::audio::SequenceEvents(sequence).empty());
        EXPECT_EQ(sequence.event_num, 0);
        EXPECT_EQ(memory.stGetUsed(), 0);
        EXPECT_EQ(storage, original);
    }
}

TEST(SoundMemory, EffectSequenceRejectsShortArenaBeforeWriting) {
    std::string              document = R"({"schema_version":1,"kind":"effect_sequence","tick_rate":60,"events":[{"delta":0,"status":176,"data":[110,127]}]})";
    std::array<u_long128, 2> storage{};
    std::memset(storage.data(), 0xA5, sizeof(storage));
    const auto  original = storage;
    mgCMemory   memory;
    static char key;
    auto       *root = reinterpret_cast<u_long128 *>(ArenaBlock(&key, sizeof(storage)));
    std::memcpy(root, storage.data(), sizeof(storage));
    memory.stSetBuffer(root, 1);
    ASSERT_EQ(memory.stack_size, 1);
    sndCSeSeqData sequence;
    sequence.LoadSMF(document, &memory);
    EXPECT_TRUE(dc2::audio::SequenceEvents(sequence).empty());
    EXPECT_EQ(sequence.event_num, 0);
    EXPECT_EQ(memory.stGetUsed(), 0);
    EXPECT_EQ(std::memcmp(root, original.data(), sizeof(original)), 0);
}

class Sound : public ::testing::Test {
protected:
    void SetUp() override { CSnd.Exit(); }

    void TearDown() override { CSnd.Exit(); }
};

constexpr int          kSePort = 12;
constexpr int          kFrames = 4800;
constexpr int          kOneSecond = 48000;
constexpr std::uint8_t kKey = 60;
constexpr std::uint8_t kId = 1;
constexpr std::uint8_t kOtherId = 2;

std::vector<std::uint8_t> Hd(const fx::BankSpec &spec = {}) {
    return fx::MakeHd(spec);
}

fx::BankSpec OctaveDown() {
    fx::BankSpec spec;
    spec.base_note = 72;
    return spec;
}

std::shared_ptr<audio::Bank> FixtureBank(const std::vector<std::uint8_t> &bytes) {
    const std::string text(bytes.begin(), bytes.end());
    const int         rate = nlohmann::json::parse(text).at("vags").at(0).at("rate");
    return audio::Bank::CreateFromJson(text, [&](const auto &) { return fx::SampleFile(rate); });
}

void LoadBank(int port, const std::vector<std::uint8_t> &bytes) { SoundBindBank(port, FixtureBank(bytes)); }

int AddBank(int port, const std::vector<std::uint8_t> &bytes) { return SoundBindBank(port, FixtureBank(bytes), true); }

void Play(int bank, std::uint8_t id = kId) {
    CSnd.SE_Play(kSePort, bank, 0, kKey, 64, 127, 127, 0x2000, id);
}

void Stop(int bank, std::uint8_t id = kId) {
    CSnd.SE_Stop(kSePort, bank, 0, kKey, id);
}

std::vector<float> Render(int frames) {
    return fx::RenderFrames(audio::DefaultMixer(), frames);
}

int Crossings() {
    return fx::ZeroCrossings(Render(kFrames));
}

// The expected count comes from a standalone mixer: the driver has no bank 0 measurement to compare
// against once the reload has run, and the same key-on on a fresh mixer is the reference bank 0 plays.
int ReferenceCrossings(const std::vector<std::uint8_t> &hd) {
    audio::Mixer mixer(audio::DefaultMixer().Rate());
    mixer.BindBank(kSePort, FixtureBank(hd));
    mixer.SetVolume(kSePort, audio::kFullPortVolume);
    mixer.ShortMessage(kSePort, 0xC0);
    const std::array<std::uint8_t, audio::kHsMsgBytes> key_on{0xFD, 0x10, 0x00, kKey, kId, 127, 0x00};
    mixer.HsMessage(kSePort, key_on);
    return fx::ZeroCrossings(fx::RenderFrames(mixer, kFrames));
}

} // namespace

TEST_F(Sound, SePlaysANoteAfterTheStep) {
    CSnd.Init(4, 0, 40, 0);
    LoadBank(kSePort, Hd());
    CSnd.SetVol(kSePort, 256);

    Play(0);
    EXPECT_EQ(fx::Rms(Render(kFrames)), 0.0);

    CSnd.Step();
    EXPECT_GT(fx::Rms(Render(kFrames)), 0.01);

    Stop(0);
    CSnd.Step();
    Render(kOneSecond);
    EXPECT_LT(fx::Rms(Render(kFrames)), 1e-3);
}

TEST_F(Sound, SeIsGatedOnALoadedBank) {
    CSnd.Init(4, 0, 40, 0);
    CSnd.SetVol(kSePort, 256);

    Play(0);
    CSnd.Step();
    EXPECT_EQ(fx::Rms(Render(kFrames)), 0.0);
}

TEST_F(Sound, SePitchRaisesTheVoice) {
    CSnd.Init(4, 0, 40, 0);
    LoadBank(kSePort, Hd());
    CSnd.SetVol(kSePort, 256);

    Play(0);
    CSnd.Step();
    const int before = Crossings();
    ASSERT_GT(before, 100);

    CSnd.SE_SetPitch(kSePort, 0, 0, kKey, 0x3FFF, kId);
    CSnd.Step();
    const int after = Crossings();

    const double expected = std::exp2(2.0 / 12.0);
    EXPECT_NEAR(static_cast<double>(after) / before, expected, 0.05 * expected);
}

TEST_F(Sound, AddedBankIsSelectedByTheBankNumber) {
    CSnd.Init(4, 0, 40, 0);
    LoadBank(kSePort, Hd());
    ASSERT_EQ(AddBank(kSePort, Hd(OctaveDown())), 0);
    CSnd.SetVol(kSePort, 256);

    Play(0, kId);
    CSnd.Step();
    const int low_count = Crossings();
    ASSERT_GT(low_count, 100);

    // The release tail is counted by ZeroCrossings too, so bank 1 is only measured once it has died away.
    Stop(0, kId);
    CSnd.Step();
    Render(kOneSecond);
    ASSERT_LT(fx::Rms(Render(kFrames)), 1e-3);

    Play(1, kOtherId);
    CSnd.Step();
    const int high_count = Crossings();

    EXPECT_NEAR(static_cast<double>(high_count) / low_count, 0.5, 0.03);
}

TEST_F(Sound, SequencePlaysThroughLoadSeqAndSqPlay) {
    CSnd.Init(4, 0, 40, 0);
    LoadBank(0, Hd());
    const auto sq = fx::MakeSq(60, 100, 960);
    ASSERT_EQ(SoundLoadSequenceJson(0, std::string_view(reinterpret_cast<const char *>(sq.data()), sq.size())), 0);

    CSnd.SQ_Play(0, 0, 256);
    EXPECT_GT(fx::Rms(Render(kFrames)), 0.01);

    // Retail returns before stopping on a bad index, so the note keeps sounding through the call.
    CSnd.SQ_Play(0, 5, 256);
    EXPECT_GT(fx::Rms(Render(kFrames)), 0.01);
}

TEST_F(Sound, SecondLoadReplacesTheBanks) {
    CSnd.Init(4, 0, 40, 0);
    const auto first = Hd();
    LoadBank(kSePort, first);
    ASSERT_EQ(AddBank(kSePort, Hd(OctaveDown())), 0);
    LoadBank(kSePort, first);
    CSnd.SetVol(kSePort, 256);

    Play(1);
    CSnd.Step();

    EXPECT_EQ(Crossings(), ReferenceCrossings(first));
}

TEST_F(Sound, MasterVolumeScalesTheCore) {
    CSnd.Init(4, 0, 40, 0);
    // The reverb tail from the loud window would bleed into the half window and skew the ratio.
    CSnd.SetReverb(0, 0, 0);
    CSnd.SetReverb(1, 0, 0);
    LoadBank(kSePort, Hd());
    CSnd.SetVol(kSePort, 256);

    Play(0);
    CSnd.Step();
    // The exponential attack outlasts the first window, so both measured windows follow it.
    Render(kOneSecond);
    const double full = fx::Rms(Render(kFrames));
    ASSERT_GT(full, 0.01);

    CSnd.SetMasterVol(0, 0x3FFF / 2);
    CSnd.SetMasterVol(1, 0x3FFF / 2);
    const double half = fx::Rms(Render(kFrames));

    EXPECT_NEAR(half / full, 0.5, 0.03);
}

TEST_F(Sound, IntAddressLoadsAreRefused) {
    CSnd.Init(4, 0, 40, 0);
    CSnd.SetVol(kSePort, 256);

    CSnd.LoadHdBd(kSePort, 0, 0, 0, 0);
    CSnd.LoadHdBd2(kSePort, 0, 0, 0, 0);
    EXPECT_EQ(CSnd.LoadHdBdAdd(kSePort, 0, 0, 0, 0), -1);
    EXPECT_EQ(CSnd.LoadSeq(0, 0, 0), -1);

    // A bank loaded by the refused calls would make this note audible, so silence means nothing got loaded.
    Play(0);
    CSnd.Step();
    EXPECT_EQ(fx::Rms(Render(kFrames)), 0.0);
}

TEST_F(Sound, TransferIsAlwaysComplete) {
    CSnd.Init(4, 0, 40, 0);
    EXPECT_NE(CSnd.TransBdState(1), 0);
}

TEST_F(Sound, InitMngrStartsTheDriver) {
    sndInitMngr();
    sndSetMasterVol(0, 0.5f);
    sndSetMasterVol(1, 0.5f);

    sndInitMngr();
    EXPECT_FLOAT_EQ(audio::DefaultMixer().CoreVolume(0), 1.0f);
    EXPECT_FLOAT_EQ(audio::DefaultMixer().CoreVolume(1), 1.0f);
}

TEST(SoundRealData, PublishedBanksAndSequencesLoad) {
    fs::path root;
    if (const auto *selected = std::getenv("DC2_DATA"); selected && *selected) {
        root = fs::u8path(selected);
    } else {
        for (fs::path dir = PathsExecutable().parent_path(); !dir.empty(); dir = dir.parent_path()) {
            if (fs::is_regular_file(dir / "data.zip") || fs::is_directory(dir / "data/snd2")) {
                root = dir / "data";
                break;
            }
            if (dir == dir.parent_path()) {
                break;
            }
        }
    }
    if (root.empty()) {
        GTEST_SKIP() << "no published native sound bundles near test executable";
    }
    const auto archive = root.parent_path() / "data.zip";
    const auto mount = fs::is_regular_file(archive) ? ArchiveMountOpen(archive) : vfs::OpenDirectory(root);
    const auto resolve = [&](const fs::path &relative) {
        std::vector<vfs::Ref> candidates;
        if (const auto index = mount->Find(relative.generic_string())) {
            candidates.emplace_back(mount, *index);
        }
        return candidates;
    };
    std::size_t banks = 0;
    std::size_t sequences = 0;
    for (std::size_t index = 0; index < mount->Count(); ++index) {
        const auto name = mount->Name(index);
        if (!name.starts_with("snd2/") || !name.ends_with(".json")) {
            continue;
        }
        std::vector<std::uint8_t> bytes;
        ASSERT_TRUE(vfs::Read(vfs::Ref(mount, index), bytes)) << name;
        const std::string_view document(reinterpret_cast<const char *>(bytes.data()), bytes.size());
        const auto             kind = nlohmann::json::parse(document).value("kind", "");
        if (kind == "bank") {
            ++banks;
            EXPECT_NE(audio::Bank::CreateFromJsonCandidates(document, resolve), nullptr) << name;
        }
        if (kind == "sequence") {
            ++sequences;
            EXPECT_NE(audio::SqFile::CreateFromJson(document), nullptr) << name;
        }
    }
    EXPECT_GT(banks, 0u);
    EXPECT_GT(sequences, 0u);
}

TEST(SoundMemory, LoopingPoolRejectsResetAndPoisonedAddressReuseBeforeAnyReadOrWrite) {
    alignas(16) u_long128 storage[16]{};
    mgCMemory             memory;
    memory.stSetBuffer(storage, 16);
    CLoopSeMngr loops;
    ASSERT_TRUE(loops.Create(2, &memory));
    auto *previous = loops.Entries().data();
    memory.stReset();
    auto *replacement = dc2::memory::NewArray<SND_LOOP_SE_SEQ>(memory, 2);
    ASSERT_EQ(previous, replacement);
    std::memset(replacement, 0xA5, 2 * sizeof(SND_LOOP_SE_SEQ));
    EXPECT_TRUE(loops.Entries().empty());
    int found = 5;
    EXPECT_EQ(loops.GetLoopSe(&found, 1, 0), nullptr);
    EXPECT_EQ(found, 0);
    loops.Clear();
    loops.Step();
    loops.AllSeStop();
    const auto *bytes = reinterpret_cast<const unsigned char *>(replacement);
    EXPECT_TRUE(std::all_of(bytes, bytes + 2 * sizeof(SND_LOOP_SE_SEQ), [](auto value) { return value == 0xA5; }));
    ASSERT_TRUE(loops.Create(1, &memory));
    EXPECT_EQ(loops.Entries().size(), 1u);
}

TEST(SoundMemory, LoopingPoolValidatesRequestNarrowingAndOutputPointer) {
    alignas(16) u_long128 storage[16]{};
    mgCMemory             memory;
    memory.stSetBuffer(storage, 16);
    CLoopSeMngr loops;
    ASSERT_TRUE(loops.Create(1, &memory));
    EXPECT_EQ(loops.GetLoopSe(nullptr, 1, 0), nullptr);
    EXPECT_EQ(loops.SeLoopPlayStop(0u, 0, INT_MAX, 1.0f, 0.0f, 0), 0);
    EXPECT_EQ(loops.SeLoopPlayStop(0u, 0, 1, 1.0f, 0.0f, INT_MAX), 0);
    EXPECT_EQ(loops.SeLoopPlayStop(0u, 0, 1, std::numeric_limits<float>::quiet_NaN(), 0.0f, 0), 0);
    EXPECT_EQ(loops.Entries()[0].se_id, UINT_MAX);
}

TEST(SoundMemory, LoopingPoolHeapLeaseSurvivesAnotherFreeAndRejectsItsOwnReusedBlock) {
    alignas(16) u_long128 storage[64]{};
    mgCMemory             memory;
    memory.SetHeapMem(storage, 64);
    CLoopSeMngr loops;
    auto       *block = memory.StartStackMode(MG_STACK_MODE_FIT, 16);
    ASSERT_NE(block, nullptr);
    ASSERT_TRUE(loops.Create(2, &memory));
    auto *previous = loops.Entries().data();
    memory.EndStackMode();
    auto *other = memory.StartStackMode(MG_STACK_MODE_FIT, 8);
    ASSERT_NE(other, nullptr);
    ASSERT_NE(memory.Alloc(1), nullptr);
    memory.EndStackMode();
    memory.Free(other);
    EXPECT_EQ(loops.Entries().size(), 2u);
    memory.Free(block);
    EXPECT_TRUE(loops.Entries().empty());
    auto *reused = memory.StartStackMode(MG_STACK_MODE_FIT, 16);
    ASSERT_EQ(reused, block);
    auto *replacement = dc2::memory::NewArray<SND_LOOP_SE_SEQ>(memory, 2);
    ASSERT_EQ(replacement, previous);
    EXPECT_TRUE(loops.Entries().empty());
    EXPECT_EQ(loops.SeLoopPlayStop(0u, 0, 1, 0), 0);
    memory.EndStackMode();
}
