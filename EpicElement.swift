enum EpicElement : Hashable {
    case rift
    case apocalypse
    case aura
    case chrysalis
    case crystalline
    case dream
    case galaxy
    case gemstone
    case hidden
    case melody
    case monolith
    case moon
    case olympus
    case ornamental
    case rainbow
    case seasonal
    case snowflake
    case sun
    case surface
    case treasure
    case zodiac
}
extension EpicElement : CustomStringConvertible {
    var description: String {
        switch self {
        case .rift : return "Rift"
        case .apocalypse : return "Apocalypse"
        case .aura : return "Aura"
        case .chrysalis : return "Chrysalis"
        case .crystalline : return "Crystalline"
        case .dream : return "Dream"
        case .galaxy : return "Galaxy"
        case .gemstone : return "Gemstone"
        case .hidden : return "Hidden"
        case .melody : return "Melody"
        case .monolith : return "Monolith"
        case .moon : return "Moon"
        case .olympus : return "Olympus"
        case .ornamental : return "Ornamental"
        case .rainbow : return "Rainbow"
        case .seasonal : return "Seasonal"
        case .snowflake : return "Snowflake"
        case .sun : return "Sun"
        case .surface : return "Surface"
        case .treasure : return "Treasure"
        case .zodiac : return "Zodiac"
        }
    }
}
extension EpicElement : Equatable {
    static func ==(lhs: EpicElement, rhs: EpicElement) -> Bool {
        switch (lhs, rhs) {
        case (.rift, .rift), (.apocalypse, .apocalypse), (.aura, .aura), (.chrysalis, .chrysalis), (.crystalline, .crystalline),
             (.dream, .dream), (.galaxy, .galaxy), (.gemstone, .gemstone), (.hidden, .hidden), (.melody, .melody), (.monolith, .monolith),
             (.moon, .moon), (.olympus, .olympus), (.ornamental, .ornamental), (.rainbow, .rainbow), (.seasonal, .seasonal), (.snowflake, .snowflake),
             (.sun, .sun), (.surface, .surface), (.treasure, .treasure), (.zodiac, .zodiac):            
            return true
        default:
            return false
        }
    }
}
