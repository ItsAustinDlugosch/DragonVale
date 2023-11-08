// Represents the information pertaining to breeding for a dragon
struct BreedInformation: Equatable, Hashable {
    let breedAvailability: BreedAvailability
    let breedType: BreedType
    let breedRequirements: BreedComponents
    let breedTime: Time
    let elements: Set<DragonElement>
    let ownZeroBreedPercentage: Float?
    let ownOneBreedPercentage: Float?
    let ownTwoBreedPercentage: Float?
    let normalSingleClonePercentage: Float
    let normalDoubleClonePercentage: Float
    let socialSingleClonePercentage: Float
    let socialDoubleClonePercentage: Float
    let riftSingleClonePercentage: Float
    let riftDoubleClonePercentage: Float

    init(breedAvailability: BreedAvailability, breedType: BreedType,
         breedRequirements: BreedComponents, breedTime: Time, elements: Set<DragonElement>,
         ownZeroBreedPercentage: Float? = nil, ownOneBreedPercentage: Float? = nil, ownTwoBreedPercentage: Float? = nil,
         normalSingleClonePercentage: Float, normalDoubleClonePercentage: Float,
         socialSingleClonePercentage: Float, socialDoubleClonePercentage: Float,
         riftSingleClonePercentage: Float, riftDoubleClonePercentage: Float) {
        self.breedAvailability = breedAvailability
        self.breedType = breedType
        self.breedRequirements = breedRequirements
        self.breedTime = breedTime
        self.elements = elements
        self.ownZeroBreedPercentage = ownZeroBreedPercentage
        self.ownOneBreedPercentage = ownOneBreedPercentage
        self.ownTwoBreedPercentage = ownTwoBreedPercentage
        self.normalSingleClonePercentage = normalSingleClonePercentage
        self.normalDoubleClonePercentage = normalDoubleClonePercentage
        self.socialSingleClonePercentage = socialSingleClonePercentage
        self.socialDoubleClonePercentage = socialDoubleClonePercentage
        self.riftSingleClonePercentage = riftSingleClonePercentage
        self.riftDoubleClonePercentage = riftDoubleClonePercentage
    }

    func isSatisfiedBy(breedComponents: BreedComponents) -> Bool {
        return breedComponents.satisfies(other: breedRequirements)
    }

    func isFixed() -> Bool {
        return breedType == .fixed || breedType == .fixedAndFluctuating
    }
    func isFluctuating() -> Bool {
        return breedType == .fluctuating || breedType == .fixedAndFluctuating
    }
    func isClone() -> Bool {
        return breedType == .clone
    }
    func isDoubleClone() -> Bool {
        return breedType == .doubleClone
    }

    public static func == (lhs: BreedInformation, rhs: BreedInformation) -> Bool {
        return lhs.breedAvailability == rhs.breedAvailability &&
          lhs.breedType == rhs.breedType &&
          lhs.breedRequirements == rhs.breedRequirements &&
          lhs.breedTime == rhs.breedTime &&
          lhs.elements == rhs.elements &&
          lhs.ownZeroBreedPercentage == rhs.ownZeroBreedPercentage &&
          lhs.ownOneBreedPercentage == rhs.ownOneBreedPercentage &&
          lhs.ownTwoBreedPercentage == rhs.ownTwoBreedPercentage &&
          lhs.normalSingleClonePercentage == rhs.normalSingleClonePercentage &&
          lhs.normalDoubleClonePercentage == rhs.normalDoubleClonePercentage &&
          lhs.socialSingleClonePercentage == rhs.socialSingleClonePercentage &&
          lhs.socialDoubleClonePercentage == rhs.socialDoubleClonePercentage &&
          lhs.riftSingleClonePercentage == rhs.riftSingleClonePercentage &&
          lhs.riftDoubleClonePercentage == rhs.riftDoubleClonePercentage
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(breedAvailability)
        hasher.combine(breedType)
        hasher.combine(breedRequirements)
        hasher.combine(breedTime)
        hasher.combine(elements)
        hasher.combine(ownZeroBreedPercentage)
        hasher.combine(ownOneBreedPercentage)
        hasher.combine(ownTwoBreedPercentage)
        hasher.combine(normalSingleClonePercentage)
        hasher.combine(normalDoubleClonePercentage)
        hasher.combine(socialSingleClonePercentage)
        hasher.combine(socialDoubleClonePercentage)
        hasher.combine(riftSingleClonePercentage)
        hasher.combine(riftDoubleClonePercentage)
    }
}
extension BreedInformation: Codable {
    private enum CodingKeys: String, CodingKey {
        case breedAvailability = "breed_availability"
        case breedType = "breed_type"
        case breedRequirements = "breed_requirements"
        case breedTime = "breed_time"
        case elements
        case ownZeroBreedPercentage = "own_zero_breed_percentage"
        case ownOneBreedPercentage = "own_one_breed_percentage"
        case ownTwoBreedPercentage = "own_two_breed_percentage"
        case normalSingleClonePercentage = "normal_single_clone_percentage"
        case normalDoubleClonePercentage = "normal_double_clone_percentage"
        case socialSingleClonePercentage = "social_single_clone_percentage"
        case socialDoubleClonePercentage = "social_double_clone_percentage"
        case riftSingleClonePercentage = "rift_single_clone_percentage"
        case riftDoubleClonePercentage = "rift_double_clone_percentage"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
      
