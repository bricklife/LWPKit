import XCTest

@testable import LWPKit

final class LWPVersionNumberTests: XCTestCase {

    func testDecode() {
        XCTAssertEqual(try? LWPVersionNumber([0x12, 0x34]).description, "34.12")
        XCTAssertNil(try? LWPVersionNumber([0x0a, 0x00]).description)
    }
}
