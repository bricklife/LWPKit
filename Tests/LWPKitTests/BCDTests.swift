import XCTest

@testable import LWPKit

final class BCDTests: XCTestCase {

    func testBinaryCodedDecimal() {
        XCTAssertEqual(Int8(0x12).binaryCodedDecimal, 12)
        XCTAssertEqual(UInt8(0x98).binaryCodedDecimal, 98)
        XCTAssertEqual(Int16(0x3456).binaryCodedDecimal, 3456)
        XCTAssertEqual(UInt16(0x6789).binaryCodedDecimal, 6789)
        XCTAssertEqual(Int32(0x1234_5678).binaryCodedDecimal, 12_345_678)
        XCTAssertEqual(UInt32(0x9876_5432).binaryCodedDecimal, 98_765_432)

        XCTAssertNil(UInt8(0xa1).binaryCodedDecimal)
        XCTAssertNil(Int8(0x7f).binaryCodedDecimal)
    }
}
