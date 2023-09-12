extension Set {
    static func +(lhs: Set, rhs: Set) -> Set {
        var merged = rhs
        lhs.forEach {merged.insert($0)}
        return merged
    }
    static func -(lhs: Set, rhs: Set) -> Set {
        var merged = lhs
        rhs.forEach {merged.remove($0)}
        return merged
    }
}
