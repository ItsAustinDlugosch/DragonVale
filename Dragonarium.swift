class Dragonarium {
    var dragons: Set<Dragon>
    let compendium : [DragonElement : Set<Dragon>]

    init(dragons: Set<Dragon>) {
        self.dragons = dragons
        var compendium : [DragonElement : Set<Dragon>] {
            var compendium = [DragonElement: Set<Dragon>]()
            for element in DragonElement.allCases {
                compendium[element] = dragons.filter { $0.elements.contains(element) }
            }
            return compendium
        }
        self.compendium = compendium
    }

    convenience init(lines: [String]) {
        var verifiedDragons = Set<Dragon>()
        for i in 0 ..< lines.count {
            if let dragon = Dragon(line: lines[i]) {
                verifiedDragons.insert(dragon)
            } else {
                print("Failed to initialize Dragon from \(lines[i]) on line \(i + 1)")
            }
        }
        self.init(dragons: verifiedDragons)
    }

    convenience init(filePath: String) {
        let contents : String
        do {        
            contents = try String(contentsOfFile: filePath)            
        } catch {
            print("File read error: \(error)")
            fatalError()
        }
        let lines = contents.components(separatedBy: .newlines).filter { !$0.isEmpty }        
        self.init(lines: lines)
    }

    func dragonsAlphabetized(_ dragonSet: Set<Dragon>? = nil) -> [Dragon] {
        let dragonSet = dragonSet ?? dragons
        let dragonsAlphabetized = Array(dragonSet).sorted()
        return dragonsAlphabetized
    }

    func printDragonsAlphabetized(_ dragonSet: Set<Dragon>? = nil) {
        for dragon in dragonsAlphabetized(dragonSet) {
            print(dragon)
        }
    }

    func dragon(_ dragonName: String) -> Dragon? {
        if let dragon = Array(dragons).first(where: { $0.hasName(dragonName) }) {
            return dragon
        }
        print("Failed to load dragon of name '\(dragonName)'")
        return nil        
    }

    func printDragonsByElement(_ element: DragonElement) {
        print(element)
        printDragonsAlphabetized(compendium[element])
        print()
        
    }

    func printDragonsByElements() {        
        for element in DragonElement.allCases.sorted() {
           printDragonsByElement(element) 
        }
    }

    func highestCompositeSimulations(simulations: Set<BreedSimulation>, favorableResults: Set<Dragon>) -> Set<BreedSimulation> {
        var highestCompositePercentage : Float = 0
        var simulationToCompositePercentage = [BreedSimulation : Float]()
        var highestCompositeSimulations = Set<BreedSimulation>()
        for simulation in simulations {
            let compositePercentage = simulation.compositePercentage(favorableResults).0
            simulationToCompositePercentage[simulation] = compositePercentage
            if compositePercentage > highestCompositePercentage {
                highestCompositePercentage = compositePercentage
            }
        }
        simulations.forEach {
            if simulationToCompositePercentage[$0] == highestCompositePercentage {
                highestCompositeSimulations.insert($0)
            }
        }
        return highestCompositeSimulations
    }

    // func 1 -> BreedSimulation {
    // Given a set of favorable results and a set of target
    // func 2 -> BreedSimulation {
    // Check that a combination exists that satisfies all targets
    // Add a dragon to targets with minimal impact on the breedRequirements
    // Recursively call func 2 with the added target
    // Return the combination that satisfies all targets with the highest composite chance to get a target
    // }
    // compare all composite chances

    func findOptimalCombination(targets: Set<Dragon>, favorableResults: Set<Dragon>, breedingCave: String) {
        var breedRequirements = BreedRequirements(dragons: targets)
        var solutions = [BreedSimulation : (Float, Set<Dragon>)]()
        print(breedRequirements)               
        
        func satisfiesMostElementRequirements(breedRequirements: BreedRequirements) -> Set<Dragon> {
            var maxElementRequirementsSatisfied = 0
            var dragonToElementsSatisfied = [Dragon : Int]()
            for dragon in dragons.filter({ $0.primaryElements().count != 10 && !favorableResults.contains($0) && $0.rarity != .gemstone}) {
                let elementsSatisfied = breedRequirements.elementRequirementsSatisfied(dragon)
                if elementsSatisfied > maxElementRequirementsSatisfied {
                    maxElementRequirementsSatisfied = elementsSatisfied
                }
                dragonToElementsSatisfied[dragon] = elementsSatisfied
            }
            var dragonCandidates = Set<Dragon>()
            for (dragon, elementsSatisfied) in dragonToElementsSatisfied {
                if elementsSatisfied == maxElementRequirementsSatisfied {
                    dragonCandidates.insert(dragon)
                }
            }
            return dragonCandidates
        }

        func similarRequirement(breedRequirements: BreedRequirements, favorableResults: Set<Dragon>) -> Dragon {
            let favorableResults = favorableResults
            var mostSimilar : Dragon? = nil
            var mostSimilarWithoutRequiredDragons : Dragon? = nil
            var leastDifferences : Int? = nil
            precondition(favorableResults.count > 0, "There must be favorable results to find a similar requirement.")
            for dragon in favorableResults {
                let differentRequirements = dragon.breedRequirements - breedRequirements.breedRequirements
                let differences = differentRequirements.count
                if differences == 0 {
                    return dragon
                }
                if leastDifferences == nil {
                    leastDifferences = differences
                    mostSimilar = dragon
                } else {
                    if differences < leastDifferences! {
                        leastDifferences = differences
                        mostSimilar = dragon
                        if BreedRequirements(breedRequirements: differentRequirements).dragons.count == 0 {
                            mostSimilarWithoutRequiredDragons = dragon
                        }
                    }                    
                }
            }
            return mostSimilarWithoutRequiredDragons ?? mostSimilar!
        }


        let dragonsRequired = breedRequirements.dragons
        let dragonCount = dragonsRequired.count
        // Evaluate Optimal Combination Functions
        func evaluateZeroRequiredDragons() {
            var favorableResults = favorableResults
            while breedRequirements.primaryElementsRequired().count < 6 && breedRequirements.dragonsRequired().count == 0 {
                let mostSimilarRequirementDragon = similarRequirement(breedRequirements: breedRequirements, favorableResults: favorableResults)
                favorableResults.remove(mostSimilarRequirementDragon)
                breedRequirements = breedRequirements.insert(mostSimilarRequirementDragon.breedRequirements)
                print("Inserted \(mostSimilarRequirementDragon) to have updated breed requirements of \(breedRequirements)")                
            }
            let dragonsRequired = breedRequirements.dragons
            let dragonCount = dragonsRequired.count
            print("After insertion, have \(dragonCount) dragons required")
            if dragonCount == 1 {
                var dragonsRequiredArray = Array(dragonsRequired)
                evaluateOneRequiredDragon(dragonsRequiredArray.removeFirst())
            }
            if dragonCount == 2 {
                var dragonsRequiredArray = Array(dragonsRequired)
                evaluateTwoRequiredDragons(dragonsRequiredArray.removeFirst(), dragonsRequiredArray.removeFirst())
            }
            let dragonCandidates = satisfiesMostElementRequirements(breedRequirements: breedRequirements)
            for dragon in dragonCandidates {
                evaluateOneRequiredDragon(dragon.name)
            }
        }
        func insertBreedSimulationIntoSolutions(_ breedSimulation: BreedSimulation) {
            if !solutions.keys.contains(breedSimulation) {
                solutions[breedSimulation] = breedSimulation.compositePercentage(favorableResults)
            }
        }        
        func evaluateOneRequiredDragon(_ dragonOne: String) {
            if let dragonOne = dragon(dragonOne) {
                let reducedRequirements = breedRequirements.remove(dragonOne.breedComponents())
                print("reducedRequirements are \(reducedRequirements)")
                let dragonCandidates = satisfiesMostElementRequirements(breedRequirements: reducedRequirements)
                var simulations = Set<BreedSimulation>()
                for dragonTwo in dragonCandidates {
                    let breedInformation = BreedInformation(dragonOne, dragonTwo)
                    if breedRequirements.satisfiesRequirements(breedInformation.breedComponents) {
                        insertBreedSimulationIntoSolutions(BreedSimulation(dragons, breedInformation: breedInformation, breedingCave: breedingCave))
                    }                                                            
                }            
            } else {
                print("Failed to initialize dragon from \(dragonsRequired)")
            }
        }
        func evaluateTwoRequiredDragons(_ dragonOne: String, _ dragonTwo: String) {
            if let dragonOne = dragon(dragonOne),
               let dragonTwo = dragon(dragonTwo) {
                let breedInformation = BreedInformation(dragonOne, dragonTwo)
                if breedRequirements.satisfiesRequirements(breedInformation.breedComponents) {
                    insertBreedSimulationIntoSolutions(BreedSimulation(dragons, breedInformation: breedInformation, breedingCave: breedingCave))
                } else {
                    print("Found invalid combination of dragons from \(dragonOne),\(dragonTwo)")
                }
            } else {
                print("Failed to initialize dragon from \(dragonsRequired)")
            }
        }

        print(dragonsRequired, dragonCount)
        if dragonCount == 0 {
           evaluateZeroRequiredDragons() 
        }
        if dragonCount == 1 {
            var dragonsRequiredArray = Array(dragonsRequired)
            evaluateOneRequiredDragon(dragonsRequiredArray.removeFirst())                
        }
        if dragonCount == 2 {
            var dragonsRequiredArray = Array(dragonsRequired)
            evaluateTwoRequiredDragons(dragonsRequiredArray.removeFirst(), dragonsRequiredArray.removeFirst())                
        }
        if dragonCount > 2 {
            print("Found unexpected number of \(dragonCount) dragons required in the breeding combination.")
        }

        func printSimulation(_ simulation: BreedSimulation) {
                let breedInformation = simulation.breedInformation
                let dragonOne = breedInformation.dragonOne.name
                let dragonTwo = breedInformation.dragonTwo.name
                let (compositePercentage, favorableResults) = simulation.compositePercentage(favorableResults)
                print("\(dragonOne),\(dragonTwo) -> \(compositePercentage),\(favorableResults.map { $0.name })")            
        }

        var simulationArray = [(BreedSimulation, (Float, Set<Dragon>))]()
        for (simulation, compositePercentage) in solutions {
            simulationArray.append((simulation, compositePercentage))
        }
        simulationArray.sort {
            return $0.1.0 < $1.1.0
        }
        simulationArray.forEach { printSimulation($0.0) }
    }  
    
}

    /*
    func findOptimalCombination(targets: Set<Dragon>, possibleTargets: Set<Dragon>) /*-> (BreedSimulation, Float) */ {
        func breedTest(dragonOne: Dragon, dragonTwo: Dragon, breedRequirements: Set<BreedRequirement>, targets: Set<Dragon>) -> Bool {
            let breedSimulationResults = BreedSimulation(dragons, breedInformation: BreedInformation(dragonOne, dragonTwo), breedingCave: "normal").resultDragons
            return breedSimulationResults.contains(targets)
        }

        func parsedBreedRequirements(_ breedRequirements: Set<BreedRequirement>) -> (Set<PrimaryElement>, Set<EpicElement>, Set<Dragon>) {
            var primaryElements = Set<PrimaryElement>()
            var epicElements = Set<EpicElement>()
            var dragons = Set<Dragon>()
            for requirement in breedRequirements {
                if case let .dragonElement(dragonElement) = requirement {
                    if case let .primary(element) = dragonElement {
                        primaryElements.insert(element)
                    }
                    if case let .epic(element) = dragonElement {
                        epicElements.insert(element)
                    }
                }
                if case let .dragon(dragonName) = requirement, let dragon = dragon(dragonName) {
                    dragons.insert(dragon)
                    for element in dragon.elements {
                        if case let .primary(primaryElement) = element {
                           primaryElements.insert(primaryElement)
                        }
                    }
                }
            }
            return (primaryElements, epicElements, dragons)
        }
        
        func isAcceptableBreedRequirement(breedRequirements: Set<BreedRequirement>, additionalTarget: Dragon) -> Bool {
            let compositeBreedRequirements = breedRequirements + additionalTarget.breedRequirements
            let (primaryElementsRequired, epicElementsRequired, dragonsRequired) = parsedBreedRequirements(compositeBreedRequirements)
            if primaryElementsRequired.count > 5 || epicElementsRequired.count > 2 || dragonsRequired.count > 2 {
                return false
            }
            if dragonsRequired.count == 1 {
                let dragon = Array(dragonsRequired)[0]
                return dragons.filter { $0.satisfiesBreedRequirements(breedRequirements - dragon.breedComponents())}.count > 0
            }
            if dragonsRequired.count == 2 {                
                return breedTest(dragonOne: Array(dragonsRequired)[0], dragonTwo: Array(dragonsRequired)[1], breedRequirements: breedRequirements, targets: targets)
            }            
            return true
        }

        func satisfiesMostRequirements(_ dragons: Set<Dragon>, _ breedingRequirements: Set<BreedRequirement>, _ subtract: Int = 0) -> (Set<Dragon>, Int) {
            var maxRequirementsSatisfied = 0
            var dragonsToRequirementsSatisfied = [Dragon : Int]()
            for dragon in dragons.filter( { $0.elements.count < 6 }) {
                var requirementsSatisfied = 0
                for breedRequirement in breedRequirements {
                    if dragon.satisfiesBreedRequirement(breedRequirement) {
                        requirementsSatisfied += 1
                    }                    
                }
                if maxRequirementsSatisfied < requirementsSatisfied {
                    maxRequirementsSatisfied = requirementsSatisfied
                }
                dragonsToRequirementsSatisfied[dragon] = requirementsSatisfied
            }

            var satisfiesMostRequirements = Set<Dragon>()
            for (dragon, requirementsSatisfied) in dragonsToRequirementsSatisfied {
                if requirementsSatisfied >= maxRequirementsSatisfied - subtract {
                    satisfiesMostRequirements.insert(dragon)
                }
            }
            return (satisfiesMostRequirements, maxRequirementsSatisfied - subtract)
        }

        var possibleTargets = possibleTargets
        var targets : Set<Dragon> = targets
        var breedRequirements = Set<BreedRequirement>()
        for target in targets {
            for requirement in target.breedRequirements {
                breedRequirements.insert(requirement)
            }
        }
        for possibleTarget in possibleTargets {
            possibleTargets.remove(possibleTarget)            
            if isAcceptableBreedRequirement(breedRequirements: breedRequirements + possibleTarget.breedRequirements, additionalTarget: possibleTarget) {
                breedRequirements = breedRequirements + possibleTarget.breedRequirements
                targets.insert(possibleTarget)
            }
        }
        let (dragonCandidates, requirementsSatisfiedCount) = satisfiesMostRequirements(dragons, breedRequirements, 0)
        let targetDragonNames = targets.map { $0.name }
        for candidate in dragonCandidates {
            let reducedBreedComponents = breedRequirements - candidate.breedComponents() - [.dragonElement(.epic(.rift)), .specialRequirement("light trait"), .specialRequirement("dark trait")]            
            print("Searching for partner for \(candidate) that satisfies \(reducedBreedComponents)")            
            var possiblePairs = dragons.filter {$0.satisfiesBreedRequirements(reducedBreedComponents)}
            for pair in possiblePairs {
                let breedSimulation = BreedSimulation(dragons, breedInformation: BreedInformation(candidate, pair), breedingCave: "rift")
                let resultPercentages = breedSimulation.resultPercentages()
                var compositeChance : Float = 0
                for (result, chance) in resultPercentages {
                    if targetDragonNames.contains(result) {
                        compositeChance += chance
                    }
                }
                print("\(candidate.name),\(pair.name) -> \(compositeChance)")
            }
        }
        print(targetDragonNames)
        /*
        if let shadowflashDragon = dragon("Shadowflash") {
            print("reduced requirements: \(breedRequirements - shadowflashDragon.breedComponents())")
            var possiblePairs = dragons.filter { $0.satisfiesBreedRequirements((breedRequirements - shadowflashDragon.breedComponents()) - [.dragonElement(.epic(.rift))]) }
            possiblePairs.filter { $0.elements.count > 6 }
            possiblePairs.forEach { print($0) }
            }
            
         */
         }
         
     */
extension Dragonarium : Equatable {
    static func ==(lhs: Dragonarium, rhs: Dragonarium) -> Bool {
        let lhsAlphabetized = lhs.dragonsAlphabetized()
        let rhsAlphabetized = rhs.dragonsAlphabetized()
        precondition(lhsAlphabetized.count == rhsAlphabetized.count)
        for dragonIndex in 0 ..< lhsAlphabetized.count {
            if lhsAlphabetized[dragonIndex] != rhsAlphabetized[dragonIndex] {
                return false
            }
        }
        return true
    }
}
extension Dragonarium : Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(dragons)
        hasher.combine(compendium)
    }
}
