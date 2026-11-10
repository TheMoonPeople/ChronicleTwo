#include <algorithm>
#include <array>
#include <memory>
#include <utility>

#include "map.hpp"
#include "mapparts.hpp"
#include "scene.hpp"

namespace dc2::scene {
/**
 * Captures one coherent map relationship without retaining borrowed game objects.
 */
struct MapLink::State {
    /**
     * Distinguishes a following part from a piece carrying its monster.
     */
    enum class Kind {
        Part,
        Piece
    };

    MapView                    map_view;          /**< Scene-issued lifetime of the owned map. */
    dc2::world::PlacedPartView part_view;         /**< Exact placement table and part assignment. */
    dc2::world::PieceView      piece_view;        /**< Exact piece and model assignment for riding links. */
    Kind                       kind = Kind::Part; /**< Behavior applied by this complete relationship. */

    /**
     * Resolves the placement only through its still-live map and assignment.
     */
    CMapParts *GetPart() const {
        const auto *map = map_view.Get();
        return map != nullptr ? part_view.Get(*map) : nullptr;
    }
};

bool MapLink::BindPart(MapView map, std::string_view part_name) {
    if (part_name.empty()) {
        return false;
    }
    auto *owner = map.Get();
    if (owner == nullptr) {
        return false;
    }
    State candidate;
    candidate.map_view = std::move(map);
    candidate.part_view = owner->FindPlacedPart(part_name);
    if (candidate.GetPart() == nullptr) {
        return false;
    }
    state = std::make_shared<State>(std::move(candidate));
    return true;
}

bool MapLink::BindPiece(MapView map, std::string_view part_name, std::string_view piece_name) {
    if (part_name.empty() || piece_name.empty()) {
        return false;
    }
    auto *owner = map.Get();
    if (owner == nullptr) {
        return false;
    }
    State candidate;
    candidate.map_view = std::move(map);
    candidate.part_view = owner->FindPlacedPart(part_name);
    auto *part = candidate.GetPart();
    if (part == nullptr) {
        return false;
    }
    candidate.piece_view = part->FindPieceView(piece_name);
    if (candidate.piece_view.Get() == nullptr) {
        return false;
    }
    candidate.kind = State::Kind::Piece;
    state = std::make_shared<State>(std::move(candidate));
    return true;
}

bool MapLink::SetPartTransform(std::span<const float, 4> position, std::span<const float, 4> rotation) const {
    const auto binding = state;
    if (!binding || binding->kind != State::Kind::Part) {
        return false;
    }
    auto *part = binding->GetPart();
    if (part == nullptr) {
        return false;
    }
    std::array<float, 4> new_position;
    std::array<float, 4> new_rotation;
    std::ranges::copy(position, new_position.begin());
    std::ranges::copy(rotation, new_rotation.begin());
    part->SetPosition(new_position.data());
    part->SetRotation(new_rotation.data());
    return true;
}

bool MapLink::UpdateLinkedPiece(std::span<float, 4> position, std::span<const float, 4> rotation) const {
    const auto binding = state;
    if (!binding || binding->kind != State::Kind::Piece) {
        return false;
    }
    auto *part = binding->GetPart();
    auto *piece = part != nullptr ? binding->piece_view.Get() : nullptr;
    if (piece == nullptr) {
        return false;
    }
    float                matrix[4][4];
    std::array<float, 4> new_position;
    std::array<float, 4> new_rotation;
    part->GetLWMatrix(matrix);
    piece->GetPosition(new_position.data());
    sceVu0ApplyMatrix(new_position.data(), matrix, new_position.data());
    std::ranges::copy(rotation, new_rotation.begin());
    piece->SetRotation(new_rotation.data());
    std::ranges::copy(new_position, position.begin());
    return true;
}

bool MapLink::GetFrameWorldPosition(std::string_view name, std::span<float, 4> position) const {
    const auto binding = state;
    if (!binding || binding->kind != State::Kind::Piece) {
        return false;
    }
    auto *part = binding->GetPart();
    auto *piece = part != nullptr ? binding->piece_view.Get() : nullptr;
    if (piece == nullptr) {
        return false;
    }
    auto *frame = piece->frame_graph.FindFrame(name);
    if (frame == nullptr) {
        return false;
    }
    float                matrix[4][4];
    std::array<float, 4> world_position;
    piece->UpDatePosition();
    frame->GetWorldPosition0(world_position.data());
    part->GetLWMatrix(matrix);
    sceVu0ApplyMatrix(world_position.data(), matrix, world_position.data());
    std::ranges::copy(world_position, position.begin());
    return true;
}
} // namespace dc2::scene
