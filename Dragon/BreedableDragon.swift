struct BreedableDragon: Hashable, Equatable {
    let dragon: Dragon
    let breedInformation: BreedInformation
    
    var name: String { dragon.name }
    var rarity: Rarity { dragon.rarity }
    var visibleElements: Set<DragonElement>? { dragon.visibleElements }
    var requiredTrait: PrimaryElement? { dragon.requiredTrait }
    var evolutionDragonName: String? { dragon.evolutionDragonName }
    var isRiftable: Bool { dragon.isRiftable }
    var isElderable: Bool { dragon.isElderable }
    var earnGold: Float? { dragon.earnGold }
    var earnEtherium: Int? { dragon.earnEtherium }
    var earnGem: Int? { dragon.earnGem }
    var magicCost: Int? { dragon.magicCost }
    var eventSection: Int? { dragon.eventSection }
    var quest: String? { dragon.quest } 
    
    var isBreeder: Bool {
        return rarity != .gemstone && rarity != .legendary && rarity != .mythic
    }
    
    init?(from dragon: Dragon) {
        guard dragon.breedInformation != nil else {
            return nil
        }
        self.dragon = dragon
        self.breedInformation = dragon.breedInformation!
    }
    
    func isSatisfiedBy(breedComponents: BreedComponents) -> Bool {
        return breedInformation.isSatisfiedBy(breedComponents: breedComponents)
    }

    public static func == (lhs: BreedableDragon, rhs: BreedableDragon) -> Bool {
        return lhs.dragon == rhs.dragon
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(dragon)
    }
}
