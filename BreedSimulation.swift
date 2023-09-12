class BreedSimulation {
    let dragons : Set<Dragon>
    let resultDragons : Set<Dragon>    
    let breedResults : Set<Dragon>
    let cloneResults : Set<Dragon>
    
    let breedingCave : String
    let breedInformation : BreedInformation

    var resultPercentages : [String : Float] {
        return produceResultPercentages()
    }

    init(_ dragons: Set<Dragon>, breedInformation: BreedInformation, breedingCave: String) {
        self.dragons = dragons
        self.breedInformation = breedInformation
        self.breedingCave = breedingCave
        let breedResults = dragons.filter { $0.isBreedResult(breedInformation) }
        self.breedResults = breedResults
        let cloneResults = Set<Dragon>([breedInformation.dragonOne, breedInformation.dragonTwo])
        self.cloneResults = cloneResults
        let allResults = cloneResults + breedResults
        self.resultDragons = allResults                
    }           

    func produceResultPercentages() -> [String : Float] {
        var resultPercentages = [String : Float]()
        let hybridResults = breedResults.filter { $0.breedPercentage == .hybrid }

        let breedMappingFunction : (Dragon) -> BreedPercentage = { dragon in
            return dragon.breedPercentage }
        let cloneMappingFunction : (Dragon) -> BreedPercentage = { dragon in
            switch self.breedingCave {
            case "social": return dragon.cloneSocialPercentage
            case "normal": return dragon.cloneNormalPercentage
            case "rift": return dragon.cloneRiftPercentage
            default:
                print("Unexpected Breeding Cave \(self.breedingCave)")
                fatalError()
            }
        }
            
        var compositeFixedPercentage : Float = 0
        var fixedMultiplier : Float = 1
        var hybridPercentage : Float
        
        let breedResultsDictionary = Dictionary<Dragon, BreedPercentage>(keys: breedResults, mapping: breedMappingFunction)
        let cloneResultsPercentages = Dictionary<Dragon, BreedPercentage>(keys: cloneResults, mapping: cloneMappingFunction)                
        for result in resultDragons {
            var fixedPercentage : Float = 0
            if let breedPercentage = breedResultsDictionary[result] {                
                if case let .fixed(percentage) = breedPercentage {
                    fixedPercentage += percentage
                }
            }
            if let clonePercentage = cloneResultsPercentages[result] {
                if case let .fixed(percentage) = clonePercentage {
                    fixedPercentage += percentage
                }
            }
            compositeFixedPercentage += fixedPercentage
            resultPercentages[result.name] = fixedPercentage
        }

        if compositeFixedPercentage > 99.0 {
            fixedMultiplier = 99.0 / compositeFixedPercentage
            hybridPercentage = 1.0 / Float(hybridResults.count)
        } else {
            hybridPercentage = (100.0 - compositeFixedPercentage) / Float(hybridResults.count)
        }            

        for (dragonName, breedPercentage) in resultPercentages {
            if breedPercentage == 0 {
                resultPercentages[dragonName] = hybridPercentage
            } else {
                resultPercentages[dragonName] = breedPercentage * fixedMultiplier
            }
        }
        return resultPercentages
    }

    func compositePercentage(_ favorableResults: Set<Dragon>) -> (Float, Set<Dragon>) {
        let favorableResultDragons = resultDragons.filter { favorableResults.contains($0) }
        let resultPercentages = self.resultPercentages
        var favorableResults = Set<Dragon>()
        var compositePercentage : Float = 0
        favorableResultDragons.forEach {
            if let favorablePercentage = resultPercentages[$0.name] {
                favorableResults.insert($0)
                compositePercentage += favorablePercentage
            }
        }
        return (compositePercentage, favorableResults)
    }
}

extension BreedSimulation : Equatable {
    static func ==(lhs: BreedSimulation, rhs: BreedSimulation) -> Bool {
        return lhs.breedingCave == rhs.breedingCave && lhs.breedInformation == rhs.breedInformation
    }
}
extension BreedSimulation : Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(breedingCave)
        hasher.combine(breedInformation)
    }
}
