enum Limited {
    case constant
    case unavailable
    case available

    init(_ value: String) {
        switch value {
        case "A": self = .available
        case "U": self = .unavailable
        default: self = .constant
        }
    }
}

extension Limited : CustomStringConvertible {
    var description: String {
        switch self {
        case .constant : return "C"
        case .unavailable: return "U"
        case .available : return "A"
        }
    }
}
