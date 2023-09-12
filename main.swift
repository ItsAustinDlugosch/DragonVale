import Foundation

func main() {
    let dragonarium = Dragonarium(filePath: "./csv/halloween.csv")    
    let halloweenDragons = dragonarium.dragons.filter { $0.limited == .available }
                                      

    if let ghostDragon = dragonarium.dragon("Ghost") {
        dragonarium.findOptimalCombination(targets: [ghostDragon], favorableResults: halloweenDragons, breedingCave: "rift")        
        }
             

    /*
    if let ignisDragon = dragonarium.dragon("Ignis"), let chimmitDragon = dragonarium.dragon("Chimmit"), let breed = simulateBreed(dragonOne: ignisDragon, dragonTwo: chimmitDragon, breedingCave: "rift") {
        for (name, float) in breed.resultPercentages() {
            if unownedDragonNames.contains(name) {
                print("\(name),\(float)")
            }
        }
        }
        
     */
}

func simulateBreed(dragonOne: Dragon? = nil, dragonTwo: Dragon? = nil, breedingCave: String) -> BreedSimulation? {
    let dragonarium = Dragonarium(filePath: "./csv/dragons.csv")
    
    if let dragonOne = dragonOne ?? dragonarium.dragons.randomElement(), let dragonTwo = dragonTwo ?? dragonarium.dragons.randomElement() {
        let breedInformation = BreedInformation(dragonOne, dragonTwo)
        let breedSimulation = BreedSimulation(dragonarium.dragons, breedInformation: breedInformation, breedingCave: "normal")
        print("Breeding the \(dragonOne.name) Dragon with the \(dragonTwo.name) Dragon in the \(breedingCave) cave")
        return breedSimulation
    }
    return nil
}

func readDragonsFromFile(filePath: String) -> Set<String> {
    let dragons : String
    do {
        dragons = try String(contentsOfFile: filePath)
    } catch {
        print("File read error: \(error)")
        fatalError()
    }
    return Set<String>(dragons.components(separatedBy: .newlines).filter { !$0.isEmpty })
}

func updateLimitedStatus(_ filePath: String = "./txt/currentLimiteds.txt") {
    let dragonarium = Dragonarium(filePath: "./csv/dragons.csv")
    let limitedDragonNames = readDragonsFromFile(filePath: filePath)
    
    for dragon in dragonarium.dragons {
        if limitedDragonNames.contains(dragon.name) {
            dragon.limited = .available
        } else if dragon.limited == .available {
            dragon.limited = .unavailable
        }
    }
    dragonarium.printDragonsAlphabetized()
}

main()
