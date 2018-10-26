//
//  Color.swift
//  Rainbow
//
//  Created by Quentin Jin on 2018/10/26.
//

import Foundation

public struct Color {

    private let r: Double
    private let g: Double
    private let b: Double
    private let a: Double

    private init(r: Double, g: Double, b: Double, a: Double) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }

    /// Color(red: 3, green: 102, blue: 214)
    /// Color(red: 3, green: 102, blue: 214, alpha: 0.5)
    public init(red: Int, green: Int, blue: Int, alpha: Double = 1) {
        r = Double(red).clamp(min: 0, max: 255) / 255
        g = Double(green).clamp(min: 0, max: 255) / 255
        b = Double(blue).clamp(min: 0, max: 255) / 255
        a = alpha.clamp(min: 0, max: 1)
    }

    public init(hue: Int, saturation: Double, value: Double, alpha: Double) {
        let h = Double(hue).clamp(min: 0, max: 360)
        let s = saturation.clamp(min: 0, max: 1)
        let v = value.clamp(min: 0, max: 1)
        let a = alpha.clamp(min: 0, max: 1)

        let hi = Int(fmod(floor(h / 60), 6))

        let f = h / 60 - floor(h)
        let p = v * (1 - s)
        let q = v * (1 - (s * f))
        let t = v * (1 - (s * (1 - f)))

        switch (hi) {
        case 0:
            self.init(r: v, g: t, b: p, a: a)
        case 1:
            self.init(r: q, g: v, b: p, a: a)
        case 2:
            self.init(r: p, g: v, b: t, a: a)
        case 3:
            self.init(r: p, g: q, b: v, a: a)
        case 4:
            self.init(r: t, g: p, b: v, a: a)
        case 5:
            self.init(r: v, g: p, b: q, a: a)
        default:
            self.init(r: 0, g: 0, b: 0, a: 0)   // "Never"
        }
    }

    public init(hue: Int, saturation: Double, lightness: Double, alpha: Double) {
        let h = Double(hue).clamp(min: 0, max: 360)
        let s = saturation.clamp(min: 0, max: 1)
        let l = lightness.clamp(min: 0, max: 1)
        let a = alpha.clamp(min: 0, max: 1)

        if (s == 0) {
            self.init(r: l, g: l, b: l, a: a)
            return
        }

        let hue2rgb = { (p: Double, q: Double, t: Double) -> Double in
            var tc = t
            if tc < 0 { tc += 1 }
            if tc > 1 { tc -= 1 }
            if tc < 1 / 6 { return p + (q - p) * 6 * tc }
            if tc < 1 / 2 { return q }
            if tc < 2 / 3 { return p + (q - p) * (2 / 3 - tc) * 6 }
            return p
        }

        let q = l < 0.5 ? (l + l * s) : (l + s - l * s)
        let p = 2 * l - q

        let r = hue2rgb(p, q, h + 1 / 3)
        let g = hue2rgb(p, q, h)
        let b = hue2rgb(p, q, h - 1 / 3)
        self.init(r: r, g: g, b: b, a: a)
    }

    /// "#0366d6"    "0366d6"
    /// "#139"       "139"
    /// "#0366d607"  "0366d607"
    /// "#139f"      "139f"
    public init?(hex s: String) {
        var hex = s.lowercased()
        if hex.hasPrefix("#") {
            hex.removeFirst()
        }
        if hex.count == 3 || hex.count == 4 {
            var s = ""
            hex.forEach { s.append($0); s.append($0) }
            hex = s
        }
        guard var n = Int(hex, radix: 16) else {
            return nil
        }

        var a = 1.0
        if hex.count == 8 {
            a = Double(n & 0xff) / 255
            n >>= 8
        }
        let r = (n >> 16) & 0xff
        let g = (n >> 8) & 0xff
        let b = n & 0xff
        self.init(red: r, green: g, blue: b, alpha: a)
    }

    /// "rgb(3, 102, 214)"
    /// "rgba(3, 102, 214, 1)"
    public init?(rgb s: String) {
        let pattern = "^rgba?\\((\\d+),\\s?(\\d+),\\s?(\\d+)(?:,\\s*((?:0\\.)?\\d+))?\\)$"

        let captures = NSRegularExpression.match(s, pattern: pattern)
        guard captures.count >= 4,
            let r = Int(captures[1]),
            let g = Int(captures[2]),
            let b = Int(captures[3]) else {
                return nil
        }

        var alpha = 0.0
        if captures.count > 4, let a = Double(captures[4]) {
            alpha = a
        } else {
            alpha = 1
        }

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }

    /// "rgb(3, 102, 214)"
    /// "rgba(3, 102, 214, 1)"
    public init?(rgba s: String) {
        self.init(rgb: s)
    }

    /// "hsv(245, 100%, 25%)"
    /// "hsva(245, 100%, 25%, 0.6)"
    public init?(hsv s: String) {
        let pattern = "^hsva?\\((\\d+)(?:deg)?,\\s?(\\d+)%,\\s?(\\d+)%(?:,\\s*((?:0\\.)?\\d+))?\\)$"

        let captures = NSRegularExpression.match(s, pattern: pattern)
        guard captures.count >= 4,
            let h = Int(captures[1]),
            let s = Double(captures[2]),
            let v = Double(captures[3]) else {
                return nil
        }

        var alpha = 0.0
        if captures.count > 4, let a = Double(captures[4]) {
            alpha = a
        } else {
            alpha = 1
        }

        self.init(hue: h, saturation: s, value: v, alpha: alpha)
    }

    /// "hsv(245, 100%, 25%)"
    /// "hsva(245, 100%, 25%, 0.6)"
    public init?(hsva s: String) {
        self.init(hsv: s)
    }

    /// "hsl(245, 100%, 25%)"
    /// "hsla(245, 100%, 25%, 0.6)"
    public init?(hsl s: String) {
        let pattern = "^hsla?\\((\\d+)(?:deg)?,\\s?(\\d+)%,\\s?(\\d+)%(?:,\\s*((?:0\\.)?\\d+))?\\)$"

        let captures = NSRegularExpression.match(s, pattern: pattern)
        guard captures.count >= 4,
            let h = Int(captures[1]),
            let s = Double(captures[2]),
            let l = Double(captures[3]) else {
                return nil
        }

        var alpha = 0.0
        if captures.count > 4, let a = Double(captures[4]) {
            alpha = a
        } else {
            alpha = 1
        }

        self.init(hue: h, saturation: s, lightness: l, alpha: alpha)
    }

    /// "hsl(245, 100%, 25%)"
    /// "hsla(245, 100%, 25%, 0.6)"
    public init?(hsla s: String) {
        self.init(hsl: s)
    }
}

