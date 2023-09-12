enum EpicElement : Hashable, CaseIterable {
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
        case .rift : return "rift"
        case .apocalypse : return "apocalypse"
        case .aura : return "aura"
        case .chrysalis : return "chrysalis"
        case .crystalline : return "crystalline"
        case .dream : return "dream"
        case .galaxy : return "galaxy"
        case .gemstone : return "gemstone"
        case .hidden : return "hidden"
        case .melody : return "melody"
        case .monolith : return "monolith"
        case .moon : return "moon"
        case .olympus : return "olympus"
        case .ornamental : return "ornamental"
        case .rainbow : return "rainbow"
        case .seasonal : return "seasonal"
        case .snowflake : return "snowflake"
        case .sun : return "sun"
        case .surface : return "surface"
        case .treasure : return "treasure"
        case .zodiac : return "zodiac"
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
extension EpicElement : Comparable {
    static func <(lhs: EpicElement, rhs: EpicElement) -> Bool {
        return "\(lhs)" < "\(rhs)"
    }
}
