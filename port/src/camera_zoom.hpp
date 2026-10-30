#pragma once

#include <cmath>

#include "cameracontrol.hpp"

class CScene;

/**
 * Retains the walking camera's requested zoom and collision recovery state between updates.
 */
struct CameraZoom {
    static constexpr float min_distance = 30.0f;    /**< Closest requested camera distance. */
    static constexpr float max_distance = 600.0f;   /**< Farthest requested camera distance. */
    static constexpr float wheel_step = 8.0f;       /**< Distance change per wheel step. */
    static constexpr float clearance = 6.0f;        /**< Minimum eye clearance from geometry. */
    static constexpr float release_rate = 0.1f;     /**< Fraction of the remaining distance released per clear tick. */
    static constexpr float release_min = 2.0f;      /**< Minimum distance released per clear tick. */
    static constexpr float lookahead = 32.0f;       /**< Extra distance checked before releasing a shortened view. */
    static constexpr float lookahead_ticks = 60.0f; /**< Turning prediction horizon in logic ticks. */
    static constexpr int   clear_ticks = 15;        /**< Consecutive clear ticks required before releasing distance. */
    static constexpr int   hold_ticks = 45;         /**< Initial hold duration after repeated pull-ins. */
    static constexpr int   max_strikes = 2;         /**< Maximum number of hold-duration doublings. */
    static constexpr int   calm_ticks = 300;        /**< Quiet ticks required to forget a recent pull-in. */
    static constexpr float minor_pull_in = 10.0f;   /**< Minimum pull-in counted toward repeated-collision holds. */

    float requested = 0;                  /**< Distance selected by the player. */
    float allowed = 0;                    /**< Distance currently permitted by collision recovery. */
    int   hold = 0;                       /**< Remaining ticks before distance release may resume. */
    int   clear = 0;                      /**< Consecutive ticks with a clear release corridor. */
    int   strikes = 0;                    /**< Recent distinct pull-ins remembered for hold duration. */
    int   calm = 0;                       /**< Ticks since the latest significant pull-in or decay. */
    bool  pulled = false;                 /**< Whether the current pull-in has yet to begin releasing. */
    float shown_pos[3] = {NAN, NAN, NAN}; /**< Eye shown before the current logic step. */
    float shown_ref[3] = {NAN, NAN, NAN}; /**< Look-at point shown before the current logic step. */
    float heading = NAN;                  /**< Previous pending camera heading. */
    float turn_rate = 0;                  /**< Pending heading change per logic tick. */
    bool  active = false;                 /**< Whether a player-selected zoom controls the distance. */

    /**
     * Returns the pitch-height scale for the requested zoom distance.
     */
    float HeightScale(CCameraControl &camera) const;
    /**
     * Applies wheel input or resets the player-selected distance.
     */
    void Read(CCameraControl &camera, float wheel, bool reset, bool enabled);
    /**
     * Moves the follow camera at the selected distance with collision correction and recovery.
     */
    void Move(CCameraControl &camera, CScene &scene, CCameraControl::Control &control, float *rotation,
              CCPoly *retail_polys = nullptr, int retail_count = 0);
    /**
     * Places the stepped eye in front of obstructing walls and cuts obstructed display interpolation.
     */
    void KeepVisible(CCameraControl &camera, CScene &scene, CCPoly *retail_polys = nullptr, int retail_count = 0);

private:
    /**
     * Returns the distance below which collision recovery follows retail without a hold.
     */
    [[nodiscard]] float Floor(const CameraCtrlParam &retail) const;
    /**
     * Records a collision pull-in and updates the hold for repeated significant collisions.
     */
    void Strike(float drop);
    /**
     * Reports whether collision geometry intersects a view interpolated to the rendered pose.
     */
    bool Swept(CCameraControl &camera, CScene &scene, CCameraControl &rendered, CCPoly *retail_polys,
               int retail_count, bool walking = false) const;
};

/**
 * Reports whether a wall intersects any view with an eye and target interpolated between two poses.
 */
bool CameraViewSweeps(CCPoly *walls, int count, const float *target_a, const float *eye_a, const float *target_b,
                      const float *eye_b);
