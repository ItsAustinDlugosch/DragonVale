// Represents the primary elements to which a dragon can belong.
// Conforms to `Hashable` for unique identification, `CaseIterable` for iterating over all cases, and `Comparable` for ordering.
enum PrimaryElement: String, Hashable, CaseIterable, Comparable, CustomStringConvertible {
    
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

    // Dictionary that maps strings to PrimaryElement
    private static let primaryElementMap: [String: PrimaryElement] = [
      "plant": .plant,
      "fire": .fire,
      "earth": .earth,
      "cold": .cold,
      "lightning": .lightning,
      "water": .water,
      "air": .air,
      "metal": .metal,
      "light": .light,
      "dark": .dark
    ]

    // Dictionary that maps PrimaryElement to its opposite PrimaryElement
    static let oppositeElementMap: [PrimaryElement: PrimaryElement] = [
      .plant: .metal,
      .fire: .cold,
      .earth: .air,
      .cold: .fire,
      .lightning: .water,
      .water: .lightning,
      .air: .earth,
      .metal: .plant,
      .light: .dark,
      .dark: .light
    ]

    init?(_ value: String) {
        if let primaryElement = PrimaryElement.primaryElementMap[value] {
            self = primaryElement
        } else {
            return nil
        }
    }

    // The order in which elements should be sorted.
    var order: Int {
        switch self {
        case .plant: return 0
        case .fire: return 1
        case .earth: return 2
        case .cold: return 3
        case .lightning: return 4
        case .water: return 5
        case .air: return 6
        case .metal: return 7
        case .light: return 8
        case .dark: return 9
        }
    }

    var description: String {
        return PrimaryElement.primaryElementMap.first { $0.value == self }?.key ?? ""
    }

    // Defines the less-than operation for comparing `PrimaryElement`s based on their `order`.
    static func <(lhs: PrimaryElement, rhs: PrimaryElement) -> Bool {
        return lhs.order < rhs.order
    }
}

extension PrimaryElement: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.description)
    }
}

extension PrimaryElement: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)

        // Use the primaryElementMap to get the corresponding enum value
        if let primaryElement = PrimaryElement.primaryElementMap[stringValue] {
            self = primaryElement
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid primary element value: \(stringValue)")
        }
    }
}
