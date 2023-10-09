import Foundation
import FoundationNetworking

func main() {    
    let jsonManager = JSONManager.shared
    guard let dragonarium = jsonManager.initializeDragonarium(from: "./json/dragonarium.json") else {
    print("failed to load dragonarium")
    return
}
    let breedableDragons = dragonarium.dragons.filter {$0.isBreedable}
    print(breedableDragons.count)
    
    let breederDragons = dragonarium.dragons.filter {$0.isBreeder}
    print(breederDragons.count)
    
}
main()
