extension Dictionary {
    init(keys: Set<Key>, mapping: (Key) -> Value) {
        let keyValuePairs = keys.map { (key) -> (Key, Value) in
            return (key, mapping(key))
        }
        self.init(uniqueKeysWithValues: keyValuePairs)
    }
}
