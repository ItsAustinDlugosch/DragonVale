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

    func combineRequirements(other: BreedComponents) -> BreedComponents? {
        // Combine required elements using custom Quasi-Set implementation        
        let combinedElements = self.elements + other.elements
        // Only return valid BreedComponentsn if there are no more than 2 dragons, otherwise return nil
        let combinedDragons = self.dragons + other.dragons
        if combinedDragons.count > 2 {
            return nil
        }
        // Only return valid BreedComponents if the SpecialRequirements are able to be combined, otherwise return nil
        if let combinedSpecialBreedComponents = self.specialRequirements + other.specialRequirements {
            return BreedComponents(elements: combinedElements, dragons: combinedDragons, specialRequirements: combinedSpecialBreedComponents)
        }
        return nil
    }

    func satisfies(other: BreedComponents) -> Bool {
        // Check that all elements from other are included in elements
        for element in other.elements {
            if self.elements.filter({ $0 == element }).count < other.elements.filter({ $0 == element }).count {
                return false
            }
        }

        // Check that all dragons from other are included in dragons
        for dragonInstance in other.dragons {
            // If the dragonInstance in other has a specific rift trait
            if let requiredRiftTrait = dragonInstance.riftTrait {
                // Check if there's a matching dragonInstance in the current BreedComponents with the same rift trait
                if !self.dragons.contains(where: { $0.dragonName == dragonInstance.dragonName && $0.riftTrait == requiredRiftTrait }) {
                    return false
                }
            } else {
                // Any rift trait (or none) is acceptable
                if !self.dragons.contains(where: { $0.dragonName == dragonInstance.dragonName }) {
                    return false
                }
            }
        }

        // Check that all specialRequirements from other are included in specialRequirements
        if !self.specialRequirements.satisfies(other: other.specialRequirements) {
            return false
        }

        return true
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

    
