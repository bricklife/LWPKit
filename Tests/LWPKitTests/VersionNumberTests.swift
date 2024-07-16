import XCTest

@testable import LWPKit

final class VersionNumberTests: XCTestCase {

    func testDecode() {
        XCTAssertEqual(try? VersionNumber([0x10, 0x15, 0x37, 0x17]).description, "1.7.37.1510")
        XCTAssertEqual(try? VersionNumber([0x71, 0x00, 0x00, 0x10]).description, "1.0.00.0071")
        XCTAssertNil(try? VersionNumber([0x0a, 0x00, 0x00, 0x00]).description)
    }
}
