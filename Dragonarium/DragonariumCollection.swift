struct DragonariumCollection: Codable {
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
}
