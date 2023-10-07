// Represents a dragon as a breed component with a possible required trait
struct DragonInstance : Codable, Equatable, Hashable {
    let dragonName: String
    let riftTrait: PrimaryElement?

    init?(_ dragonName: String = "", _ riftTrait: PrimaryElement? = nil) {
        guard dragonName != "" else {
        return nil
    }
        self.dragonName = dragonName
        self.riftTrait = riftTrait
    }

    public static func == (lhs: DragonInstance, rhs: DragonInstance) -> Bool {
        return lhs.dragonName == rhs.dragonName &&
          lhs.riftTrait == rhs.riftTrait
    }

    private enum CodingKeys: String, CodingKey {
        case dragonName = "name"
        case riftTrait
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(dragonName, forKey: .dragonName)
        
        if let trait = riftTrait {
            try container.encode(trait, forKey: .riftTrait)
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(dragonName)
        hasher.combine(riftTrait)
    }
}
