enum PrimaryElement : Hashable, CaseIterable {
    case plant
    case fire
    case earth
    case cold
    case lightning
    case water
    case air
    case metal
    case light
    case dark
}
extension PrimaryElement : CustomStringConvertible {
    var description: String {
        switch self {
        case .plant : return "plant"
        case .fire : return "fire"
        case .earth : return "earth"
        case .cold : return "cold"
        case .lightning : return "lightning"
        case .water : return "water"
        case .air : return "air"
        case .metal : return "metal"
        case .light : return "light"
        case .dark : return "dark"
        }
    }
}
extension PrimaryElement : Equatable {
    static func ==(lhs: PrimaryElement, rhs: PrimaryElement) -> Bool {
        switch (lhs, rhs) {
        case (.plant, .plant), (.fire, .fire), (.earth, .earth), (.cold, .cold), (.lightning, .lightning),
             (.water, .water), (.air, .air), (.metal, .metal), (.light, .light), (.dark, .dark) :
            return true
        default:
            return false
        }
    }
}
extension PrimaryElement : Comparable {
    static func <(lhs: PrimaryElement, rhs: PrimaryElement) -> Bool {
        return "\(lhs)" < "\(rhs)"
    }
}
