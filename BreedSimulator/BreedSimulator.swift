class BreedSimulator {
    static var shared: BreedSimulator? = nil

    let dragonarium: Dragonarium

    private init(dragonarium: Dragonarium) {
        self.dragonarium = dragonarium
    }

    static func initialize(with dragonarium: Dragonarium) {
        shared = BreedSimulator(dragonarium: dragonarium)
    }
}
