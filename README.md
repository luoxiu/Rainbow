# Rainbow

<a href="https://travis-ci.org/jianstm/Rainbow">
  <img src="https://travis-ci.org/jianstm/Rainbow.svg?branch=master">
</a>
<br>
<div align="center">
    <strong>Color conversion and manipulation library for Swift, with no dependence on UIKit/AppKit.</strong>
</div>

## API

### Creation

```swift
let color = Color(red: 50, green: 100, blue: 150, alpha: 1)
let color = Color(hue: 150, saturation: 50, lightness: 50, alpha: 1)
let color = Color(hue: 300, saturation: 70, value: 70, alpha: 1)

let color = Color(hex: "#aaa")         // "#" is optional
let color = Color(hex: "#ABCF")        
let color = Color(hex: "#010203")      
let color = Color(hex: "#01020304")    

let color = Color(hex: 0x0366D6)

let color = Color(rgb: "rgb(0, 100, 200)")         // the same as `Color(rgba:)"
let color = Color(rgba: "rgba(0, 100, 200, 0.3)")

let color = Color(hsv: "hsv(100, 20%, 30%)")  // the same as `Color(hsva:)"
let color = Color(hsva: "hsva(100, 20%, 30%, 0.3)")

let color = Color(hsl: "hsl(100, 20%, 30%)")  // the same as `Color(hsla:)"
let color = Color(hsla: "hsla(100, 20%, 30%, 0.3)")

let color = Color.rgb(100, 200, 300)
let color = Color.hsl(100, 20, 30)
let color = Color.hsv(100, 20, 30)
let color = Color.hex("#0a0b0c")
let color = Color.hex(0x0366D6)

let color = Color.aliceBlue		// more than 100 handpicked colors
let color = Color.beige
let color = Color.cadetBlue
// ...
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
color.negate

color.random    // a random color
```

###  methods

```swift
let c1 = Color(red: 50, green: 100, blue: 150, alpha: 1)
let c2 = Color(red: 150, green: 200, blue: 250, alpha: 1)
c1.mixed(c2)     // -> mixed color
```

## Install

```swift
dependencies: [
    .package(url: "https://github.com/jianstm/Rainbow", .upToNextMajor(from: "0.0.1"))
]
```

## Contribute

If you want to add new features, feel free to submit a pull request. Any contributing is welcome at all times!

## Acknowledge

Inspired by the awesome javascript library [color](https://github.com/Qix-/color).
