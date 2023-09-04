import Foundation

func main() {
    let dragonarium = Dragonarium(filePath: "./dragons.txt")
    let hiddenDragons = dragonarium.dragons.filter { $0.hasElement(.epic(.hidden)) }
    for dragon in hiddenDragons {
        print(dragon)
    }
    print("\(hiddenDragons.count) Hidden Dragons printed")
}

main()
