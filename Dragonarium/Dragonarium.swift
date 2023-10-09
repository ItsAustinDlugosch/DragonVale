class Dragonarium: Codable, Equatable {
    let dragons: Set<Dragon>
    let collections: [DragonariumCollection]

    init(dragons: [Dragon], collections: [DragonariumCollection]) {
        self.dragons = Set<Dragon>(dragons)
        self.collections = collections
    }

    static func == (lhs: Dragonarium, rhs: Dragonarium) -> Bool {
        return lhs.dragons == rhs.dragons &&
          lhs.collections == rhs.collections
    }

    func dragon(_ name: String) -> Dragon? {
        return dragons.first { $0.name == name }
    }
}

extension Dragonarium: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(dragons)
        hasher.combine(collections)
    }
}
