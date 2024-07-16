import Foundation

public protocol ByteCollectionDecodable {
    init(_ bytes: some ByteCollection) throws
}

public protocol ByteCollectionEncodable {
    func bytes() throws -> [UInt8]
}

extension ByteCollectionEncodable {
    public func data() throws -> Data {
        return try Data(bytes())
    }
}

public typealias ByteCollectionCodable = ByteCollectionDecodable & ByteCollectionEncodable
