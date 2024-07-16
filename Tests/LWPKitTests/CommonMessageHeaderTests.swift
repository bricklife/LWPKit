import XCTest

@testable import LWPKit

final class CommonMessageHeaderTests: XCTestCase {

    func testInitData() {
        XCTAssertEqual(try? CommonMessageHeader([4, 0, 1, 0, 0]).messageType, .hubProperties)
        XCTAssertNil(try? CommonMessageHeader([15, 0, 0, 0, 0]).messageType)

        XCTAssertEqual(try? CommonMessageHeader(Data([0x81, 0x01, 0, 2])).messageType, .hubActions)
        XCTAssertNil(try? CommonMessageHeader(Data([0x81, 0x01, 0, 0])).messageType)
    }
}
