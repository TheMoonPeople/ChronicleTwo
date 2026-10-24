// The on-screen gamepad of iOS, TheMoonPeople/Chronicle's Android overlay (ChronicleTouchOverlay.java) in UIKit: a
// view over the game's that draws the controls and takes every touch, so no draw call enters the game's frame. Its
// state reaches pad 0 through ct.ios.SetTouchOverlay.

import ChronicleBridge
import UIKit

// Sixteen buttons, then the left and the right stick.
private let controls = 18
private let buttons = 16
private let leftStick = 16

private let labels = ["↑", "↓", "←", "→", "×", "○", "□", "△", "L1", "R1", "L2", "R2", "SELECT", "START", "L3", "R3"]

private let labelColours: [UInt32] = [
    0xedf2ff, 0xedf2ff, 0xedf2ff, 0xedf2ff, 0x73b8ff, 0xff878b, 0xefa1e9, 0x8be7a5,
    0xedf2ff, 0xedf2ff, 0xedf2ff, 0xedf2ff, 0xedf2ff, 0xedf2ff, 0xedf2ff, 0xedf2ff,
]

private let buttonBits: [UInt16] = (0..<buttons).map { ct.ios.ButtonBit(Int32($0)) }

private func colour(_ argb: UInt32) -> UIColor {
    UIColor(red: CGFloat((argb >> 16) & 0xff) / 255, green: CGFloat((argb >> 8) & 0xff) / 255,
            blue: CGFloat(argb & 0xff) / 255, alpha: CGFloat((argb >> 24) & 0xff) / 255)
}

private func clamp(_ value: CGFloat, _ low: CGFloat, _ high: CGFloat) -> CGFloat { max(low, min(high, value)) }

private func same(_ a: ct.ios.TouchState, _ b: ct.ios.TouchState) -> Bool {
    a.buttons == b.buttons && a.left_x == b.left_x && a.left_y == b.left_y && a.right_x == b.right_x &&
        a.right_y == b.right_y
}

final class TouchOverlayView: UIView {
    private var cx = [CGFloat](repeating: 0, count: controls)
    private var cy = [CGFloat](repeating: 0, count: controls)
    private var radius = [CGFloat](repeating: 0, count: controls)
    // Each touch keeps the control it went down on, as on Android: a finger that slides off a button lets go of
    // it, and one that went down on nothing presses nothing.
    private var captures: [ObjectIdentifier: (touch: UITouch, control: Int)] = [:]
    private var last = ct.ios.TouchState()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        backgroundColor = .clear
        isMultipleTouchEnabled = true
        contentMode = .redraw
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    required init?(coder: NSCoder) { nil }

    // Android's layout, in the safe area so the island and the home indicator cover nothing.
    override func layoutSubviews() {
        super.layoutSubviews()
        let area = bounds.inset(by: safeAreaInsets)
        let x0 = area.origin.x, y0 = area.origin.y, w = area.size.width, h = area.size.height
        guard w > 0, h > 0 else { return }
        let s = min(w, h)
        let scale = min(w / 1280, h / 720)
        let r = 46 * scale, small = 44 * scale, step = 104 * scale
        let side = clamp(0.08 + 0.08 * s / w, 0.10, 0.16)
        let left = x0 + side * w, right = x0 + (1 - side) * w, row = y0 + h * 0.52
        for i in 0..<controls {
            radius[i] = i < 12 ? r : i < buttons ? small : 80 * scale
        }
        cx[0] = left; cx[1] = left
        cy[0] = row - step; cy[1] = row + step
        cx[2] = left - step; cx[3] = left + step
        cy[2] = row; cy[3] = row
        cx[4] = right; cx[7] = right
        cy[4] = row + step; cy[7] = row - step
        cx[5] = right + step; cx[6] = right - step
        cy[5] = row; cy[6] = row
        cx[8] = left; cx[10] = left
        cx[9] = right; cx[11] = right
        cy[8] = y0 + h * 0.22; cy[9] = cy[8]
        cy[10] = y0 + h * 0.08; cy[11] = cy[10]
        cx[12] = x0 + w * 0.43; cx[13] = x0 + w * 0.57
        cy[12] = y0 + h * 0.92; cy[13] = cy[12]
        cx[16] = x0 + (side + 0.025) * w; cx[17] = x0 + (1 - side - 0.025) * w
        cy[16] = y0 + h * 0.86; cy[17] = cy[16]
        // Android has no L3 or R3; here they sit beside their sticks, on the side facing the centre.
        cx[14] = cx[16] + radius[16] + small * 1.4
        cx[15] = cx[17] - radius[17] - small * 1.4
        cy[14] = cy[16]; cy[15] = cy[16]
        captures.removeAll()
        publish()
        setNeedsDisplay()
    }

