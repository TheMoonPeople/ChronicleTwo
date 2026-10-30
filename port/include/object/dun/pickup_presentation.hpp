#pragma once

#include <cstdint>

// Presentation history lives outside the retail pickup layout. SetItem begins a new emission.
void mgPortEmitPickup(const void *pickup);

class mgPortPickupScope {
public:
    explicit mgPortPickupScope(const void *pickup);
    ~mgPortPickupScope();
    mgPortPickupScope(const mgPortPickupScope &) = delete;
    mgPortPickupScope &operator=(const mgPortPickupScope &) = delete;

private:
    uint64_t key_;
    uint64_t generation_;
    bool     world_corners_;
    float    teleport_distance_;
};
