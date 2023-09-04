enum PrimaryElement : Hashable {
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
        case .plant : return "Plant"
        case .fire : return "Fire"
        case .earth : return "Earth"
        case .cold : return "Cold"
        case .lightning : return "Lightning"
        case .water : return "Water"
        case .air : return "Air"
        case .metal : return "Metal"
        case .light : return "Light"
        case .dark : return "Dark"
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
