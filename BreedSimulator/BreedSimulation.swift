class BreedSimulation {
    let breedSimulator: BreedSimulator
    let breedComponents: BreedComponents

    lazy var breedResults: [BreedableDragon: Float] = {
        var breedResults: [BreedableDragon: Float] = [:]
        var totalPercentage: Float = 0.0
        let cloneDragons = self.clones
        let fixedDragons: Set<BreedableDragon> = Set(self.dragonsSatisfied.filter { $0.breedType == .fixed }.map { $0.dragon })
        let totalFixedDragonPercentage = fixedDragons.reduce(0.0, { left, right in left + right.breedInformation.ownZeroBreedPercentage! })
        let fluctuatingDragons: Set<BreedableDragon> = Set(self.dragonsSatisfied.filter { $0.breedType == .fluctuating }.map { $0.dragon })
        
        func singleClonePercentageByCave(_ breedInformation: BreedInformation) -> Float {
            let cave = breedSimulator.cave
            switch cave {
            case .normal: return breedInformation.normalSingleClonePercentage
            case .social: return breedInformation.socialSingleClonePercentage
            case .rift: return breedInformation.riftSingleClonePercentage
            }
        }
        func doubleClonePercentageByCave(_ breedInformation: BreedInformation) -> Float {
            let cave = breedSimulator.cave
            switch cave {
            case .normal: return breedInformation.normalDoubleClonePercentage
            case .social: return breedInformation.socialDoubleClonePercentage
            case .rift: return breedInformation.riftDoubleClonePercentage
            }
        }
        
        // Handle Clones
        if cloneDragons.count == 2 {
            cloneDragons.forEach {
                let cloneChance = singleClonePercentageByCave($0.breedInformation)
                if cloneChance > 0.0 {
                    breedResults[$0] = cloneChance
                    totalPercentage += cloneChance
                }
            }
        }
        if cloneDragons.count == 1 {
            cloneDragons.forEach {
                let cloneChance = doubleClonePercentageByCave($0.breedInformation)
                if cloneChance > 0.0 {
                    breedResults[$0] = cloneChance
                    totalPercentage += cloneChance
                }
            }
        }
        // Find Fixed Multiplier, ClonePercentage (what is currently totalPercentage) + totalFixedDragonPercentage must be <= 99
        let fixedMultiplier: Float
        print(totalPercentage, totalFixedDragonPercentage, totalPercentage + totalFixedDragonPercentage)
        if totalPercentage + totalFixedDragonPercentage < 0.99 {
            fixedMultiplier = 1
        } else {
            fixedMultiplier = (0.99 - totalPercentage) / totalFixedDragonPercentage
        }
        print(fixedMultiplier)
        // Handle Fixed Dragons
        print("fixed")
        fixedDragons.forEach {                        
            let breedChance = $0.breedInformation.ownZeroBreedPercentage! * fixedMultiplier
            print($0.name, breedChance)
            breedResults[$0] = (breedResults[$0] ?? 0.0) + (breedChance)
            totalPercentage += breedChance
        }
        print()
        // Find Fluctuating Breed Chance, totalPercentage (accounting for clones and fixed) + fluctuating must be == 100, fluctuating = 100 - total / # of fluctuating dragons
        let fluctuatingBreedChance = (1.0 - totalPercentage) / Float(fluctuatingDragons.count)
        // Handle Fluctuating Dragons
        print("fluctuating")
        fluctuatingDragons.forEach {
            let breedChance = fluctuatingBreedChance
            print($0.name, breedChance)
            breedResults[$0] = (breedResults[$0] ?? 0.0) + breedChance
            totalPercentage += breedChance
        }
        print()
        return breedResults
    }()

    lazy var dragonsSatisfied: [(dragon: BreedableDragon, breedType: BreedType)] = {
        let fixedDragons = breedSimulator.dragonarium.fixedDragons
        let fluctuatingDragons = breedSimulator.dragonarium.fluctuatingDragons
        var dragonsSatisfied = [(BreedableDragon, BreedType)]()
        
        // Insert satisfied fixed dragons
        fixedDragons.forEach {
            if $0.isSatisfiedBy(breedComponents: breedComponents) && $0.breedInformation.breedAvailability != .unavailable {
                dragonsSatisfied.append(($0, .fixed))
            }
        }
        
        // Insert satisfied hybrid dragons
        let hybridDragons = fluctuatingDragons.filter {$0.rarity == .hybrid}
        hybridDragons.forEach {
            if Set($0.breedInformation.breedRequirements.primaryElements).isSubset(of: Set(breedComponents.primaryElements)) {
                dragonsSatisfied.append(($0, .fluctuating))
            }
        }        
        
        // Insert satisfied primary dragons
        let primaryDragons = fluctuatingDragons.filter {$0.rarity == .primary}        
        primaryDragons.forEach {            
            precondition($0.breedInformation.elements.count == 1, "Primary dragons must have a single element. \($0.name) \($0.breedInformation.elements)")
            guard case .primary(let primaryElement) = $0.breedInformation.elements.first! else {
            fatalError("Primary dragons must have a Primary Element as their only element.")
        }
            if Set(breedComponents.primaryElements) == Set([primaryElement, PrimaryElement.oppositeElementMap[primaryElement]]) {
                dragonsSatisfied.append(($0, .fluctuating))
            }
        }
        
        return dragonsSatisfied              
    }()

    lazy var clones: Set<BreedableDragon> = {
        return Set<BreedableDragon>(breedComponents.dragons.compactMap { breedSimulator.dragonarium.breedableDragon($0.dragonName) })
    }()

    init(breedComponents: BreedComponents) {
        precondition(BreedSimulator.shared != nil, "Cannot initialize BreedSimulation prior to inializing BreedSimulator")
        self.breedSimulator = BreedSimulator.shared!
        self.breedComponents = breedComponents
    }

    func compositePercentage(favorableResults: Set<BreedableDragon>) -> Float {
        let favorableResultsBred = favorableResults.compactMap { breedResults[$0] }
        return favorableResultsBred.reduce(0.0, { left, right in left + right})
    }
    func targetPercentage(target: BreedableDragon) -> Float {
        return breedResults[target] ?? 0.0
    }
}

