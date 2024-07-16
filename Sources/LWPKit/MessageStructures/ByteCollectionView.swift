public struct ByteCollectionView<C: ByteCollection>: Sendable {
    public let bytes: C

    public init(_ bytes: C) {
        self.bytes = bytes
    }

    public var count: Int {
        bytes.count
    }

    public func uint8(_ offset: Int) throws -> UInt8 {
        let index = bytes.index(bytes.startIndex, offsetBy: offset)
        guard index < bytes.endIndex else {
            throw Error.outOfRange(index: index, endIndex: bytes.endIndex)
        }
        return bytes[index]
    }

    public func int8(_ offset: Int) throws -> Int8 {
        return try Int8(bitPattern: uint8(offset))
    }

    public func uint16(_ offset: Int) throws -> UInt16 {
        return try UInt16(uint8(offset)) + (UInt16(uint8(offset + 1)) << 8)
    }

    public func int16(_ offset: Int) throws -> Int16 {
        return try Int16(bitPattern: uint16(offset))
    }

    public func uint32(_ offset: Int) throws -> UInt32 {
        return try UInt32(uint16(offset)) + (UInt32(uint16(offset + 2)) << 16)
    }

    public func int32(_ offset: Int) throws -> Int32 {
        return try Int32(bitPattern: uint32(offset))
    }

    public func float(_ offset: Int) throws -> Float {
        return try Float(bitPattern: uint32(offset))
    }

    public func bool(_ offset: Int) throws -> Bool {
        return try uint8(offset) != 0x00
    }

    public func rawRepresentable<V: RawRepresentable>(_ offset: Int) throws -> V where V.RawValue == UInt8 {
        let rawValue = try uint8(offset)
        guard let value = V(rawValue: rawValue) else {
            throw Error.undefined(type: V.self, rawValue: .uint8(rawValue))
        }
        return value
    }

    public func rawRepresentable<V: RawRepresentable>(_ offset: Int) throws -> V where V.RawValue == Int8 {
        let rawValue = try int8(offset)
        guard let value = V(rawValue: rawValue) else {
            throw Error.undefined(type: V.self, rawValue: .int8(rawValue))
        }
        return value
    }

    public func rawRepresentable<V: RawRepresentable>(_ offset: Int) throws -> V where V.RawValue == UInt16 {
        let rawValue = try uint16(offset)
        guard let value = V(rawValue: rawValue) else {
            throw Error.undefined(type: V.self, rawValue: .uint16(rawValue))
        }
        return value
    }

    public func rawRepresentable<V: RawRepresentable>(_ offset: Int) throws -> V where V.RawValue == Int16 {
        let rawValue = try int16(offset)
        guard let value = V(rawValue: rawValue) else {
            throw Error.undefined(type: V.self, rawValue: .int16(rawValue))
        }
        return value
    }
}

extension ByteCollectionView {
    public func suffix(_ offset: Int) throws -> C.SubSequence {
        let index = bytes.index(bytes.startIndex, offsetBy: offset)
        guard index <= bytes.endIndex else {
            throw Error.outOfRange(index: index, endIndex: bytes.endIndex)
        }
        return bytes[index..<bytes.endIndex]
    }

    public func string(_ offset: Int) throws -> String {
        guard let string = String(bytes: try suffix(offset), encoding: .utf8) else {
            throw Error.invalidBytes
        }
        return string
    }

    public func bytes(_ offset: Int) throws -> [UInt8] {
        return try [UInt8](suffix(offset))
    }
}

extension ByteCollectionView {
    public enum Error: Swift.Error, Sendable {
        case outOfRange(index: C.Index, endIndex: C.Index)
        case undefined(type: any RawRepresentable.Type, rawValue: RawValue)
        case invalidBytes
    }

    public enum RawValue: Sendable {
        case uint8(UInt8)
        case int8(Int8)
        case uint16(UInt16)
        case int16(Int16)
    }
}

extension ByteCollection {
    public var view: ByteCollectionView<Self> {
        return ByteCollectionView(self)
    }
}
