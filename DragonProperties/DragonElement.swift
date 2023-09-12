enum DragonElement : Hashable {
    case primary(_ primaryElement: PrimaryElement)
    case epic(_ epicElement: EpicElement)    

    init?(_ value: String) {
        switch value {            
        case "plant" : self = .primary(.plant)
        case "fire" : self = .primary(.fire)
        case "earth" : self = .primary(.earth)
        case "cold" : self = .primary(.cold)
        case "lightning" : self = .primary(.lightning)
        case "water" : self = .primary(.water)
        case "air" : self = .primary(.air)
        case "metal" : self = .primary(.metal)
        case "light" : self = .primary(.light)
        case "dark" : self = .primary(.dark)
        case "rift" : self = .epic(.rift)
        case "apocalypse" : self = .epic(.apocalypse)
        case "aura" : self = .epic(.aura)
        case "chrysalis" : self = .epic(.chrysalis)
        case "crystalline" : self = .epic(.crystalline)
        case "dream" : self = .epic(.dream)
        case "galaxy" : self = .epic(.galaxy)
        case "gemstone" : self = .epic(.gemstone)
        case "hidden" : self = .epic(.hidden)
        case "melody" : self = .epic(.melody)
        case "monolith" : self = .epic(.monolith)
        case "moon" : self = .epic(.moon)
        case "olympus" : self = .epic(.olympus)
        case "ornamental" : self = .epic(.ornamental)
        case "rainbow" : self = .epic(.rainbow)
        case "seasonal" : self = .epic(.seasonal)
        case "snowflake" : self = .epic(.snowflake)
        case "sun" : self = .epic(.sun)
        case "surface" : self = .epic(.surface)
        case "treasure" : self = .epic(.treasure)
        case "zodiac" : self = .epic(.zodiac)

        case "P" : self = .primary(.plant)
        case "F" : self = .primary(.fire)
        case "E" : self = .primary(.earth)
        case "C" : self = .primary(.cold)
        case "L" : self = .primary(.lightning)
        case "W" : self = .primary(.water)
        case "A" : self = .primary(.air)
        case "M" : self = .primary(.metal)
        case "I" : self = .primary(.light)
        case "D" : self = .primary(.dark)
        case "R" : self = .epic(.rift)
        case "Ap" : self = .epic(.apocalypse)
        case "Au" : self = .epic(.aura)
        case "Ch" : self = .epic(.chrysalis)
        case "Cr" : self = .epic(.crystalline)
        case "Dr" : self = .epic(.dream)
        case "Ga" : self = .epic(.galaxy)
        case "Ge" : self = .epic(.gemstone)
        case "Hi" : self = .epic(.hidden)
        case "Me" : self = .epic(.melody)
        case "Mh" : self = .epic(.monolith)
        case "Mo" : self = .epic(.moon)
        case "Ol" : self = .epic(.olympus)
        case "Or" : self = .epic(.ornamental)
        case "Rb" : self = .epic(.rainbow)
        case "Se" : self = .epic(.seasonal)
        case "Sn" : self = .epic(.snowflake)
        case "Su" : self = .epic(.sun)
        case "Sf" : self = .epic(.surface)
        case "Tr" : self = .epic(.treasure)
        case "Zo" : self = .epic(.zodiac)
        default: return nil
        }
    }
}
extension DragonElement : CustomStringConvertible {
    var description: String {
        switch self {
        case .primary(let primaryElement) : return "\(primaryElement)"
        case .epic(let epicElement) : return "\(epicElement)"
        }
    }
}
extension DragonElement : Equatable {
    static func == (lhs: DragonElement, rhs: DragonElement) -> Bool {
        switch (lhs, rhs) {
        case (.primary(let leftPrimaryElement), .primary(let rightPrimaryElement)) :
            return leftPrimaryElement == rightPrimaryElement
        case (.epic(let leftEpicElement), .epic(let rightEpicElement)) :
            return leftEpicElement == rightEpicElement
        default :
            return false
        }
    }    
}
extension DragonElement : CaseIterable {
    static var allCases: [DragonElement] {
        var allCases = [DragonElement]()
        for primaryElement in PrimaryElement.allCases {
            allCases.append(.primary(primaryElement))
        }
        for epicElement in EpicElement.allCases {
            allCases.append(.epic(epicElement))
        }
        return allCases
    }
}

extension DragonElement : Comparable {
    static func <(lhs: DragonElement, rhs: DragonElement) -> Bool {
        return "\(lhs)" < "\(rhs)"
    }
}
