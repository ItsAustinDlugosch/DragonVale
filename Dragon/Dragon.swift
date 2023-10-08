// Represents a dragon
struct Dragon: Equatable {
    let name: String
    let rarity: Rarity
    let visibleElements: Set<DragonElement>?
    let requiredTrait: PrimaryElement?
    let breedInformation: BreedInformation?
    let evolutionDragonName: String?
    let riftable: Bool
    let elderable: Bool
    let earnGold: Float?
    let earnEtherium: Int?
    let earnGem: Int?
    let magicCost: Int?
    let eventSection: Int?
    let quest: String?

    init(name: String, rarity: Rarity, visibleElements: Set<DragonElement>? = nil, requiredTrait: PrimaryElement? = nil, breedInformation: BreedInformation? = nil, evolutionDragonName: String? = nil, riftable: Bool, elderable: Bool, earnGold: Float? = nil, earnEtherium: Int? = nil, earnGem: Int? = nil, magicCost: Int? = nil, eventSection: Int? = nil, quest: String? = nil) {
        self.name = name
        self.rarity = rarity
        self.visibleElements = visibleElements
        self.requiredTrait = requiredTrait
        self.breedInformation = breedInformation
        self.evolutionDragonName = evolutionDragonName
        self.riftable = riftable
        self.elderable = elderable
        self.earnGold = earnGold
        self.earnEtherium = earnEtherium
        self.earnGem = earnGem
        self.magicCost = magicCost
        self.eventSection = eventSection
        self.quest = quest
    }

    var breedable: Bool {
        return breedInformation != nil
    }

    var evolvable: Bool {
        return evolutionDragonName != nil
    }

    public static func == (lhs: Dragon, rhs: Dragon) -> Bool {
        return lhs.name == rhs.name &&
          lhs.rarity == rhs.rarity &&
          lhs.visibleElements == rhs.visibleElements &&
          lhs.requiredTrait == rhs.requiredTrait &&          
          lhs.breedInformation == rhs.breedInformation &&
          lhs.evolutionDragonName == rhs.evolutionDragonName &&
          lhs.riftable == rhs.riftable &&
          lhs.elderable == rhs.elderable &&
          lhs.earnGold == rhs.earnGold &&
          lhs.earnEtherium == rhs.earnEtherium &&
          lhs.earnGem == rhs.earnGem &&
          lhs.magicCost == rhs.magicCost &&
          lhs.eventSection == rhs.eventSection &&
          lhs.quest == rhs.quest
    }
}

extension Dragon: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(rarity)
        hasher.combine(visibleElements)
        hasher.combine(requiredTrait)
        hasher.combine(breedInformation)
        hasher.combine(evolutionDragonName)
        hasher.combine(riftable)
        hasher.combine(elderable)
        hasher.combine(earnGold)
        hasher.combine(earnEtherium)
        hasher.combine(earnGem)
        hasher.combine(magicCost)
        hasher.combine(eventSection)
        hasher.combine(quest)
    }
}
extension Dragon: Codable {
    private enum CodingKeys: String, CodingKey {
        case name, rarity, visibleElements, requiredTrait, breedInformation, evolutionDragonName, riftable, elderable, earnGold, earnEtherium, earnGem, magicCost, eventSection, quest
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(rarity, forKey: .rarity)
        if let visibleElements = visibleElements,
           !visibleElements.isEmpty {
            try container.encode(visibleElements, forKey: .visibleElements)
        }
        if let requiredTrait = requiredTrait {
            try container.encode(requiredTrait, forKey: .requiredTrait)
        }
        if let breedInformation = breedInformation {
            try container.encode(breedInformation, forKey: .breedInformation)
        }
        if let evolutionDragonName = evolutionDragonName {
            try container.encode(evolutionDragonName, forKey: .evolutionDragonName)
        }
        try container.encode(riftable, forKey: .riftable)
        try container.encode(elderable, forKey: .elderable)
        if let earnGold = earnGold {
            try container.encode(earnGold, forKey: .earnGold)
        }
        if let earnEtherium = earnEtherium {
            try container.encode(earnEtherium, forKey: .earnEtherium)
        }
        if let earnGem = earnGem {
            try container.encode(earnGem, forKey: .earnGem)
        }
        if let magicCost = magicCost {
            try container.encode(magicCost, forKey: .magicCost)
        }
        if let eventSection = eventSection {
            try container.encode(eventSection, forKey: .eventSection)
        }
        if let quest = quest {
            try container.encode(quest, forKey: .quest)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard let name = try container.decodeIfPresent(String.self, forKey: .name) else {
        print("Missing key value of name expected when decoding Dragon")
        fatalError()
    }
        guard let rarity = try container.decodeIfPresent(Rarity.self, forKey: .rarity) else {
        print("Missing key value of rarity expected when decoding Dragon")
        fatalError()
    }
        guard let riftable = try container.decodeIfPresent(Bool.self, forKey: .riftable) else {
        print("Missing key value of riftable expected when decoding Dragon")
        fatalError()
    }
        guard let elderable = try container.decodeIfPresent(Bool.self, forKey: .elderable) else {
        print("Missting key value of elderable expected when decoding Dragon")
        fatalError()
    }
        self.name = name        
        self.rarity = rarity
        visibleElements = try container.decodeIfPresent(Set<DragonElement>.self, forKey: .visibleElements)
        requiredTrait = try container.decodeIfPresent(PrimaryElement.self, forKey: .requiredTrait)
        breedInformation = try container.decodeIfPresent(BreedInformation.self, forKey: .breedInformation)
        evolutionDragonName = try container.decodeIfPresent(String.self, forKey: .evolutionDragonName)        
        self.riftable = riftable
        self.elderable = elderable
        earnGold = try container.decodeIfPresent(Float.self, forKey: .earnGold)
        earnEtherium = try container.decodeIfPresent(Int.self, forKey: .earnEtherium)
        earnGem = try container.decodeIfPresent(Int.self, forKey: .earnGem)
        magicCost = try container.decodeIfPresent(Int.self, forKey: .magicCost)
        eventSection = try container.decodeIfPresent(Int.self, forKey: .eventSection)
        quest = try container.decodeIfPresent(String.self, forKey: .quest)
    }
}
