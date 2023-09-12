enum Rarity : Hashable {
    case primary
    case riftPrimary
    case hybrid
    case rare
    case epic
    case galaxy
    case gemstone

    init?(_ value: String) {
        switch value {
        case "Primary" : self = .primary
        case "Primary Rift" : self = .riftPrimary
        case "Hybrid" : self = .hybrid
        case "Rare" : self = .rare
        case "Epic" : self = .epic
        case "Galaxy" : self = .galaxy
        case "Gemstone" : self = .gemstone
        default:
            print("Failed to create rarity from '\(value)'.")
            return nil
        }
    }
}

extension Rarity : CustomStringConvertible {
    var description: String {        
        switch self {
        case .primary : return "Primary"
        case .riftPrimary : return "Primary Rift"
        case .hybrid : return "Hybrid"
        case .rare : return "Rare"
        case .epic : return "Epic"
        case .galaxy : return "Galaxy"
        case .gemstone : return "Gemstone"
        }
    }
}

extension Rarity : Equatable {
    static func == (lhs: Rarity, rhs: Rarity) -> Bool {
        switch (lhs, rhs) {
        case (.primary, .primary), (.riftPrimary, .riftPrimary), (.hybrid, .hybrid), (.rare, .rare), (.epic, .epic), (.galaxy, .galaxy), (.gemstone, .gemstone):
            return true
        default:
            return false
        }
    }
}
