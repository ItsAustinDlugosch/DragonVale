// Represents the limited availability of something.
// - available: Currently available.
// - unavailable: Currently not available.
// - permanent: Always available.
// - unbreedable: Always unavailable

enum BreedAvailability {
    case available
    case unavailable
    case permanent
    case cloneable

    // Dictionary that maps a string to a BreedAvailability
    private static let breedAvailabilityMap : [String: BreedAvailability] = [
      "avilable": .available,
      "unavailable": .unavailable,
      "permanent": .permanent,
      "cloneable": .cloneable
    ]
   
    
    init?(_ value: String) {
        guard let breedAvailabilty = BreedAvailability.breedAvailabilityMap[value] else {
        return nil
    }
        self = breedAvailabilty
    }
}

extension BreedAvailability: CustomStringConvertible {
    var description: String {
        return BreedAvailability.breedAvailabilityMap.first { $0.value == self }?.key ?? ""
    }
}

extension BreedAvailability : Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.description)
    }
}

extension BreedAvailability : Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        
        // Use the breedAvailabilityMap to get the corresponding enum value
        if let breedAvailability = BreedAvailability.breedAvailabilityMap[stringValue] {
            self = breedAvailability
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid breed availability value: \(stringValue)")
        }
    }
}
