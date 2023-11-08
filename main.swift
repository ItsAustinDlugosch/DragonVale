import Foundation
import FoundationNetworking

func main() {    
    
    let jsonManager = JSONManager.shared
    guard let dragonarium = jsonManager.initializeDragonarium(from: "./json/dragonarium.json") else {
    print("failed to load dragonarium")
    return
}
    BreedSimulator.initialize(with: dragonarium)
    guard let breedSimulator = BreedSimulator.shared else {
    print("Breedsimulator must be initialized prior to accessing it.")
    return
}
    breedSimulator.updateCave(to: .normal)
    breedSimulator.updateTimeOfDay(to: .night)

    if let dragonOne = dragonarium.breedableDragon("Whirlwind"),
       let dragonTwo = dragonarium.breedableDragon("Khamsin") {
        var breedSimulation = breedSimulator.simulateBreed(DragonInstance(dragonOne.name)!, DragonInstance(dragonTwo.name)!)

        for (key, value) in breedSimulation.breedResults {
            print(key.name, value)
        }
    }

    
    
}
main()
