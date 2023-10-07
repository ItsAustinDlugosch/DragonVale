// Represents the rarity of a dragon.
// - `primary`: Primary dragon
// - `riftPrimary`: Rift primary dragon
// - `hybrid`: Hybrid dragon
// - `rare`: Rare dragon
// - `epic`: Epic dragon
// - `galaxy`: Galaxy dragon
// - `gemstone`: Gemstone dragon
enum Rarity: Hashable, CustomStringConvertible {
    case primary
    case riftPrimary
    case hybrid
    case rare
    case epic
    case galaxy
    case gemstone
    case mythic
    case legendary

    // Dictionary that maps a string to a Rarity
    private static let rarityMap: [String: Rarity] = [
      "Primary": .primary,
      "Primary Rift": .riftPrimary,
      "Hybrid": .hybrid,
      "Rare": .rare,
      "Epic": .epic,
      "Galaxy": .galaxy,
      "Gemstone": .gemstone,
      "Mythic": .mythic,            
      "Legendary": .legendary
    ]
    
    init?(_ value: String) {      
        guard let rarity = Rarity.rarityMap[value] else {
            print("Failed to create rarity from '\(value)'.")
            return nil
        }
        
        self = rarity
    }
    
    // String representation for each rarity level.
    var description: String {
        return Rarity.rarityMap.first { $0.value == self }?.key ?? ""
    }
}

extension Rarity: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.description)
    }
}

extension Rarity: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        
        // Use the rarityMap to get the corresponding enum value
        if let rarity = Rarity.rarityMap[stringValue] {
            self = rarity
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid rarity value: \(stringValue)")
        }
    }
}
