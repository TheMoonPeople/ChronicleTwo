#include "kazarov_bridge/rust/lib.h"

#include <cstdint>
#include <exception>
#include <fstream>
#include <limits>
#include <mutex>
#include <stdexcept>
#include <string>
#include <unordered_map>
#include <vector>

#include "platform/archive_mount.hpp"

namespace {

namespace fs = std::filesystem;

/**
 * Converts a filesystem path to UTF-8 with '/' separators.
 */
std::string Utf8(const fs::path &path) {
    const auto text = path.generic_u8string();
    return std::string(text.begin(), text.end());
}

/**
 * Serves the entries of one immutable ZIP archive; the central directory is read once when it is opened.
 */
class ArchiveMount final : public vfs::Mount {
public:
    explicit ArchiveMount(const fs::path &path) : file_(path), label_(Utf8(path.filename())) {
        const auto text = Utf8(path);
        try {
            archive_.emplace(kazarov::open_archive(rust::Str(text.data(), text.size())));
        } catch (const std::exception &error) {
            throw std::runtime_error(error.what());
        }
        const auto &archive = **archive_;
        const auto  count = kazarov::archive_entry_count(archive);
        entries_.resize(count);
        index_.reserve(count);
        std::error_code error;
        const auto      size = fs::file_size(path, error);
        const auto      time = error ? fs::file_time_type{} : fs::last_write_time(path, error);
        const auto      prefix = text + '|' + std::to_string(error ? 0 : size) + '|' +
                                 std::to_string(error ? 0 : static_cast<long long>(time.time_since_epoch().count())) + '|';
        for (std::size_t index = 0; index < count; ++index) {
            auto      &entry = entries_[index];
            const auto name = kazarov::archive_entry_name(archive, index);
            entry.name.assign(name.data(), name.size());
            entry.size = kazarov::archive_entry_size(archive, index);
            entry.stored = kazarov::archive_entry_stored(archive, index);
            entry.offset = kazarov::archive_entry_data_offset(archive, index);
            entry.stamp = prefix + std::to_string(kazarov::archive_entry_crc(archive, index)) + '|' +
                          std::to_string(entry.size) + '|' + std::to_string(entry.offset);
            if (!index_.emplace(vfs::FoldKey(entry.name), index).second) {
                throw std::runtime_error("paths differ only by ASCII case: " + entry.name);
            }
        }
    }

    std::size_t Count() const override { return entries_.size(); }

    std::string Name(std::size_t index) const override { return entries_.at(index).name; }

    std::string Display(std::size_t index) const override { return label_ + '!' + entries_.at(index).name; }

    std::optional<std::size_t> Find(std::string_view relative) const override {
        const auto found = index_.find(vfs::FoldKey(relative));
        return found == index_.end() ? std::nullopt : std::optional(found->second);
    }

    std::optional<std::uint64_t> Size(std::size_t index) const override { return entries_.at(index).size; }

    bool Read(std::size_t index, std::vector<std::uint8_t> &bytes, std::uint64_t max_bytes) const override {
        bytes.clear();
        const auto size = entries_.at(index).size;
        if (size > max_bytes || size > std::numeric_limits<std::size_t>::max()) {
            return false;
        }
        bytes.resize(static_cast<std::size_t>(size));
        if (!ReadInto(index, bytes.data(), bytes.size())) {
            bytes.clear();
            return false;
        }
        return true;
    }

    bool ReadInto(std::size_t index, void *buffer, std::size_t size) const override {
        if (index >= entries_.size() || entries_[index].size != size) {
            return false;
        }
        if (size == 0) {
            return true;
        }
        try {
            kazarov::archive_read_entry(**archive_, index, rust::Slice<std::uint8_t>(static_cast<std::uint8_t *>(buffer), size));
            return true;
        } catch (const std::exception &) {
            return false;
        }
    }

    bool ReadPrefix(std::size_t index, std::span<std::uint8_t> out) const override {
        const auto &entry = entries_.at(index);
        if (out.size() > entry.size) {
            return false;
        }
        if (!entry.stored) {
            return Mount::ReadPrefix(index, out);
        }
        // A stored entry's leading bytes are read without copying and checking the whole entry.
        std::ifstream file(file_, std::ios::binary);
        file.seekg(static_cast<std::streamoff>(entry.offset));
        file.read(reinterpret_cast<char *>(out.data()), static_cast<std::streamsize>(out.size()));
        return file && static_cast<std::size_t>(file.gcount()) == out.size();
    }

    std::string Stamp(std::size_t index) const override { return entries_.at(index).stamp; }

    std::optional<vfs::StoredRange> Stored(std::size_t index) const override {
        const auto &entry = entries_.at(index);
        if (!entry.stored) {
            return std::nullopt;
        }
        return vfs::StoredRange{file_, entry.offset, entry.size};
    }

    std::vector<vfs::Member> List(std::string_view directory) const override {
        std::call_once(listing_once_, [this] { BuildListing(); });
        const auto found = listing_.find(vfs::FoldKey(directory));
        return found == listing_.end() ? std::vector<vfs::Member>{} : found->second;
    }

private:
    /**
     * One archive entry's name, location and stamp.
     */
    struct Entry {
        std::string   name;           /**< Relative name in its original case. */
        std::uint64_t size = 0;       /**< Uncompressed size in bytes. */
        std::uint64_t offset = 0;     /**< Data offset within the archive file. */
        bool          stored = false; /**< Whether the data is uncompressed. */
        std::string   stamp;          /**< Archive identity with the entry's CRC, size and offset. */
    };

    /**
     * Groups every entry and implied directory under its parent directory's folded name.
     */
    void BuildListing() const {
        std::unordered_map<std::string, std::unordered_map<std::string, vfs::Member> > members;
        for (const auto &entry : entries_) {
            std::size_t start = 0;
            while (true) {
                const auto slash = entry.name.find('/', start);
                const auto parent = vfs::FoldKey(std::string_view(entry.name).substr(0, start ? start - 1 : 0));
                const auto name = entry.name.substr(start, slash == std::string::npos ? std::string::npos : slash - start);
                auto      &children = members[parent];
                if (slash == std::string::npos) {
                    children.insert_or_assign(vfs::FoldKey(name), vfs::Member{name, false});
                    break;
                }
                children.try_emplace(vfs::FoldKey(name), vfs::Member{name, true});
                start = slash + 1;
            }
        }
        for (auto &[parent, children] : members) {
            auto &list = listing_[parent];
            for (auto &[key, member] : children) {
                list.push_back(std::move(member));
            }
        }
    }

    fs::path                                                           file_;         /**< Archive file. */
    std::string                                                        label_;        /**< Archive filename shown in diagnostics. */
    std::optional<rust::Box<kazarov::Archive> >                        archive_;      /**< Open archive. */
    std::vector<Entry>                                                 entries_;      /**< Entries in central-directory order. */
    std::unordered_map<std::string, std::size_t>                       index_;        /**< Folded names mapped to entries. */
    mutable std::once_flag                                             listing_once_; /**< Builds the directory listing on first use. */
    mutable std::unordered_map<std::string, std::vector<vfs::Member> > listing_;      /**< Direct members per folded directory. */
};

} // namespace

std::shared_ptr<const vfs::Mount> ArchiveMountOpen(const std::filesystem::path &path) {
    return std::make_shared<ArchiveMount>(path);
}
