import XCTest
@testable import LWPKit

final class MessageTests: XCTestCase {
    
    func testInitData() {
        XCTAssertNotNil(Message(data: Data([4, 0, 1, 0])))
        XCTAssertNil(Message(data: Data([5, 0, 2, 0])))
        
        var data = Data(repeating: 0, count: 129)
        data[0] = 0x81
        data[1] = 0x01
        data[3] = 3
        XCTAssertNotNil(Message(data: data))
        
        data[0] = 0x82
        data[3] = 4
        XCTAssertNil(Message(data: data))
    }
}
