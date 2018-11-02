import XCTest
@testable import Rainbow

private func ~~(lhs: Double, rhs: Double) -> Bool {
    return Swift.max(lhs, rhs) - Swift.min(lhs, rhs) < 0.0001
}

private func ~~(lhs: Int, rhs: Double) -> Bool {
    return Swift.max(Double(lhs), rhs) - Swift.min(Double(lhs), rhs) < 0.0001
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
    }
    
    func testHSLAColor() {
        let color = Color(hue: 96, saturation: 0.48, lightness: 0.59, alpha: 0.3)
        let hsla = color.hsla
        XCTAssert(hsla.hue ~~ 96)
        XCTAssert(hsla.saturation ~~ 0.48)
        XCTAssert(hsla.lightness ~~ 0.59)
        XCTAssert(hsla.alpha ~~ 0.3)

        let rgba = color.rgba
        XCTAssert(rgba.red ~~ 140)
        XCTAssert(rgba.green ~~ 201)
        XCTAssert(rgba.blue ~~ 100)
        XCTAssert(rgba.alpha ~~ 0.3)
    }

    func testHSVAColor() {
        let color = Color(hue: 96, saturation: 0.50, value: 0.78, alpha: 0.3)
        let hsva = color.hsva
        XCTAssert(hsva.hue ~~ 96)
        XCTAssert(hsva.saturation ~~ 0.50)
        XCTAssert(hsva.value ~~ 0.78)
        XCTAssert(hsva.alpha ~~ 0.3)

        let rgba = color.rgba
        XCTAssert(rgba.red ~~ 139)
        XCTAssert(rgba.green ~~ 199)
        XCTAssert(rgba.blue ~~ 99)
        XCTAssert(rgba.alpha ~~ 0.3)
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
