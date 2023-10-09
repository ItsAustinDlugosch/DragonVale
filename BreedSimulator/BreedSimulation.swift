struct BreedSimulation {
    let breedSimulator: BreedSimulator
    let breedComponents: BreedComponents

    var dragonResults: [BreedableDragon: Float] {        
        return [:]
    }

    init(breedComponents: BreedComponents) {
        precondition(BreedSimulator.shared != nil, "Cannot initialize BreedSimulation prior to inializing BreedSimulator")
        self.breedSimulator = BreedSimulator.shared!
        self.breedComponents = breedComponents
    }

    func dragonsSatisfied() -> Set<BreedableDragon> {
        return breedSimulator.dragonarium.breedableDragons.filter { $0.isSatisfiedBy(breedComponents: breedComponents) }
    }
}
