import XCTest
@testable import LWPKit

final class MessageTypeTests: XCTestCase {
    
    func testInitRawValue() {
        XCTAssertNil(MessageType(rawValue: 0x00))
        XCTAssertEqual(MessageType(rawValue: 0x01), MessageType.hubProperties)
    }
}
