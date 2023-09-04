enum BreedRequirement {
    case dragon(String)
    case dragonElement(DragonElement)
    case specialRequirement(String)
    case unbreedable

    init?(_ value: String) {
        if value == "" {
            self = .unbreedable            
        } else {
            let firstCharacter = value.firstCharacter()
            if firstCharacter!.isUppercase {
                self = .dragon(value)
            } else if firstCharacter! == "[" {
                self = .specialRequirement(value.segment(from: 1, to: value.count - 2) ?? "")
            } else if let dragonElement = DragonElement(value) {
                self = .dragonElement(dragonElement)
            } else {
                print("Failed to create breeding requirement from '\(value)'")
                return nil
            }
        }
    }
}
