import Foundation

public struct Color {

    let r: Double
    let g: Double
    let b: Double
    let a: Double

    init(r: Double, g: Double, b: Double, a: Double) {
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
    ///     Color(hue: 300, saturation: 20, value: 10)
    ///     Color(hue: 300, saturation: 20, value: 10, alpha: 0.5)
    ///
    /// `hue` will be clamped into 0...360; `saturation` and `value` will be
    /// clamped into 1...100, `alpha` will be clamped into 0...1.
    public init(hue: Int, saturation: Int, value: Int, alpha: Double) {
        let h = Double(hue).clamp(min: 0, max: 360) / 60
        let s = Double(saturation).clamp(min: 0, max: 100) / 100
        let v = Double(value).clamp(min: 0, max: 100) / 100
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
    ///     Color(hue: 300, saturation: 20, lightness: 10)
    ///     Color(hue: 300, saturation: 20, lightness: 10, alpha: 0.5)
    ///
    /// `hue` will be clamped into 0...360; `saturation`and `lightness` will be
    /// clamped into 1...100, `alpha` will be clamped into 0...1.
    public init(hue: Int, saturation: Int, lightness: Int, alpha: Double) {
        let h = Double(hue).clamp(min: 0, max: 360) / 360
        let s = Double(saturation).clamp(min: 0, max: 100) / 100
        let l = Double(lightness).clamp(min: 0, max: 100) / 100
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
                v = t1 + (t2 - t1) * (2.0 / 3 - t3) * 6
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

    /// Creates a color using the specified hexadecimal value.
    ///
    ///     let color = Color(hex: 0x0366D6)
    public init(hex: Int) {
        let r = (hex >> 16) & 0xff
        let g = (hex >> 8) & 0xff
        let b = hex & 0xff
        self.init(red: r, green: g, blue: b)
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

        var alpha = 1.0
        if captures.count > 4, let a = Double(captures[4]) {
            alpha = a
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
            let s = Int(captures[2]),
            let v = Int(captures[3]) else {
                return nil
        }

        var alpha = 1.0
        if captures.count > 4, let a = Double(captures[4]) {
            alpha = a
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
            let s = Int(captures[2]),
            let l = Int(captures[3]) else {
                return nil
        }

        var alpha = 1.0
        if captures.count > 4, let a = Double(captures[4]) {
            alpha = a
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

extension Color {
    public static func rgb(_ red: Int, _ green: Int, _ blue: Int, _ alpha: Double = 1) -> Color {
        return Color(red: red, green: green, blue: blue, alpha: alpha)
    }

    public static func hsl(_ hue: Int, _ saturation: Int, _ lightness: Int, _ alpha: Double = 1) -> Color {
        return Color(hue: hue, saturation: saturation, lightness: lightness, alpha: alpha)
    }

    public static func hsv(_ hue: Int, _ saturation: Int, _ value: Int, _ alpha: Double = 1) -> Color {
        return Color(hue: hue, saturation: saturation, value: value, alpha: alpha)
    }

    public static func hex(_ s: String) -> Color? {
        return Color(hex: s)
    }

    public static func hex(_ n: Int) -> Color {
        return Color(hex: n)
    }
}

// MARK: - Properties
extension Color {

    public var rgba: (red: Int, green: Int, blue: Int, alpha: Double) {
        return (red: Int(r * 255), green: Int(g * 255), blue: Int(b * 255), alpha: a)
    }

    public var hsva: (hue: Int, saturation: Int, value: Int, alpha: Double) {
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
                h = 1.0 / 3 + rd - bd
            } else if (b == v) {
                h = 2.0 / 3 + gd - rd
            }
            if h < 0 { h += 1 }
            if h > 1 { h -= 1 }
        }

        return (hue: Int(h * 360), saturation: Int(s * 100), value: Int(v * 100), alpha: a)
    }

    public var hsla: (hue: Int, saturation: Int, lightness: Int, alpha: Double) {
        let max = Swift.max(r, g, b)
        let min = Swift.min(r, g, b)
        
        // calc lightness
        let l = (max + min) / 2.0
        
        // calc saturation
        var s = 0.0

        if (max == min) {
            s = 0.0
        } else if (l < 0.5) {
            s = (max - min) / (max + min)
        } else if (l >= 0.5) {
            s = (max - min) / (2.0 - max - min)
        }
        
        // calc hue
        var h = 0.0
        // if saturation is 0, hue is undefined, set to 0
        if s == 0.0 {
            h = 0.0
        } else if r == max {
            h = (g - b) / (max - min)
        } else if g == max {
            h = 2 + (b - r) / (max - min)
        } else if b == max {
            h = 4 + (r - g) / (max - min)
        }

        h = Swift.min(h * 60, 360)
        if h < 0 { h += 360 }

        return (hue: Int(h), saturation: Int(s * 100), lightness: Int(l * 100), alpha: a)
    }

    public var isDark: Bool {
        let rgba = self.rgba
        let yiq = Double(rgba.red * 299 + rgba.green * 587 + rgba.blue * 114) / 1000
        return yiq < 218
    }

    public var isLight: Bool {
        return !isDark
    }

    public var negate: Color {
        let rgba = self.rgba
        return Color(red: 255 - rgba.red, green: 255 - rgba.green, blue: 255 - rgba.blue, alpha: rgba.alpha)
    }

    public var isBlack: Bool {
        return r < 0.09 && g < 0.09 && b < 0.09
    }

    public var isWhite: Bool {
        return r > 0.91 && g > 0.91 && b > 0.91
    }

    /// Roughly
    public var ansi256: UInt8 {
        if r == g && g == b {
            let red = r * 255
            if red < 8 { return 16 }
            if red > 248 { return 231 }

            return UInt8(round((red - 8) / 247 * 24) + 232)
        }

        let v0 = 16.0
        let v1 = 36 * round(r * 5)
        let v2 = 6 * round(g * 5)
        let v3 = round(b * 5)

        return UInt8(v0 + v1 + v2 + v3)
    }

    /// Roughly
    public var ansi16: UInt8 {
        let v = round(Double(self.hsva.value) / 50)

        if v == 0 {
            return 30
        }

        let i0: UInt8 = 30
        let i1 = UInt8(round(b)) << 2
        let i2 = UInt8(round(g)) << 1
        let i3 = UInt8(round(r))

        var c = i0 + i1 | i2 | i3

        if v == 2 {
            c += 60
        }

        return c
    }
}

// MARK: - Hashable & Equatable
extension Color: Hashable { }

// MARK: - Misc
extension Color {

    public static var random: Color {
        let randomRGB = { Int.random(in: 0...255) }
        let randomA = { Double.random(in: 0...1) }
        return Color(red: randomRGB(), green: randomRGB(), blue: randomRGB(), alpha: randomA())
    }
}
