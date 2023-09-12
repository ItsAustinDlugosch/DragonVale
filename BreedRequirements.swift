class BreedRequirements {
    let breedRequirements : Set<BreedRequirement>
    var specialRequirements : String = ""
    var count : Int {
        return breedRequirements.count
    }
    var primaryElements : Set<PrimaryElement> {
        return primaryElementsRequired()
    }
    var epicElements : Set<EpicElement> {
        return epicElementsRequired()
    }
    var dragons : Set<String> {
        return dragonsRequired()
    }    

    init(breedRequirements: Set<BreedRequirement>) {
        var breedRequirements = breedRequirements
        for requirement in breedRequirements {
            if case let .specialRequirement(specialRequirement) = requirement {
                self.specialRequirements.append("[\(specialRequirement)]")
                breedRequirements.remove(requirement)
            }
        }
        self.breedRequirements = breedRequirements
    }

    convenience init(dragons: Set<Dragon>) {
        self.init(breedRequirements: dragons.reduce(Set<BreedRequirement>(), {(compositeRequirements, dragon) in
                                                                                 return compositeRequirements + dragon.breedRequirements}))
    }

    func satisfiesRequirements(_ breedComponents: Set<BreedRequirement>) -> Bool {
        return breedComponents.isSuperset(of: breedRequirements) || breedRequirements == breedComponents 
    }

    func primaryElementsRequired() -> Set<PrimaryElement> {
        var primaryElementsRequired = Set<PrimaryElement>()
        breedRequirements.forEach {
            if case let .dragonElement(element) = $0, case let .primary(primaryElement) = element {
                primaryElementsRequired.insert(primaryElement)
            }
        }
        return primaryElementsRequired
    }
    func epicElementsRequired() -> Set<EpicElement> {
        var epicElementsRequired = Set<EpicElement>()
        breedRequirements.forEach {
            if case let .dragonElement(element) = $0, case let .epic(epicElement) = element {
                epicElementsRequired.insert(epicElement)
            }
        }
        return epicElementsRequired
    }
    func dragonsRequired() -> Set<String> {
        var dragonsRequired = Set<String>()
        breedRequirements.forEach {
            if case let .dragon(dragon) = $0 {
                dragonsRequired.insert(dragon)
            }
        }
        return dragonsRequired
    }
    func parseBreedRequirements() -> (Set<PrimaryElement>, Set<EpicElement>, Set<String>) {
        return (primaryElementsRequired(), epicElementsRequired(), dragonsRequired())
    }
    
    func elementRequirementsSatisfied(_ dragon: Dragon) -> Int {
        let primaryElements = primaryElementsRequired()
        let epicElements = epicElementsRequired()
        var elementRequirementsSatisfied = 0
        primaryElements.forEach {
            if dragon.hasElement(.primary($0)) {
                elementRequirementsSatisfied += 1
            }
        }
        epicElements.forEach {
            if dragon.hasElement(.epic($0)) {
                elementRequirementsSatisfied += 1
            }
        }
        return elementRequirementsSatisfied
    }

    func insert(_ addedRequirements: Set<BreedRequirement>) -> BreedRequirements {
        return BreedRequirements(breedRequirements: breedRequirements + addedRequirements)
    }
    func remove(_ removedRequirements: Set<BreedRequirement>) -> BreedRequirements {
        return BreedRequirements(breedRequirements: breedRequirements - removedRequirements)
    }
    func isSuperset(of subsetRequirements: Set<BreedRequirement>) -> Bool {
        return breedRequirements.isSuperset(of: subsetRequirements)
    }
}
extension BreedRequirements : CustomStringConvertible {
    var description : String {
        var description : String = ""
        description = "["
        for requirementIndex in 0 ..< breedRequirements.count {
            description += "\(Array(breedRequirements)[requirementIndex])"
            if requirementIndex < breedRequirements.count - 1 {
                description += "+"
            }
        }
        return description + "]"
    }
}
