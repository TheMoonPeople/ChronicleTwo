// A DualSense's HD haptics on iOS. iOS gives apps no audio endpoint for the pad, so the actuator signal of
// dualsense_haptics.hpp cannot be played as sound; Core Haptics drives the actuators through GameController
// instead. A thread renders that signal and plays, on each handle, its strength as the intensity and its pitch as
// the sharpness of a continuous haptic event.

import ChronicleBridge
import CoreHaptics
import Foundation
import GameController

private let rate = Int(ct.ios.HapticsRate())
private let tickFrames = rate / 100
private let tick: TimeInterval = 0.01
private let retryTicks = 100
// A one-pole low-pass at this frequency splits each side into a low and a high band: the 60 Hz large motor tone
// lands mostly below it and the 170 Hz small motor tone mostly above.
private let splitHz: Float = 100
// Energies are averaged over about two ticks, so a 60 Hz tone reads steady.
private let average: Float = 0.5

// A flag set on one thread and read on another.
private final class Flag: @unchecked Sendable {
    private let lock = NSLock()
    private var value = false

    func set(_ on: Bool) {
        lock.lock()
        value = on
        lock.unlock()
    }

    func get() -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return value
    }
}

private let ready = Flag()
private var loggedFailure = false

private func fail(_ what: String, _ error: Error?) {
    if !loggedFailure {
        loggedFailure = true
        NSLog("DualSense haptics: %@ failed: %@", what, error?.localizedDescription ?? "unknown error")
    }
}

// One handle's engine and its continuous event, whose intensity and sharpness the thread moves.
private final class Handle {
    var engine: CHHapticEngine?
    var player: CHHapticPatternPlayer?
    var stopped = Flag()
    var playing = false
    var low: Float = 0
    var energy: Float = 0
    var lowEnergy: Float = 0
    var sentIntensity: Float = -1
    var sentSharpness: Float = -1

    func open(_ controller: GCController, _ locality: GCHapticsLocality) -> Bool {
        guard let engine = controller.haptics?.createEngine(withLocality: locality) else {
            fail("creating an engine", nil)
            return false
        }
        self.engine = engine
        // A flag of its own, so a late handler of the engine this one replaces cannot stop it.
        let stopped = Flag()
        self.stopped = stopped
        engine.stoppedHandler = { _ in stopped.set(true) }
        engine.resetHandler = { stopped.set(true) }
        do {
            try engine.start()
        } catch {
            fail("starting an engine", error)
            return false
        }
        let event = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 1),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5),
            ],
            relativeTime: 0, duration: TimeInterval(GCHapticDurationInfinite))
        do {
            player = try engine.makePlayer(with: CHHapticPattern(events: [event], parameters: []))
        } catch {
            fail("creating a player", error)
            return false
        }
        playing = false
        sentIntensity = -1
        sentSharpness = -1
        return true
    }

    func close() {
        if playing {
            try? player?.stop(atTime: CHHapticTimeImmediate)
        }
        engine?.stop(completionHandler: nil)
        player = nil
        engine = nil
        playing = false
    }

    // Measures one side's share of the tick and plays it: the level as intensity, how much of it sits above the
    // split as sharpness.
    func play(_ leftRight: [Float], _ side: Int) {
        let split = 1 - exp(-2 * Float.pi * splitHz / Float(rate))
        var sum: Float = 0
        var lowSum: Float = 0
        for i in 0..<tickFrames {
            let x = leftRight[i * 2 + side]
            low += (x - low) * split
            sum += x * x
            lowSum += low * low
        }
        energy += (sum / Float(tickFrames) - energy) * average
        lowEnergy += (lowSum / Float(tickFrames) - lowEnergy) * average

        let intensity = min(max((2 * energy).squareRoot(), 0), 1)
        let high = energy > 1e-6 ? max(0, 1 - lowEnergy / energy) : 0
        let sharpness = min(max((high - 0.2) / 0.6, 0), 1)

        guard let player else { return }
        if intensity < 0.01 {
            if playing {
                try? player.stop(atTime: CHHapticTimeImmediate)
                playing = false
            }
            return
        }
        if abs(intensity - sentIntensity) < 0.01 && abs(sharpness - sentSharpness) < 0.02 && playing {
            return
        }
        try? player.sendParameters(
            [
                CHHapticDynamicParameter(parameterID: .hapticIntensityControl, value: intensity, relativeTime: 0),
                CHHapticDynamicParameter(parameterID: .hapticSharpnessControl, value: sharpness - 0.5, relativeTime: 0),
            ], atTime: CHHapticTimeImmediate)
        if !playing {
            do {
                try player.start(atTime: CHHapticTimeImmediate)
                playing = true
            } catch {}
        }
        sentIntensity = intensity
        sentSharpness = sharpness
    }
}

private func findDualSense() -> GCController? {
    GCController.controllers().first { $0.productCategory == "DualSense" && $0.haptics != nil }
}

private func run() {
    var signal = [Float](repeating: 0, count: tickFrames * 2)
    var controller: GCController?
    let handles = [Handle(), Handle()]
    var wait = 0
    while true {
        Thread.sleep(forTimeInterval: tick)
        autoreleasepool {
            // An engine also stops when its pad disconnects (CHHapticEngine.StoppedReason.gameControllerDisconnect).
            if controller != nil && (handles[0].stopped.get() || handles[1].stopped.get()) {
                handles.forEach { $0.close() }
                controller = nil
                ready.set(false)
            }
            if controller == nil {
                if wait > 0 {
                    wait -= 1
                    return
                }
                wait = retryTicks
                guard let found = findDualSense() else { return }
                if !handles[0].open(found, .leftHandle) || !handles[1].open(found, .rightHandle) {
                    handles.forEach { $0.close() }
                    return
                }
                NSLog("DualSense haptics: playing on \"%@\" through Core Haptics", found.vendorName ?? "")
                controller = found
                ready.set(true)
            }
            signal.withUnsafeMutableBufferPointer { ct.ios.HapticsRender($0.baseAddress, Int32(tickFrames)) }
            handles[0].play(signal, 0)
            handles[1].play(signal, 1)
        }
    }
}

// Started once, on the first call: a global is initialised lazily and only once.
private let started: Void = {
    let thread = Thread { run() }
    thread.name = "DualSense haptics"
    thread.start()
}()

@_cdecl("IosHapticsReady")
public func iosHapticsReady() -> Bool {
    _ = started
    return ready.get()
}
