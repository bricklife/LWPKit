import Foundation

public protocol ByteCollection: RandomAccessCollection<UInt8>, Sendable where Self.Index: Sendable, Self.SubSequence: ByteCollection {}

extension Data: ByteCollection {}

extension Array<UInt8>.SubSequence: ByteCollection {}
extension Array<UInt8>: ByteCollection {}
