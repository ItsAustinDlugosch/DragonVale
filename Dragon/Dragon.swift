// Represents a dragon
struct Dragon: Codable, Equatable {
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
