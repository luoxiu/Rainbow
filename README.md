# Rainbow

Color conversion and manipulation library for Swift, with no dependence on UIKit/AppKit

## API

### create

```swift
let c0 = Color(red: 50, green: 100, blue: 150, alpha: 1)
let c1 = Color(hue: 150, saturation: 0.5, lightness: 0.5, alpha: 1)
let c2 = Color(hue: 300, saturation: 0.7, value: 0.7, alpha: 1)

let c4 = Color(hex: "#aaa")         // "#" is optional
let c5 = Color(hex: "#ABCF")        
let c6 = Color(hex: "#010203")      
let c7 = Color(hex: "#01020304")    

let c8 = Color(hex: 0x0366D6)

let c9 = Color(rgb: "rgb(0, 1, 2)")         // the same as `Color(rgba:)"
let c10 = Color(rgba: "rgba(0, 1, 2, 0.3)")

let c11 = Color(hsv: "hsv(100, 10%, 20%)")  // the same as `Color(hsva:)"
let c12 = Color(hsva: "hsva(100, 10%, 20%, 0.3)")

let c13 = Color(hsl: "hsl(100, 10%, 20%)")  // the same as `Color(hsla:)"
let c14 = Color(hsla: "hsla(100, 10%, 20%, 0.3)")
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
c1.adding(hue: 1, saturation: 0.2, lightness: 0.3, alpha: 0.4)
c1.adding(hue: 1, saturation: 0.2, value: 0.3, alpha: 0.4)
```

## Install

```swift
dependencies: [
    .package(url: "https://github.com/jianstm/Rainbow", .upToNextMajor(from: "0.0.1"))
]
```

## Contribute

Any contributing is welcome at all times!