class Dragonarium: Codable, Equatable {
    let dragons: Set<Dragon>    
    let collections: [DragonariumCollection]

    var breedableDragons: Set<BreedableDragon> {
        return  Set<BreedableDragon>(dragons.compactMap { BreedableDragon(from: $0) })
    }
    var fixedDragons: Set<BreedableDragon> {
        return breedableDragons.filter { $0.breedInformation.isFixed() }
    }
    var fluctuatingDragons: Set<BreedableDragon> {
        return breedableDragons.filter { $0.breedInformation.isFluctuating() }
    }

    init(dragons: [Dragon], collections: [DragonariumCollection]) {
        self.dragons = Set<Dragon>(dragons)
        self.collections = collections
    }

    static func == (lhs: Dragonarium, rhs: Dragonarium) -> Bool {
        return lhs.dragons == rhs.dragons &&
          lhs.breedableDragons == rhs.breedableDragons &&
          lhs.collections == rhs.collections
    }

    func dragon(_ name: String) -> Dragon? {
        return dragons.first { $0.name == name }
    }
    func breedableDragon( _ name: String) -> BreedableDragon? {
        return breedableDragons.first { $0.name == name }
    }
}

extension Dragonarium: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(dragons)
        hasher.combine(breedableDragons)
        hasher.combine(collections)
    }
}
