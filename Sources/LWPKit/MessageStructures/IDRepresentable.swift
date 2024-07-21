public protocol IDRepresentable<ID> where ID: FixedWidthInteger {
    associatedtype ID

    init?(id: Self.ID)
    var id: Self.ID { get }
}

extension IDRepresentable where Self: RawRepresentable, ID == RawValue {
    public init?(id: Self.ID) {
        self.init(rawValue: id)
    }

    public var id: ID {
        rawValue
    }
}
