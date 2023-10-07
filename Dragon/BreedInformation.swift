// Represents the information pertaining to breeding for a dragon
struct BreedInformation : Codable, Equatable, Hashable {
    let breedAvailability: BreedAvailability
    let breedRequirements: BreedComponents
    let breedTime: Time
    let elements: Set<DragonElement>
    let baseBreedPercentage: Float?
    let ownOneBreedPercentage: Float?
    let ownTwoBreedPercentage: Float?
    let normalSingleClonePercentage: Float?
    let normalDoubleClonePercentage: Float?
    let socialSingleClonePercentage: Float?
    let socialDoubleClonePercentage: Float?
    let riftSingleClonePercentage: Float?
    let riftDoubleClonePercentage: Float?

    init?(breedAvailability: BreedAvailability? = nil, breedRequirements: BreedComponents? = nil, breedTime: Time, elements: Set<DragonElement>? = nil,
          baseBreedPercentage: Float? = nil, ownOneBreedPercentage: Float? = nil, ownTwoBreedPercentage: Float? = nil,
          normalSingleClonePercentage: Float? = nil, normalDoubleClonePercentage: Float? = nil,
          socialSingleClonePercentage: Float? = nil, socialDoubleClonePercentage: Float? = nil,
          riftSingleClonePercentage: Float? = nil, riftDoubleClonePercentage: Float? = nil) {
        guard let breedAvailability = breedAvailability,
              let breedRequirements = breedRequirements,
              let elements = elements else {
              return nil
          }
        self.breedAvailability = breedAvailability
        self.breedRequirements = breedRequirements
        self.breedTime = breedTime
        self.elements = elements
        self.baseBreedPercentage = baseBreedPercentage
        self.ownOneBreedPercentage = ownOneBreedPercentage
        self.ownTwoBreedPercentage = ownTwoBreedPercentage
        self.normalSingleClonePercentage = normalSingleClonePercentage
        self.normalDoubleClonePercentage = normalDoubleClonePercentage
        self.socialSingleClonePercentage = socialSingleClonePercentage
        self.socialDoubleClonePercentage = socialDoubleClonePercentage
        self.riftSingleClonePercentage = riftSingleClonePercentage
        self.riftDoubleClonePercentage = riftDoubleClonePercentage
    }

    public static func == (lhs: BreedInformation, rhs: BreedInformation) -> Bool {
        return lhs.breedAvailability == rhs.breedAvailability &&
          lhs.breedRequirements == rhs.breedRequirements &&
          lhs.breedTime == rhs.breedTime &&
          lhs.elements == rhs.elements &&
          lhs.baseBreedPercentage == rhs.baseBreedPercentage &&
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
        hasher.combine(breedRequirements)
        hasher.combine(breedTime)
        hasher.combine(elements)
        hasher.combine(baseBreedPercentage)
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
