class BreedInformation {
    let dragonOne : Dragon
    let dragonTwo : Dragon
    let breedComponents : Set<BreedRequirement>
    let elementCount : Int
    
    init(_ dragonOne: Dragon, _ dragonTwo: Dragon) {
        self.dragonOne = dragonOne
        self.dragonTwo = dragonTwo
        let breedElements = dragonOne.elements + dragonTwo.elements
        self.elementCount = breedElements.count
        var breedComponents = Set<BreedRequirement>()
        [.dragon(dragonOne.name), .dragon(dragonTwo.name), .elementCount(elementCount)].forEach { breedComponents.insert($0) }
        for element in breedElements {
            breedComponents.insert(.dragonElement(element))            
        }
        self.breedComponents = breedComponents      
    }
}

extension BreedInformation : Equatable {
    static func ==(lhs: BreedInformation, rhs: BreedInformation) -> Bool {
        return lhs.dragonOne == rhs.dragonOne && lhs.dragonTwo == rhs.dragonTwo
          || lhs.dragonOne == rhs.dragonTwo && lhs.dragonTwo == rhs.dragonOne
    }
}

extension BreedInformation : Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(dragonOne)
        hasher.combine(dragonTwo)
    }
}
