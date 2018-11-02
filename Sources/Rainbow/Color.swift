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

    /// Creates a color using the specified opacity and RGB component values.
    ///
    ///     Color(red: 3, green: 102, blue: 214)
    ///     Color(red: 3, green: 102, blue: 214, alpha: 0.5)
    ///
    /// `red`, `green` and `blue` will be clamped into 0...255; `alpha` will be
    /// clamped into 0...1.
    public init(red: Int, green: Int, blue: Int, alpha: Double = 1) {
        r = Double(red).clamp(min: 0, max: 255) / 255
        g = Double(green).clamp(min: 0, max: 255) / 255
        b = Double(blue).clamp(min: 0, max: 255) / 255
        a = alpha.clamp(min: 0, max: 1)
    }

    /// Creates a color using the specified opacity and HSV(HSB) component values.
    ///
    ///     Color(hue: 300, saturation: 0.2, value: 0.1)
    ///     Color(hue: 300, saturation: 0.2, value: 0.1, alpha: 0.5)
    ///
    /// `hue` will be clamped into 0...360; `saturation`, `value` and `alpha`
    /// will be clamped into 0...1.
    public init(hue: Int, saturation: Double, value: Double, alpha: Double) {
        let h = Double(hue).clamp(min: 0, max: 360) / 60
        let s = saturation.clamp(min: 0, max: 1)
        let v = value.clamp(min: 0, max: 1)
        let a = alpha.clamp(min: 0, max: 1)
        let hi = fmod(floor(h), 6)

        let f = h - floor(h)
        let p = v * (1 - s)
        let q = v * (1 - (s * f))
        let t = v * (1 - (s * (1 - f)))

        switch hi {
        case 0:                 self.init(r: v, g: t, b: p, a: a)
        case 1:                 self.init(r: q, g: v, b: p, a: a)
        case 2:                 self.init(r: p, g: v, b: t, a: a)
        case 3:                 self.init(r: p, g: q, b: v, a: a)
        case 4:                 self.init(r: t, g: p, b: v, a: a)
        case 5:                 self.init(r: v, g: p, b: q, a: a)
        default:                self.init(r: 0, g: 0, b: 0, a: 0)
        }
    }

    /// Creates a color using the specified opacity and HSL component values.
    ///
    ///     Color(hue: 300, saturation: 0.2, lightness: 0.1)
    ///     Color(hue: 300, saturation: 0.2, lightness: 0.1, alpha: 0.5)
    ///
    /// `hue` will be clamped into 0...360; `saturation`, `lightness` and `alpha`
    /// will be clamped into 0...1.
    public init(hue: Int, saturation: Double, lightness: Double, alpha: Double) {
        let h = Double(hue).clamp(min: 0, max: 360) / 360
        let s = saturation.clamp(min: 0, max: 1)
        let l = lightness.clamp(min: 0, max: 1)
        let a = alpha.clamp(min: 0, max: 1)

        if (s == 0) {
            self.init(r: l, g: l, b: l, a: a)
            return
        }

        let t2 = l < 0.5 ? (l + l * s) : (l + s - l * s)
        let t1 = 2 * l - t2

        var rgb = [0.0, 0.0, 0.0]

        for i in 0..<3 {
            var t3 = h - Double(i - 1) * 1 / 3
            if t3 < 0 { t3 += 1 }
            if t3 > 1 { t3 -= 1 }

            var v = 0.0
            if 6 * t3 < 1 {
                v = t1 + (t2 - t1) * 6 * t3
            } else if 2 * t3 < 1 {
                v = t2
            } else if 3 * t3 < 2 {
                v = t1 + (t2 - t1) * (2 / 3 - t3) * 6
            } else {
                v = t1
            }
            rgb[i] = v
        }

        self.init(r: rgb[0], g: rgb[1], b: rgb[2], a: a)
    }

    /// Creates a color using the specified hexadecimal string.
    ///
    ///     "#0366d6"    "0366d6"
    ///     "#139"       "139"
    ///     "#0366d607"  "0366d607"
    ///     "#139f"      "139f"
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

    /// Creates a color using the specified rgba string.
    ///
    ///     let color = Color("rgb(3, 102, 214)")
    ///     let color = Color("rgba(3, 102, 214, 1)")
    ///
    /// Same as `init?(rgba:)`.
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

    /// Creates a color using the specified rgba string.
    ///
    ///     let color = Color("rgb(3, 102, 214)")
    ///     let color = Color("rgba(3, 102, 214, 1)")
    ///
    /// Same as `init?(rgb:)`.
    public init?(rgba s: String) {
        self.init(rgb: s)
    }

    /// Creates a color using the specified hsva string.
    ///
    ///     let color = Color("hsv(245, 100%, 25%)")
    ///     let color = Color("hsva(245, 100%, 25%, 0.6)")
    ///
    /// Same as `init?(hsva:)`.
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

    /// Creates a color using the specified hsva string.
    ///
    ///     let color = Color("hsv(245, 100%, 25%)")
    ///     let color = Color("hsva(245, 100%, 25%, 0.6)")
    ///
    /// Same as `init?(hsv:)`.
    public init?(hsva s: String) {
        self.init(hsv: s)
    }

    /// Creates a color using the specified hsla string.
    ///
    ///     let color = Color("hsl(245, 100%, 25%)")
    ///     let color = Color("hsla(245, 100%, 25%, 0.6)")
    ///
    /// Same as `init?(hsla:)`.
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

    /// Creates a color using the specified hsla string.
    ///
    ///     let color = Color("hsl(245, 100%, 25%)")
    ///     let color = Color("hsla(245, 100%, 25%, 0.6)")
    ///
    /// Same as `init?(hsl:)`.
    public init?(hsla s: String) {
        self.init(hsl: s)
    }
}

