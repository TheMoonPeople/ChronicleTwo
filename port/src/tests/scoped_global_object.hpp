#pragma once

#include <type_traits>
#include <utility>

namespace dc2::test {

/**
 * Owns a temporary global replacement and restores its predecessor before destroying that replacement.
 */
template <auto &Global, class Object = std::remove_pointer_t<std::remove_reference_t<decltype(Global)>>>
class ScopedGlobalObject {
    using Pointer = std::remove_reference_t<decltype(Global)>;
    Pointer previous_global = Global; /**< Binding that remains owned by the surrounding scope. */
    Object  object;                   /**< Replacement whose lifetime encloses its global binding. */

public:
    /**
     * Constructs the replacement before publishing its address.
     */
    template <class... Args>
    explicit ScopedGlobalObject(Args &&...args) : object(std::forward<Args>(args)...) {
        Global = &object;
    }

    ScopedGlobalObject(const ScopedGlobalObject &) = delete;
    ScopedGlobalObject &operator=(const ScopedGlobalObject &) = delete;
    ScopedGlobalObject(ScopedGlobalObject &&) = delete;
    ScopedGlobalObject &operator=(ScopedGlobalObject &&) = delete;

    /**
     * Restores the previous binding while the replacement is still alive.
     */
    ~ScopedGlobalObject() { Global = previous_global; }

    /**
     * Returns the owned replacement for configuring and checking its state.
     */
    Object &Get() noexcept { return object; }

    /**
     * Returns the owned replacement's address while this scope owns it.
     */
    Object *get() noexcept { return &object; }

    /**
     * Accesses the owned replacement without transferring its ownership.
     */
    Object *operator->() noexcept { return &object; }
};

/**
 * Retains an existing smart-pointer owner until its global binding has been restored.
 */
template <auto &Global, class Owner>
class ScopedGlobalOwner {
    using Pointer = std::remove_reference_t<decltype(Global)>;
    Pointer previous_global = Global; /**< Binding retained by the enclosing scope. */
    Owner   owner;                    /**< Heap object and its original destruction policy. */

public:
    /**
     * Takes ownership before publishing the owned object's address.
     */
    explicit ScopedGlobalOwner(Owner replacement) : owner(std::move(replacement)) { Global = owner.get(); }

    ScopedGlobalOwner(const ScopedGlobalOwner &) = delete;
    ScopedGlobalOwner &operator=(const ScopedGlobalOwner &) = delete;
    ScopedGlobalOwner(ScopedGlobalOwner &&) = delete;
    ScopedGlobalOwner &operator=(ScopedGlobalOwner &&) = delete;

    /**
     * Restores the enclosing binding before releasing the owned heap object.
     */
    ~ScopedGlobalOwner() { Global = previous_global; }

    /**
     * Returns the owned object's address without releasing it.
     */
    auto get() noexcept { return owner.get(); }

    /**
     * Accesses the owned heap object for fixture setup and checks.
     */
    auto operator->() noexcept { return owner.get(); }
};

/**
 * Transfers an existing smart-pointer fixture into an owning global scope.
 */
template <auto &Global, class Owner>
auto BindGlobalOwner(Owner owner) {
    return ScopedGlobalOwner<Global, Owner>(std::move(owner));
}

} // namespace dc2::test
