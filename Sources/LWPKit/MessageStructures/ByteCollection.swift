import Foundation

public protocol ByteCollection: RandomAccessCollection<UInt8>, Sendable where Self.Index: Sendable, Self.SubSequence: ByteCollection {}

extension Data: ByteCollection {}

extension [UInt8].SubSequence: ByteCollection {}
extension [UInt8]: ByteCollection {}
