# Headless replay timing

`--headless` advances the logic clock without waiting for wall time. It also advances the complete
sound mixer from those same ticks, without opening a playback device. Voice sample levels,
stream completion and MIDI status therefore describe the same audio position at the same game tick
in every replay. This matters because event scripts use voice levels for facial animation and
stream status for waits.

Interactive runs retain device-driven audio. Setting `DC2_AUDIO_WAV` records a headless replay's
mixed sound through the existing tick-driven WAV capture; only that capture advances the mixer.
`DC2_AUDIO=off` suppresses output while headless audio state still advances for game logic.

Compare captures made with the same binary, input script, frame limit and configuration, using a
fresh save directory for every run. Mixer ownership affects voice-driven poses and expressions; device-clock and tick-clock captures
are not interchangeable. Debug-event input fixtures require `game.debug_mode=true` explicitly in
the fresh replay config; ordinary boot/title/costume fixtures use the default-off configuration.

## Menu and character lifetimes

The MenuReplay CTests require current published data through the DC2_DATA process environment.
They create fresh saves, retain their binary hash and input command, and require completed lifecycle
transitions with live replacement models before accepting the final rendered capture. The cases reopen
Georama, switch party members in town and dungeons, cycle all four playable forms through quick change,
transform through the monster badge menu, equip a weapon whose stance reloads Max's body, and view an equipped weapon
before backing out of the dungeon menu. Every case fails when a character drops out of the scene unreleased, an
equipped part is left unattached, or a character part fails to load because its body retired. Missing data reports
a skip rather than a successful replay.

~~~sh
ctest --test-dir port/build/windows-x64-tests -R '^MenuReplay[.]' --output-on-failure
~~~

Debug jumps enable the retail debug controls. The dungeon quick-change fixture uses the existing
chord of all four shoulder buttons with R3 for its first Ridepod change, disabling the debug mode so subsequent R3 presses
exercise normal Ridepod and monster transformations. Completion assertions verify the loaded character
sequence, including every return to a human, instead of treating an accepted input or a zero exit as proof.
The native ownership contracts and issue-specific findings are in [the memory safety ledger](memory_safety.md).
