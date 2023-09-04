class Dragon {
    let name : String
    let rarity : Rarity
    let elements : Set<DragonElement>
    let breedInformation : BreedInformation
    let quest : String

    init?(name: String, rarity: Rarity, elements: Set<DragonElement>, breedInformation: BreedInformation, quest: String) {
        self.name = name
        self.rarity = rarity
        self.elements = elements
        self.breedInformation = breedInformation
        self.quest = quest
    }

    convenience init?(fields: [String]) {        
        guard fields.count == 10 else {
        print("Unexpected field length when processing \(fields) of count \(fields.count).")
        return nil
    }
        var dragonElements : Set<DragonElement> {
            var dragonElements = Set<DragonElement>()
            var elementTag = ""
            for c in fields[2] {
                elementTag.append(c)
                if c.isUppercase, let dragonElement = DragonElement(elementTag) {
                    dragonElements.insert(dragonElement)
                    elementTag = ""
                }
            }
            if let lastElement = DragonElement(elementTag) {
                dragonElements.insert(lastElement)
            }
            return dragonElements
        }
        if let rarity = Rarity(fields[1]),
           let breedInformation = BreedInformation(fields: [String](fields[3...8])) {
            self.init(name: fields[0], rarity: rarity, elements: dragonElements, breedInformation: breedInformation, quest: fields[9])
        } else {
            return nil
        }
    }    

    convenience init?(line: String) {
        let fields = line.components(separatedBy: ",")
        self.init(fields: fields)
    }

    func hasElement(_ dragonElement: DragonElement) -> Bool {
        return elements.contains(dragonElement)
    }
}

extension Dragon : CustomStringConvertible {
    var description : String {
        var description = name + " Dragon -"
        description += " \(rarity)"
        description += " \(elements)"
        description += " \(breedInformation.breedTime)"
        description += " \(breedInformation.breedPercentage)"
        description += " \(breedInformation.cloneSocialPercentage)"
        description += " \(breedInformation.cloneNormalPercentage)"
        description += " \(breedInformation.cloneRiftPercentage)"
        return description + " \(quest)"
    }
}