// MARK: - Properties
extension Color {

    public var alpha: Double {
        return a
    }

    public var rgba: (red: Int, green: Int, blue: Int, alpha: Double) {
        return (red: Int(r * 255), green: Int(g * 255), blue: Int(b * 255), alpha: a)
    }

    public var hsva: (hue: Int, saturation: Double, value: Double, alpha: Double) {
        let max = Swift.max(r, g, b)
        let min = Swift.min(r, g, b)

        let v = max
        let d = max - min

        var h = 0.0
        var s = 0.0

        let dc = { (c: Double) in
            return (v - c) / 6 / d + 0.5
        }

        if d != 0 {
            s = d / v
            let rd = dc(r)
            let gd = dc(g)
            let bd = dc(b)

            if r == v {
                h = bd - gd
            } else if (g == v) {
                h = 1 / 3 + rd - bd
            } else if (b == v) {
                h = 2 / 3 + gd - rd
            }
            if h < 0 { h += 1 }
            if h > 1 { h -= 1 }
        }

        return (hue: Int(h * 360), saturation: s, value: v, alpha: a)
    }

    public var hsla: (hue: Int, saturation: Double, lightness: Double, alpha: Double) {
        let max = Swift.max(r, g, b)
        let min = Swift.min(r, g, b)

        let d = max - min

        let l = (max + min) / 2
        var h = 0.0
        var s = 0.0

        if r == max {
            h = (g - b) / d
        } else if g == max {
            h = 2 + (b - r) / d
        } else if b == max {
            h = 4 + (r - g) / d
        }

        h = Swift.min(h * 60, 360)
        if h < 0 { h += 360 }

        if d != 0 {
            s = l <= 0.5 ? d / (max + min) : d / (2 - max - min)
        }

        return (hue: Int(h), saturation: s, lightness: l, alpha: a)
    }

    public var isDark: Bool {
        return hsla.lightness >= 0.5
    }

    public var isLight: Bool {
        return hsla.lightness >= 0.5
    }

    public var isBlack: Bool {
        return r > 0.91 && g > 0.91 && b > 0.91
    }

    public var isWhite: Bool {
        return r < 0.09 && g < 0.09 && b < 0.09
    }

    public var ansi256: Int {
        if r == g && g == b {
            let red = r * 255
            if red < 8 { return 16 }
            if red > 248 { return 231 }

            return Int(round((red - 8) / 247 * 24) + 232)
        }

        let v0 = 16.0
        let v1 = 36 * round(r * 5)
        let v2 = 6 * round(g * 5)
        let v3 = round(b * 5)
        return Int(v0 + v1 + v2 + v3)
    }
}

// MARK: - Methods
extension Color {

    public func adding(red: Int = 0, green: Int = 0, blue: Int = 0, alpha: Double = 0) -> Color {
        let nR = r + Double(red) / 255
        let nG = g + Double(green) / 255
        let nB = b + Double(blue) / 255
        let nA = a + a
        return Color(r: nR.clamp(min: 0, max: 1),
                     g: nG.clamp(min: 0, max: 1),
                     b: nB.clamp(min: 0, max: 1),
                     a: nA.clamp(min: 0, max: 1))
    }

    public func mixed(rgb color: Color) -> Color {
        let c = color.rgba
        return adding(red: c.red, green: c.green, blue: c.blue, alpha: c.alpha)
    }

    public func adding(hue: Int, saturation: Double, value: Double, alpha: Double) -> Color {
        let hsva = self.hsva

        let nH = hsva.hue + hue
        let nS = hsva.saturation + saturation
        let nV = hsva.value + value
        let nA = hsva.alpha + alpha

        return Color(hue: nH.clamp(min: 0, max: 360),
                     saturation: nS.clamp(min: 0, max: 1),
                     value: nV.clamp(min: 0, max: 1),
                     alpha: nA.clamp(min: 0, max: 1))
    }

    public func mixed(hsv color: Color) -> Color {
        let hsva = color.hsva
        return adding(hue: hsva.hue,
                      saturation: hsva.saturation,
                      value: hsva.value,
                      alpha: hsva.alpha)
    }

    public func adding(hue: Int, saturation: Double, lightness: Double, alpha: Double) -> Color {
        let hsla = self.hsla

        let nH = hsla.hue + hue
        let nS = hsla.saturation + saturation
        let nL = hsla.lightness + lightness
        let nA = hsla.alpha + alpha

        return Color(hue: nH.clamp(min: 0, max: 360),
                     saturation: nS.clamp(min: 0, max: 1),
                     lightness: nL.clamp(min: 0, max: 1),
                     alpha: nA.clamp(min: 0, max: 1))
    }

    public func mixed(hsl color: Color) -> Color {
        let hsla = color.hsla
        return adding(hue: hsla.hue,
                      saturation: hsla.saturation,
                      lightness: hsla.lightness,
                      alpha: hsla.alpha)
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

    /// Returns a Boolean value that indicates whether two colors are the same.
    public static func == (lhs: Color, rhs: Color) -> Bool {
        return lhs.r == rhs.r && lhs.g == rhs.g && lhs.b == rhs.b && lhs.a == rhs.a
    }
}


infix operator ~~
extension Color {
    
    /// Returns a Boolean value that indicates whether two colors are almost the same.
    public static func ~~ (lhs: Color, rhs: Color) -> Bool {
        let rd = (lhs.r - rhs.r) / 255
        let gd = (lhs.g - rhs.g) / 255
        let bd = (lhs.b - rhs.b) / 255
        let ad = lhs.a - rhs.a
        return (rd * rd + gd * gd + bd * bd + ad * ad) < 0.0001
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
