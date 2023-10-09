// Represents components for a breed
// - `elements`: Set of DragonElement that must be contained in the breed combination
// - `dragons`: Set of Dragon that must be contained in the breed combination
// - `specialRequirements`: SpecialBreedComponents that must be met in order for a dragon to be bred

struct BreedComponents: Equatable, Hashable {
    let elements : [DragonElement]
    let dragons: Set<DragonInstance>
    let specialRequirements : SpecialBreedComponents
    
    init(elements: [DragonElement], dragons: Set<DragonInstance>, specialRequirements: SpecialBreedComponents = SpecialBreedComponents()) {        
        self.elements = elements
        self.dragons = dragons
        self.specialRequirements = specialRequirements
    }    

    public static func + (lhs: BreedComponents, rhs: BreedComponents) -> BreedComponents? {
        // Combine required elements using custom Quasi-Set implementation        
        let combinedElements = lhs.elements + rhs.elements
        // Only return valid BreedComponentsn if there are no more than 2 dragons, otherwise return nil
        let combinedDragons = lhs.dragons + rhs.dragons
        if combinedDragons.count > 2 {
            return nil
        }
        // Only return valid BreedComponents if the SpecialRequirements are able to be combined, otherwise return nil
        if let combinedSpecialBreedComponents = lhs.specialRequirements + rhs.specialRequirements {
            return BreedComponents(elements: combinedElements, dragons: combinedDragons, specialRequirements: combinedSpecialBreedComponents)
        }
        return nil
    }

    func satisfies(breedRequirements: BreedComponents) -> Bool {
        return false
    }

    public static func == (lhs: BreedComponents, rhs: BreedComponents) -> Bool {
        return lhs.elements == rhs.elements &&
          lhs.dragons == rhs.dragons &&
          lhs.specialRequirements == rhs.specialRequirements
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(elements)
        hasher.combine(dragons)
        hasher.combine(specialRequirements)
    }
}

extension BreedComponents: Codable {
    private enum CodingKeys: String, CodingKey {
        case elements
        case dragons
        case specialRequirements = "special_requirements"
    }


    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if !elements.isEmpty {
            try container.encode(elements, forKey: .elements)
        }
        if !dragons.isEmpty {
            try container.encode(dragons, forKey: .dragons)
        }
        if !specialRequirements.isEmpty {
            try container.encode(specialRequirements, forKey: .specialRequirements)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        elements = try container.decodeIfPresent([DragonElement].self, forKey: .elements) ?? []
        dragons = try container.decodeIfPresent(Set<DragonInstance>.self, forKey: .dragons) ?? []
        specialRequirements = try container.decodeIfPresent(SpecialBreedComponents.self, forKey: .specialRequirements) ?? SpecialBreedComponents()
    }
}

    
