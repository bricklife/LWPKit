extension FixedWidthInteger {
    public var binaryCodedDecimal: Self? {
        let numOfDigit = bitWidth / 4
        var value: Self = 0
        for i in stride(from: numOfDigit - 1, through: 0, by: -1) {
            let v = (self >> (4 * i)) & 0x0f
            guard 0...9 ~= v else { return nil }
            value = value * 10 + v
        }
        return value
    }
}
