extension String {
    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }

    func character(at position: Int) -> Character? {
        guard position >= 0, let indexPosition = index(at: position) else {
            return nil
        }
        return self[indexPosition]
    }

    func segment(from startIndex: Int, to endIndex: Int) -> String? {
        var stringSegement = ""
        for characterIndex in startIndex ... endIndex {
            if let character = self.character(at: characterIndex) {
                stringSegement.append(character)
            } else {
                return nil
            }
        }
        return stringSegement
    }

    func firstCharacter() -> Character? {
        if let firstCharacter = character(at: 0) {
            return firstCharacter
        }
        return nil
    }    

    func separate(at separator: Character) -> [String] {
        var strings = [String]()
        var string = ""
        for character in self {
            if character != separator {
                string.append(character)
            } else {
                strings.append(string)
                string = ""                
            }
        }
        strings.append(string)
        return strings
    }
}
