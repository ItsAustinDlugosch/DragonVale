import Foundation
import FoundationNetworking

func main() {        
    let jsonManager = JSONManager.shared
    guard let dragonarium = jsonManager.initializeDragonarium(from: "./json/dragonarium.json") else {
    print("failed to load dragonarium")
    return
}
    BreedSimulator.initialize(with: dragonarium)
    if let plantInstance = DragonInstance("Plant"),
       let fireInstance = DragonInstance("Fire"),
       let plantDragon = dragonarium.breedableDragon("Plant") {
        let breedComponents = BreedComponents(elements: [.primary(.fire), .primary(.plant)],
                                              dragons: [plantInstance,
                                                        fireInstance])   
        let breedSimulation = BreedSimulation(breedComponents: breedComponents)
        let dragonResults = breedSimulation.dragonsSatisfied()
        for result in dragonResults {
            print(result.name, result.breedInformation.breedRequirements)
        }
    }
    
}
main()
