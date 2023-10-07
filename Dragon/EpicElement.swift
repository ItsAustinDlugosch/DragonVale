// Represents the epic elements to which a dragon can belong.
// Conforms to `Hashable` for unique identification, `CaseIterable` for iterating over all cases,
// `CustomStringConvertible` for textual representation, and `Comparable` for ordering.
enum EpicElement: String, Hashable, CaseIterable, CustomStringConvertible, Comparable {
    
    // The available epic elements.
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

    // Dictionary that maps a string to an Epic Element
    private static let epicElementMap: [String: EpicElement] = [
      "rift": .rift,
      "apocalypse": .apocalypse,
      "aura": .aura,
      "chrysalis": .chrysalis,
      "crystalline": .crystalline,
      "dream": .dream,
      "galaxy": .galaxy,
      "gemstone": .gemstone,
      "hidden": .hidden,
      "melody": .melody,      
      "monolith": .monolith,
      "moon": .moon,
      "olympus": .olympus,
      "ornamental": .ornamental,
      "rainbow": .rainbow,
      "seasonal": .seasonal,
      "snowflake": .snowflake,
      "sun": .sun,
      "surface": .surface,
      "treasure": .treasure,
      "zodiac": .zodiac,
    ]

    init?(_ value: String) {
        if let epicElement = EpicElement.epicElementMap[value] {
            self = epicElement
        } else {
            return nil
        }
    }

    // A textual representation of this instance.
    var description: String {
        return EpicElement.epicElementMap.first { $0.value == self }?.key ?? ""
    }

    // The order in which elements should be sorted.
    var order: Int {
        switch self {
        case .rift: return 0
        case .apocalypse: return 1
        case .aura: return 2
        case .chrysalis: return 3
        case .crystalline: return 4
        case .dream: return 5
        case .galaxy: return 6
        case .gemstone: return 7
        case .hidden: return 8
        case .melody: return 9
        case .monolith: return 10
        case .moon: return 11
        case .olympus: return 12
        case .ornamental: return 13
        case .rainbow: return 14
        case .seasonal: return 15
        case .snowflake: return 16
        case .sun: return 17
        case .surface: return 18
        case .treasure: return 19
        case .zodiac: return 20
        }
    }

    // Defines the less-than operation for comparing `EpicElement`s based on their `order`.
    static func < (lhs: EpicElement, rhs: EpicElement) -> Bool {
        return lhs.order < rhs.order
    }
}

extension EpicElement: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.description)
    }
}

extension EpicElement: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)

        // Use the epicElementMap to get the corresponding enum value
        if let epicElement = EpicElement.epicElementMap[stringValue] {
            self = epicElement
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid primary element value: \(stringValue)")
        }
    }
}
