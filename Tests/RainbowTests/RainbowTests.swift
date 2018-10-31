import XCTest
@testable import Rainbow

private func ~~(lhs: Double, rhs: Double) -> Bool {
    return (Swift.max(lhs, rhs) - Swift.min(lhs, rhs)) < 0.0001
}

private func ~~(lhs: Int, rhs: Double) -> Bool {
    return (Swift.max(Double(lhs), rhs) - Swift.min(Double(lhs), rhs)) < 0.0001
}

final class RainbowTests: XCTestCase {
    
    func testRGBAColor() {
        let color0 = Color(red: 0, green: 1, blue: 255, alpha: 0.3)
        let rgba0 = color0.rgba
        XCTAssert(rgba0.red ~~ 0)
        XCTAssert(rgba0.green ~~ 1)
        XCTAssert(rgba0.blue ~~ 255)
        XCTAssert(rgba0.alpha ~~ 0.3)
        
        let color1 = Color(red: -1, green: -2, blue: 300, alpha: 2)
        let rgba1 = color1.rgba
        XCTAssert(rgba1.red ~~ 0)
        XCTAssert(rgba1.green ~~ 0)
        XCTAssert(rgba1.blue ~~ 255)
        XCTAssert(rgba1.alpha ~~ 1)
    }
    
    func testHSLAColor() {
        let color0 = Color(hue: 300, saturation: 0.2, lightness: 0.4, alpha: 0.3)
        let hsla0 = color0.hsla
        XCTAssert(hsla0.hue ~~ 300)
        XCTAssert(hsla0.saturation ~~ 0.2)
        XCTAssert(hsla0.lightness ~~ 0.4)
        XCTAssert(hsla0.alpha ~~ 0.3)

        let color1 = Color(hue: 361, saturation: -2, lightness: 2, alpha: -2)
        let hsla1 = color1.hsla
        XCTAssert(hsla1.hue ~~ 0)                   // == 0
        XCTAssert(hsla1.saturation ~~ 0)
        XCTAssert(hsla1.lightness ~~ 1)
        XCTAssert(hsla1.alpha ~~ 0)
    }

    func testHSVAColor() {
        let color0 = Color(hue: 300, saturation: 0.2, value: 0.4, alpha: 0.3)
        let hsva0 = color0.hsva
        XCTAssert(hsva0.hue ~~ 300)
        XCTAssert(hsva0.saturation ~~ 0.2)
        XCTAssert(hsva0.value ~~ 0.4)
        XCTAssert(hsva0.alpha ~~ 0.3)

        let color1 = Color(hue: 361, saturation: -2, value: 2, alpha: -2)
        let hsva1 = color1.hsva
        print(color1.rgba)
        print(hsva1)
        XCTAssert(hsva1.hue ~~ 0)
        XCTAssert(hsva1.saturation ~~ 0)
        XCTAssert(hsva1.value ~~ 1)
        XCTAssert(hsva1.alpha ~~ 0)
    }

    func testHexColor() {
        let color1 = Color(hex: "abcf")
        let color2 = Color(hex: "#AABBCC")
        XCTAssert(color1 == color2)

        let color3 = Color(red: 170, green: 187, blue: 204)
        let color4 = Color(hex: "abc")
        XCTAssertNotNil(color4)
        XCTAssert(color3 ~~ color4!)

        let color5 = Color(hex: "hello")
        XCTAssertNil(color5)
    }

    static var allTests = [
        ("testRGBAColor", testRGBAColor),
        ("testHSLAColor", testHSLAColor),
        ("testHSVAColor", testHSVAColor)
    ]
}
