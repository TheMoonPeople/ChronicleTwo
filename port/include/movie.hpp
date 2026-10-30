#pragma once

#include <string_view>

/**
 * @file
 * Declares host video playback through the game movie interface.
 */

/**
 *
 * Plays a replacement movie and tracks whether playback is active.
 *
 */
class CMovie {
public:
    bool is_playing = false; /**< Whether playback has started and has not been stopped. */

    /**
     * Loads a replacement movie from its complete native filename using host-owned playback storage.
     */
    void Load(std::string_view name, int width, int height, bool with_audio, bool loop);

    /**
     *
     * Starts movie playback in the named texture.
     *
     * @mangled Play__6CMovieFPc
     * @address 0x29C9A0
     * @size 0x200
     */
    void Play(char *path);

    /**
     *
     * Advances movie playback and uploads the latest picture.
     *
     * @mangled SwitchThread__6CMovieFv
     * @address 0x29CBA0
     * @size 0x60
     */
    void SwitchThread();

    /**
     *
     * Stops movie playback and releases its resources.
     *
     * @mangled Term__6CMovieFv
     * @address 0x29CC00
     * @size 0x150
     */
    void Term();

    /**
     *
     * Reports whether playback has ended.
     *
     * @mangled EndCheck__6CMovieFv
     * @address 0x29CD50
     * @size 0x40
     */
    int EndCheck();

    /**
     *
     * Reports whether playback has started.
     *
     * @mangled IsStarted__6CMovieFv
     * @address 0x29CD90
     * @size 0x10
     */
    int IsStarted();
};