// MARK: - components
extension Color {

    public var rgba: (red: Int, green: Int, blue: Int, alpha: Double) {
        return (red: Int(r * 255), green: Int(g * 255), blue: Int(b * 255), alpha: a)
    }

    public var hsva: (hue: Int, saturation: Double, value: Double, alpha: Double) {
        let max = Swift.max(r, g, b)
        let min = Swift.min(r, g, b)

        let v = max

        var h = 0

        let diff = max - min
        if diff == 0 {
            return (hue: 0, saturation: 0, value: 0, alpha: 0)
        } else {
            if max == r && g >= b {
                h = Int((g - b) / diff * 60)
            } else if max == r && g < b {
                h = Int((g - b) / diff * 60) + 360
            } else if max == g {
                h = Int((b - r) / diff * 60) + 120
            } else {
                h = Int((r - g) / diff * 60) + 240
            }
        }

        let s = max == 0 ? 0 : (diff / max)
        return (hue: h, saturation: s, value: v, alpha: a)
    }

    public var hsla: (hue: Int, saturation: Double, lightness: Double, alpha: Double) {
        let max = Swift.max(r, g, b)
        let min = Swift.min(r, g, b)

        let l = (max + min) / 2

        var h = 0

        let diff = max - min
        if diff == 0 {
            return (hue: 0, saturation: 0, lightness: 0, alpha: 0)
        } else {
            if max == r && g >= b {
                h = Int((g - b) / diff * 60)
            } else if max == r && g < b {
                h = Int((g - b) / diff * 60) + 360
            } else if max == g {
                h = Int((b - r) / diff * 60) + 120
            } else {
                h = Int((r - g) / diff * 60) + 240
            }
        }

        var s = 0.0
        if l == 0 || diff == 0 {
            s = 0
        } else if l > 0 && l <= 0.5 {
            s = diff / l / 2
        } else {
            s = diff / (2 - 2 * l)
        }
        return (hue: h, saturation: s, lightness: l, alpha: a)
    }
}

// MARK: - Hashable & Equatable
extension Color: Hashable {

    public var hashValue: Int {
        var hasher = Hasher()
        r.hash(into: &hasher)
        g.hash(into: &hasher)
        b.hash(into: &hasher)
        a.hash(into: &hasher)
        return hasher.finalize()
    }

    public static func == (lhs: Color, rhs: Color) -> Bool {
        return lhs.r == rhs.r && lhs.g == rhs.g && lhs.b == rhs.b && lhs.a == rhs.a
    }
}

// MARK: - Misc
extension Color {

    public static var random: Color {
        let randomRGB = { Int.random(in: 0...255) }
        let randomA = { Double.random(in: 0...1) }
        return Color(red: randomRGB(), green: randomRGB(), blue: randomRGB(), alpha: randomA())
    }
}