        try container.encode(breedAvailability, forKey: .breedAvailability)
        try container.encode(breedType, forKey: .breedType)
        try container.encode(breedRequirements, forKey: .breedRequirements)                    
        try container.encode(breedTime, forKey: .breedTime)
        try container.encode(elements, forKey: .elements)
        if let ownZeroBreedPercentage = ownZeroBreedPercentage {
            try container.encode(ownZeroBreedPercentage, forKey: .ownZeroBreedPercentage)
        }
        if let ownOneBreedPercentage = ownOneBreedPercentage {
            try container.encode(ownOneBreedPercentage, forKey: .ownOneBreedPercentage)
        }
        if let ownTwoBreedPercentage = ownTwoBreedPercentage {
            try container.encode(ownTwoBreedPercentage, forKey: .ownTwoBreedPercentage)
        }
        try container.encode(normalSingleClonePercentage, forKey: .normalSingleClonePercentage)
        try container.encode(normalDoubleClonePercentage, forKey: .normalDoubleClonePercentage)
        try container.encode(socialSingleClonePercentage, forKey: .socialSingleClonePercentage)
        try container.encode(socialDoubleClonePercentage, forKey: .socialDoubleClonePercentage)
        try container.encode(riftSingleClonePercentage, forKey: .riftSingleClonePercentage)
        try container.encode(riftDoubleClonePercentage, forKey: .riftDoubleClonePercentage)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let breedAvailability = try container.decodeIfPresent(BreedAvailability.self, forKey: .breedAvailability) else {
        print("Missing key value of breedAvailability when decoding BreedInformation")
        fatalError()
    }
        guard let breedType = try container.decodeIfPresent(BreedType.self, forKey: .breedType) else {
        print("Missing key value of breedType when decoding BreedInformation")
        fatalError()        
    }
        guard let breedRequirements = try container.decodeIfPresent(BreedComponents.self, forKey: .breedRequirements) else {
        print("Missing key value of breedRequirements when decoding BreedInformation")
        fatalError()
    }
        guard let breedTime = try container.decodeIfPresent(Time.self, forKey: .breedTime) else {
        print("Missing key value of breedTime when decoding BreedInformation")
        fatalError()
    }
        guard let elements = try container.decodeIfPresent(Set<DragonElement>.self, forKey: .elements) else {
        print("Missing key value of elements when decoding BreedInformation")
        fatalError()
    }
        self.breedAvailability = breedAvailability
        self.breedType = breedType
        self.breedRequirements = breedRequirements
        self.breedTime = breedTime
        self.elements = elements
        
        ownZeroBreedPercentage = try container.decodeIfPresent(Float.self, forKey: .ownZeroBreedPercentage)
        ownOneBreedPercentage = try container.decodeIfPresent(Float.self, forKey: .ownOneBreedPercentage)
        ownTwoBreedPercentage = try container.decodeIfPresent(Float.self, forKey: .ownTwoBreedPercentage)
        normalSingleClonePercentage = try container.decode(Float.self, forKey: .normalSingleClonePercentage)
        normalDoubleClonePercentage = try container.decode(Float.self, forKey: .normalDoubleClonePercentage)
        socialSingleClonePercentage = try container.decode(Float.self, forKey: .socialSingleClonePercentage)
        socialDoubleClonePercentage = try container.decode(Float.self, forKey: .socialDoubleClonePercentage)
        riftSingleClonePercentage = try container.decode(Float.self, forKey: .riftSingleClonePercentage)
        riftDoubleClonePercentage = try container.decode(Float.self, forKey: .riftDoubleClonePercentage)
    }
}
