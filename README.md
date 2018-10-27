# Rainbow

Color conversion and manipulation library for Swift, with no dependence on UIKit/AppKit

## API

### create

```swift
let c0 = Color(red: 50, green: 100, blue: 150, alpha: 1)
let c1 = Color(hue: 150, saturation: 0.5, lightness: 0.5, alpha: 1)
let c2 = Color(hue: 300, saturation: 0.7, value: 0.7, alpha: 1)

let c4 = Color(hex: "#aaa")         // "#" is optional
let c5 = Color(hex: "#aaa1")        // "#" is optional
let c6 = Color(hex: "#010203")      // "#" is optional
let c7 = Color(hex: "#01020304")    // "#" is optional

let c8 = Color(rgb: "rgb(0, 1, 2)")         // the same as `Color(rgba:)"
let c9 = Color(rgba: "rgba(0, 1, 2, 0.3)")

let c10 = Color(hsv: "hsv(100, 0.1, 0.2)")  // the same as `Color(hsva:)"
let c11 = Color(hsva: "hsva(100, 0.1, 0.2, 0.3)")

let c12 = Color(hsl: "hsl(100, 0.1, 0.2)")  // the same as `Color(hsla:)"
let c13 = Color(hsla: "hsla(100, 0.1, 0.2, 0.3)")
```

### properties

```swift
let color = Color(hex: "#010203")
color.rgba      // (red: Int, green: Int, blue: Int, alpha: Double)
color.hsva      // (hue: Int, saturation: Double, value: Double, alpha: Double)
color.hsla      // (hue: Int, saturation: Double, lightness: Double, alpha: Double)
color.isDark    // true or false
color.isLight   // true or false
color.isWhite   // true or false
color.isBlack   // true or false

color.random    // a random color
```

###  methods

```swift
let c1 = Color(red: 50, green: 100, blue: 150, alpha: 1)
let c2 = Color(hue: 150, saturation: 0.5, lightness: 0.5, alpha: 1)
c1.mixed(rgb: c2)     // -> mixed color
c1.mixed(hsv: c2)     // -> mixed color
c1.mixed(hsl: c2)     // -> mixed color

c1.adding(red: 10)
c1.adding(hue: 1, saturation: 0.2, lightness: 0.3)
c1.adding(hue: 1, saturation: 0.2, value: 0.3, alpha: 0.4)
```