    private func distance(_ control: Int, _ p: CGPoint) -> CGFloat { hypot(p.x - cx[control], p.y - cy[control]) }

    private func hit(_ p: CGPoint) -> Int { (0..<controls).first { distance($0, p) <= radius[$0] } ?? -1 }

    private func publish() {
        var next = ct.ios.TouchState()
        if !isHidden {
            for (touch, control) in captures.values where control >= 0 {
                let p = touch.location(in: self)
                if control < buttons {
                    if distance(control, p) <= radius[control] {
                        next.buttons |= buttonBits[control]
                    }
                    continue
                }
                var x = clamp((p.x - cx[control]) / radius[control], -1, 1)
                var y = clamp((p.y - cy[control]) / radius[control], -1, 1)
                let magnitude = hypot(x, y)
                if magnitude > 1 {
                    x /= magnitude
                    y /= magnitude
                }
                if control == leftStick {
                    next.left_x = Float(x)
                    next.left_y = Float(y)
                } else {
                    next.right_x = Float(x)
                    next.right_y = Float(y)
                }
            }
        }
        if !same(next, last) {
            last = next
            setNeedsDisplay()
        }
        ct.ios.SetTouchOverlay(next)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            captures[ObjectIdentifier(touch)] = (touch, hit(touch.location(in: self)))
        }
        publish()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { publish() }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            captures[ObjectIdentifier(touch)] = nil
        }
        publish()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }

    func setControlsVisible(_ visible: Bool) {
        if isHidden == !visible {
            return
        }
        isHidden = !visible
        if !visible {
            captures.removeAll()
        }
        publish()
    }

    private func disc(_ context: CGContext, _ x: CGFloat, _ y: CGFloat, _ r: CGFloat, fill: UInt32, edge: UInt32) {
        let circle = CGRect(x: x - r, y: y - r, width: 2 * r, height: 2 * r)
        context.setFillColor(colour(fill).cgColor)
        context.fillEllipse(in: circle)
        context.setStrokeColor(colour(edge).cgColor)
        context.setLineWidth(max(1, r * 0.027))
        context.strokeEllipse(in: circle)
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        for i in buttons..<controls {
            disc(context, cx[i], cy[i], radius[i], fill: 0x2920_2a3a, edge: 0x779f_abc0)
            let dx = CGFloat(i == leftStick ? last.left_x : last.right_x)
            let dy = CGFloat(i == leftStick ? last.left_y : last.right_y)
            disc(context, cx[i] + dx * radius[i] * 0.45, cy[i] + dy * radius[i] * 0.45, radius[i] * 0.37,
                 fill: 0x552d_374d, edge: 0xaac9_d7f0)
        }
        for i in 0..<buttons {
            let pressed = last.buttons & buttonBits[i] != 0
            disc(context, cx[i], cy[i], radius[i], fill: pressed ? 0x9928_3450 : 0x3c20_2a3a,
                 edge: pressed ? 0xe6d5_e3ff : 0x99c9_d7f0)
            let size = radius[i] * (i >= 12 ? 0.40 : i >= 8 ? 0.50 : 0.70)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: size, weight: .medium),
                .foregroundColor: colour(0xff00_0000 | labelColours[i]),
            ]
            let label = labels[i] as NSString
            let text = label.size(withAttributes: attributes)
            label.draw(at: CGPoint(x: cx[i] - text.width / 2, y: cy[i] - text.height / 2), withAttributes: attributes)
        }
    }
}

@MainActor private final class TouchOverlayDriver {
    private var view: TouchOverlayView?

    // The game's window comes and goes (the launcher has one of its own), and SDL adds its Metal view after the
    // window, so the overlay is placed on top of whichever window is key, every tick.
    func tick() {
        let window = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .last { $0.isKeyWindow }
        guard let host = window?.rootViewController?.view else { return }
        let overlay = view ?? TouchOverlayView(frame: host.bounds)
        view = overlay
        if overlay.superview !== host {
            overlay.removeFromSuperview()
            overlay.frame = host.bounds
            host.addSubview(overlay)
        } else if host.subviews.last !== overlay {
            host.bringSubviewToFront(overlay)
        }
        overlay.setControlsVisible(ct.ios.TouchOverlayVisible())
    }
}

@MainActor private let driver = TouchOverlayDriver()

@_cdecl("IosTouchOverlayStart")
public func iosTouchOverlayStart() {
    // The game pumps the main run loop from its own loop, which fires this between frames.
    let timer = Timer(timeInterval: 0.1, repeats: true) { _ in MainActor.assumeIsolated { driver.tick() } }
    RunLoop.main.add(timer, forMode: .common)
}
