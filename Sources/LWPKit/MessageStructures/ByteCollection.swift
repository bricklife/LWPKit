import Foundation

public typealias ByteCollection = RandomAccessCollection<UInt8>

public protocol ByteCollectionDecodable {
    
    init(_ bytes: some ByteCollection) throws
}

public protocol ByteCollectionEncodable {
    
    func bytes() throws -> [UInt8]
    func data() throws -> Data
}

extension ByteCollectionEncodable {
    
    public func data() throws -> Data {
        return try Data(bytes())
    }
}

public typealias ByteCollectionCodable = ByteCollectionDecodable & ByteCollectionEncodable
