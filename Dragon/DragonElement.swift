// Represents the an element of a dragon.
// - `primary`: Primary Element
// - `epic`: Epic Element
enum DragonElement : Hashable, Comparable {
    case primary(_ primaryElement: PrimaryElement)
    case epic(_ epicElement: EpicElement)
    
    // Dictionary that maps a string to a Primary Element
    private static let primaryElementMap: [String: PrimaryElement] = [
      "plant": .plant,
      "P": .plant,
      "fire": .fire,
      "F": .fire,
      "earth": .earth,
      "E": .earth,
      "cold": .cold,
      "C": .cold,
      "lightning": .lightning,
      "L": .lightning,
      "water": .water,
      "W": .water,
      "air": .air,
      "A": .air,
      "metal": .metal,
      "M": .metal,
      "light": .light,
      "I": .light,
      "dark": .dark,
      "D": .dark
    ]

    // Dictionary that maps a string to an Epic Element
    private static let epicElementMap: [String: EpicElement] = [
      "rift": .rift,
      "R": .rift,
      "apocalypse": .apocalypse,
      "Ap": .apocalypse,
      "aura": .aura,
      "Au": .aura,
      "chrysalis": .chrysalis,
      "Ch": .chrysalis,
      "crystalline": .crystalline,
      "Cr": .crystalline,
      "dream": .dream,
      "Dr": .dream,
      "galaxy": .galaxy,
      "Ga": .galaxy,
      "gemstone": .gemstone,
      "Ge": .gemstone,
      "hidden": .hidden,
      "Hi": .hidden,
      "melody": .melody,
      "Me": .melody,
      "monolith": .monolith,
      "Mh": .monolith,
      "moon": .moon,
      "Mo": .moon,
      "olympus": .olympus,
      "Ol": .olympus,
      "ornamental": .ornamental,
      "Or": .ornamental,
      "rainbow": .rainbow,
      "Rb": .rainbow,
      "seasonal": .seasonal,
      "Se": .seasonal,
      "snowflake": .snowflake,
      "Sn": .snowflake,
      "sun": .sun,
      "Su": .sun,
      "surface": .surface,
      "Sf": .surface,
      "treasure": .treasure,
      "Tr": .treasure,
      "zodiac": .zodiac,
      "Zo": .zodiac
    ]        
    init?(_ value: String) {              
        if let primary = DragonElement.primaryElementMap[value] {
            self = .primary(primary)
        } else if let epic = DragonElement.epicElementMap[value] {
            self = .epic(epic)
        } else {
            return nil
        }
    }

    var order: Int {
        switch self {
        case .primary(let primary): return primary.order
        case .epic(let epic): return epic.order + 10 // Account for primary order
        }
    }

    static func < (lhs: DragonElement, rhs: DragonElement) -> Bool {
        return lhs.order < rhs.order
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

extension DragonElement: Codable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.description)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)

        // Use the primaryElementMap and the epicElementMap to get the corresponding enum value
        if let primaryElement = DragonElement.primaryElementMap[stringValue] {
            self = .primary(primaryElement)
        } else if let epicElement = DragonElement.epicElementMap[stringValue] {
            self = .epic(epicElement)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid dragon element value: \(stringValue)")
        }                
    }
}
