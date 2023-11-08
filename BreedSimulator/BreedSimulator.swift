class BreedSimulator {
    static var shared: BreedSimulator? = nil

    let dragonarium: Dragonarium

    public var timeOfDay: CaveTime = .day
    public var weather: CaveWeather = .sunny
    public var cave: Cave = .normal
    public var alignment: PrimaryElement? = nil

    private init(dragonarium: Dragonarium) {
        self.dragonarium = dragonarium
    }

    static func initialize(with dragonarium: Dragonarium) {
        shared = BreedSimulator(dragonarium: dragonarium)
    }

    func updateTimeOfDay(to caveTime: CaveTime) {
        self.timeOfDay = caveTime
    }
    func updateWeather(to weather: CaveWeather) {
        self.weather = weather
    }
    func updateCave(to cave: Cave) {
        self.cave = cave
    }
    func updateAlignment(to alignment:PrimaryElement) {
        guard self.cave == .rift else {
        print("Cave must be .rift to change alignment")
        return
    }
        self.alignment = alignment
    }
    
    func combineBreedComponents(_ dragonOneInstance: DragonInstance, _ dragonTwoInstance: DragonInstance) -> BreedComponents {
        guard let dragonOne = dragonarium.breedableDragon(dragonOneInstance.dragonName) else {
        print("Could not find dragonName of \(dragonOneInstance.dragonName) in dragonarium.")
        fatalError()
    }
        guard let dragonTwo = dragonarium.breedableDragon(dragonTwoInstance.dragonName) else {
        print("Could not find dragonName of \(dragonTwoInstance.dragonName) in dragonarium.")
        fatalError()
    }
        // Combine elements as Arrays to handle requirements that require more than one instance of an element
        var combinedElements = Array(dragonOne.breedInformation.elements) + Array(dragonTwo.breedInformation.elements)
        // If the cave is rift, add two rift instances to the combinedElements
        if cave == .rift {
            combinedElements += [.epic(.rift), .epic(.rift)]
        }

        // Used in calculating the elementCount and for seeing if the combination contains opposites exclusively
        let combinedUniqueElements = dragonOne.breedInformation.elements + dragonTwo.breedInformation.elements

        // Combine Dragons
        let combinedDragons = Set<DragonInstance>([dragonOneInstance, dragonTwoInstance])

        // Combine riftTraits included in the breed if they exist
        var riftTraits: Set<PrimaryElement>?  {
            let riftTraits = combinedDragons.compactMap {$0.riftTrait}
            return !riftTraits.isEmpty ? Set<PrimaryElement>(riftTraits) : nil
        }
        // Define the oppositeElements if the unique primary elements are exclusively opposites
        var oppositeElements: Set<PrimaryElement>? {
            let combinedPrimaryElements = Array(combinedUniqueElements.compactMap {
                                                    if case .primary(let primaryElement) = $0 {
                                                        return primaryElement
                                                    } else {
                                                        return nil }
                                                })            
            guard combinedPrimaryElements.count == 2 else {
            return nil
        }
            return PrimaryElement.oppositeElementMap[combinedPrimaryElements[0]] == combinedPrimaryElements[1]
              ? Set<PrimaryElement>([combinedPrimaryElements[0], combinedPrimaryElements[1]])
              : nil
        }
        // Count of unique elements
        let elementCount = combinedUniqueElements.count
        let combinedSpecialRequirements = SpecialBreedComponents(riftAlignment: alignment,
                                                                 riftTraits: riftTraits,                                                      
                                                                 minElementCount: elementCount,
                                                                 time: timeOfDay,
                                                                 weather: weather,
                                                                 cave: cave)
        return BreedComponents(elements: combinedElements,
                               dragons: combinedDragons,
                               specialRequirements: combinedSpecialRequirements)

    }

    func simulateBreed(_ dragonOneInstance: DragonInstance, _ dragonTwoInstance: DragonInstance) -> BreedSimulation {        
        return BreedSimulation(breedComponents: combineBreedComponents(dragonOneInstance, dragonTwoInstance))
    }

    func possibleCombinations(targetDragon: BreedableDragon, baseFavorableResults: Set<BreedableDragon>) -> BreedSimulation {
        var targetSimulation = BreedSimulation(breedComponents: targetDragon.breedInformation.breedRequirements)
        var optimalSimulation = targetSimulation
        findOptimal(targetSimulation: targetSimulation, favorableResults: baseFavorableResults)
        func findOptimal(targetSimulation: BreedSimulation, favorableResults: Set<BreedableDragon>) {
            print("finding optimal, \(favorableResults.count)")
            var targetSimulation = targetSimulation
            var favorableResults = favorableResults.filter { $0.breedInformation.breedRequirements.dragons.count <= (2 - targetSimulation.breedComponents.dragons.count) }            
            guard favorableResults.count != 0 else {
            return
        }            
            for favorableResult in favorableResults {
                favorableResults.remove(favorableResult)
                if let combinedBreedRequirements = targetSimulation.breedComponents.combineRequirements(other: favorableResult.breedInformation.breedRequirements) {
                    var combinedBreedSimulation = BreedSimulation(breedComponents: combinedBreedRequirements)
                    if targetSimulation.compositePercentage(favorableResults: baseFavorableResults) < combinedBreedSimulation.compositePercentage(favorableResults: baseFavorableResults) {
                        optimalSimulation = combinedBreedSimulation
                        findOptimal(targetSimulation: optimalSimulation, favorableResults: favorableResults)
                    }
                }            
            }
        }
        return optimalSimulation
    }
}
