import XCTest
@testable import Rainbow

infix operator ~~
private func ~~(lhs: Double, rhs: Double) -> Bool {
    return Swift.max(lhs, rhs) - Swift.min(lhs, rhs) < 0.0001
}

private func ~~(lhs: Int, rhs: Int) -> Bool {
    return Swift.max(lhs, rhs) - Swift.min(lhs, rhs) <= 1
}

final class RainbowTests: XCTestCase {
    
    func testRGBAColor() {
        let color = Color(red: 0, green: 1, blue: 255, alpha: 0.3)
        let rgba = color.rgba
        XCTAssert(rgba.red ~~ 0)
        XCTAssert(rgba.green ~~ 1)
        XCTAssert(rgba.blue ~~ 255)
        XCTAssert(rgba.alpha ~~ 0.3)
        
        XCTAssertEqual(Color(rgba: "rgba(0, 1, 255, 0.3)"), color)
        XCTAssertEqual(Color.rgb(0, 1, 255, 0.3), color)
    }
    
    func testHSLAColor() {
        let color = Color(hue: 96, saturation: 48, lightness: 59, alpha: 0.3)
        let hsla = color.hsla
        XCTAssert(hsla.hue ~~ 96)
        XCTAssert(hsla.saturation ~~ 48)
        XCTAssert(hsla.lightness ~~ 59)
        XCTAssert(hsla.alpha ~~ 0.3)

        let rgba = color.rgba
        XCTAssert(rgba.red ~~ 140)
        XCTAssert(rgba.green ~~ 201)
        XCTAssert(rgba.blue ~~ 100)
        XCTAssert(rgba.alpha ~~ 0.3)

        XCTAssertEqual(Color(hsla: "hsl(96, 48%, 59%, 0.3)"), color)
        XCTAssertEqual(Color.hsl(96, 48, 59, 0.3), color)
    }

    func testHSVAColor() {
        let color = Color(hue: 96, saturation: 50, value: 78, alpha: 0.3)
        let hsva = color.hsva
        XCTAssert(hsva.hue ~~ 96)
        XCTAssert(hsva.saturation ~~ 50)
        XCTAssert(hsva.value ~~ 78)
        XCTAssert(hsva.alpha ~~ 0.3)

        let rgba = color.rgba
        XCTAssert(rgba.red ~~ 139)
        XCTAssert(rgba.green ~~ 199)
        XCTAssert(rgba.blue ~~ 99)
        XCTAssert(rgba.alpha ~~ 0.3)

        XCTAssertEqual(color, Color(hsva: "hsv(96, 50%, 78%, 0.3)"))
        XCTAssertEqual(color, Color.hsv(96, 50, 78, 0.3))
    }

    func testConversionEdgeCases() {
        let rgbInit = Color(red: 255, green: 255, blue: 255) // edge case: what hue does white/grey/black have? --> define as 0
        let hsla = rgbInit.hsla // this shouldn't fail
        XCTAssertEqual(hsla.hue, 0)
        XCTAssertEqual(hsla.saturation, 0)
        XCTAssertEqual(hsla.lightness, 100)
    }

    func testHexColor() {
        let color1 = Color(hex: "abcf")
        let color2 = Color(hex: "#AABBCC")
        XCTAssertEqual(color1, color2)

        let color3 = Color(red: 170, green: 187, blue: 204)
        let color4 = Color(hex: "abc")
        XCTAssertEqual(color3, color4!)

        let color5 = Color(hex: "hello")
        XCTAssertNil(color5)

        XCTAssertEqual(Color.hex(0x0366D6), Color.hex("#0366D6"))
    }

    func testANSI() {
        let color1 = Color(red: 170, green: 0, blue: 0)
        XCTAssertEqual(color1.ansi16, 31)

        let color2 = Color(red: 85, green: 85, blue: 255)
        XCTAssertEqual(color2.ansi16, 94)

        let color3 = Color(hex: "d700ff")
        XCTAssertEqual(color3?.ansi256, 165)
        
        let color4 = Color(hex: "999")
        XCTAssertEqual(color4?.ansi256, 246)
    }
    
    func testDarkLight() {
        let color1 = Color.hex("eee")
        XCTAssertTrue(color1!.isLight)
        XCTAssertFalse(color1!.isDark)
        
        let color2 = Color.hex("fff")
        XCTAssertTrue(color2!.isWhite)
        XCTAssertFalse(color2!.isBlack)
    }
    
    func testNegate() {
        let color = Color.random
        XCTAssertEqual(color.negate.negate, color)
    }

    func testCocoa() {
        let c = Color.random
        #if canImport(AppKit)
        XCTAssertEqual(Color.fromNSColor(c.toNSColor()), c)
        #endif
        
        #if canImport(UIKit)
        XCTAssertEqual(Color.fromUIColor(c.toUIColor()), c)
        #endif
    }
}
