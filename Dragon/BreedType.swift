enum BreedType: CustomStringConvertible {
    case fixed
    case fluctuating
    case fixedAndFluctuating
    case clone
    case doubleClone

    private static let breedTypeMap : [String: BreedType] = [
      "fixed": .fixed,
      "fluctuating": .fluctuating,
      "fixedAndFluctuating": .fixedAndFluctuating,
      "clone": .clone,
      "doubleClone": .doubleClone
    ]

    init?(_ value: String) {
        guard let breedType = BreedType.breedTypeMap[value] else {
        return nil
    }
        self = breedType
    }

    var description: String {
        return BreedType.breedTypeMap.first { $0.value == self}?.key ?? ""
    }
}
extension BreedType: Codable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.description)
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)

        // Use the breedTypeMap to get the corresponding enum value
        if let breedType = BreedType.breedTypeMap[stringValue] {
            self = breedType
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid breed type value: \(stringValue)")
        }
    }
}
