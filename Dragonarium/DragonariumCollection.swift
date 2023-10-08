struct DragonariumCollection: Codable, Equatable {
    let name: String
    let dragons: [String]
    let category: DragonariumCategory

    enum DragonariumCategory: String, Codable {
        case elemental, epic, special, all
    }

    init(name: String, dragons: [String], category: DragonariumCategory) {
        self.name = name
        self.dragons = dragons
        self.category = category
    }

    static func == (lhs: DragonariumCollection, rhs: DragonariumCollection) -> Bool {
        return lhs.name == rhs.name &&
          lhs.dragons == rhs.dragons &&
          lhs.category == rhs.category
    }
}
extension DragonariumCollection: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(dragons)
        hasher.combine(category)
    }
}
