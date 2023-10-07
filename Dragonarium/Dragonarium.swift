class Dragonarium {
    let dragons: Set<Dragon>
    let collections: [DragonariumCollection]

    init(dragons: [Dragon], collections: [DragonariumCollection]) {
        self.dragons = Set<Dragon>(dragons)
        self.collections = collections
    }
}
