// Represents special conditions that must be met in order for a dragon to be bred.
// - `riftAlignment`: Primary Element that the rift must be aligned with
// - `elementCount`: Number of Dragon Elements required in the breed combination
// - `duplicateElement`: Dragon Element that both dragons must have
// - `time`: Time of Day or Twilight Tower setting required
// - `weather`: Weather or Weather Station setting required
// - `any`: Denotes that a dragon can be bred regardless of breed combination
struct SpecialBreedComponents {
    let riftAlignment : PrimaryElement?
    let riftTraits : Set<PrimaryElement>?
    let restrictiveElements : Set<PrimaryElement>?
    let minElementCount : Int?
    let time : String?
    let weather : String?
    let cave : String?

    init(riftAlignment: PrimaryElement? = nil, riftTraits: Set<PrimaryElement>? = nil, restrictiveElements: Set<PrimaryElement>? = nil,
         minElementCount: Int? = nil, time: String? = nil, weather: String? = nil, cave: String? = nil) {
        self.riftAlignment = riftAlignment
        self.riftTraits = riftTraits
        self.restrictiveElements = restrictiveElements
        self.minElementCount = minElementCount
        self.time = time
        self.weather = weather
        self.cave = cave
    }

    static func + (lhs: SpecialBreedComponents, rhs: SpecialBreedComponents) -> SpecialBreedComponents? {
        // Function that checks if particular requirements overlap between either sides of the + operator
        // Returns a satisfiable that denotes whether the requirements are able to be satisfied
        // Returns a value of the requirement itself
        // Applies for special requirements that are non-overlapping, where two different requirements cannot be mutually satisfied
        func checkForOverlap<T: Equatable>(_ lhs: T?, _ rhs: T?) -> (satisfiable: Bool, value: T?) {
            // If they are both nil, return no overlap with nil as the requirement
            if lhs == nil && rhs == nil {
                return (true, nil)
            }
            
            // If one is nil, return no overlap with the other as the requirement
            if lhs == nil {
                return (true, rhs)
            } else if rhs == nil {
                return (true, lhs)
            }

            // If both are equal non-nil values, return no overlap one of the values as the requirement
            if lhs == rhs {
                return (true, lhs)
            }

            // Since both are non-nil different values, return unsatisfiableOverlap
            return (false, nil)
        }

        func mergeRiftTraits(_ lhs: Set<PrimaryElement>?, _ rhs: Set<PrimaryElement>?) -> (satisfiable: Bool, value: Set<PrimaryElement>?) {
            // Coalesce sets to empty sets to merge them together
            let lhsRiftTraits = lhs ?? Set<PrimaryElement>()
            let rhsRiftTraits = rhs ?? Set<PrimaryElement>()
            let mergedRiftTraits = lhsRiftTraits.union(rhsRiftTraits)
            // If there are more than two traits in the set, the combination is not satisfiable
            if mergedRiftTraits.count > 2 {
                return (false, nil)
            }
            // If there are no traits in the set, the combination is satisfiable, but there are no traits required
            if mergedRiftTraits.count == 0 {
                return (true, nil)
            }
            // There are between 0 and 2 traits in the set, so the combination is satisfiable, return the set of traits
            return (true, mergedRiftTraits)
        }
        
        // Non overlapping Special Requirements
        let combinedRiftAlignment = checkForOverlap(lhs.riftAlignment, rhs.riftAlignment)
        let combinedRiftTraits = mergeRiftTraits(lhs.riftTraits, rhs.riftTraits)
        let combinedTime = checkForOverlap(lhs.time, rhs.time)
        let combinedWeather = checkForOverlap(lhs.weather, rhs.weather)
        let combinedCave = checkForOverlap(lhs.cave, rhs.cave)
        // Make sure that each combined requirement is still able to be satisfied
        guard combinedRiftAlignment.satisfiable,
              combinedRiftTraits.satisfiable,
              combinedTime.satisfiable,
              combinedWeather.satisfiable,
              combinedCave.satisfiable else {
        return nil
    }

        
        // Function that returns the greatest elementCount required
        func greaterNonNilInteger(_ lhs: Int?, _ rhs: Int?) -> Int? {
            // If both values are equal (or both nil), return one of the values
            if lhs == rhs {
                return lhs
            }
            // If one value is equal to nil, return the other
            if lhs == nil {
                return rhs
            } else if rhs == nil {
                return lhs
            }

            // Since both are non-nil, unwrap and return the value of the greater integer
            if lhs! > rhs! {
                return lhs
            } else {
                return rhs
            }            
        }
        
        let combinedMinElementCountValue = greaterNonNilInteger(lhs.minElementCount, rhs.minElementCount)
        // Only will the combined requirement be any if both sides are true

        return SpecialBreedComponents(riftAlignment: combinedRiftAlignment.value, riftTraits: combinedRiftTraits.value,
                                      minElementCount: combinedMinElementCountValue, time: combinedTime.value,
                                      weather: combinedWeather.value, cave: combinedCave.value)
    }

    var isEmpty: Bool {
        return riftAlignment == nil &&
          riftTraits == nil &&
          minElementCount == nil &&
          time == nil &&
          weather == nil &&
          cave == nil
    }
}

extension SpecialBreedComponents: Codable {
    private enum CodingKeys: String, CodingKey {
        case riftAlignment = "rift_alignment"
        case riftTraits = "rift_traits"
        case restrictiveElements = "restrictive_elements"
        case minElementCount = "min_element_count"
        case time
        case weather
        case cave
    }


    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if let riftAlignment = riftAlignment {
            try container.encode(riftAlignment, forKey: .riftAlignment)
        }
        if let riftTraits = riftTraits {
            try container.encode(riftTraits, forKey: .riftTraits)
        }
        if let restrictiveElements = restrictiveElements {
            try container.encode(restrictiveElements, forKey: .restrictiveElements)
        }
        if let minElementCount = minElementCount {
            try container.encode(minElementCount, forKey: .minElementCount)
        }
        if let time = time {
            try container.encode(time, forKey: .time)
        }
        if let weather = weather {
            try container.encode(weather, forKey: .weather)
        }
        if let cave = cave {
            try container.encode(cave, forKey: .cave)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        riftAlignment = try container.decodeIfPresent(PrimaryElement.self, forKey: .riftAlignment)
        riftTraits = try container.decodeIfPresent(Set<PrimaryElement>.self, forKey: .riftTraits)
        restrictiveElements = try container.decodeIfPresent(Set<PrimaryElement>.self, forKey: .restrictiveElements)
        minElementCount = try container.decodeIfPresent(Int.self, forKey: .minElementCount)
        time = try container.decodeIfPresent(String.self, forKey: .time)
        weather = try container.decodeIfPresent(String.self, forKey: .weather)
        cave = try container.decodeIfPresent(String.self, forKey: .cave)        
    }
}

extension SpecialBreedComponents: Equatable {
    static func == (lhs: SpecialBreedComponents, rhs: SpecialBreedComponents) -> Bool {
        return lhs.riftAlignment == rhs.riftAlignment &&
          lhs.riftTraits == rhs.riftTraits &&
          lhs.restrictiveElements == rhs.restrictiveElements &&
          lhs.minElementCount == rhs.minElementCount &&          
          lhs.time == rhs.time &&
          lhs.weather == rhs.weather &&
          lhs.cave == rhs.cave
    }
}

extension SpecialBreedComponents: CustomStringConvertible {
    var description: String {
        var parts = [String]()
        if let riftAlignment = riftAlignment {
            parts.append("riftAlignment: \(riftAlignment)")
        }
        if let riftTraits = riftTraits {
            parts.append("riftTraits: \(riftTraits)")
        }
        if let restrictiveElements = restrictiveElements {
            parts.append("restrictiveElements: \(restrictiveElements)")
        }
        if let minElementCount = minElementCount {
            parts.append("elementCount: \(minElementCount)")
        }
        if let time = time {
            parts.append("time: \(time)")
        }
        if let weather = weather {
            parts.append("weather: \(weather)")
        }
        if let cave = cave {
            parts.append("cave: \(cave)")
        }
        return parts.joined(separator: ", ")
    }
}

extension SpecialBreedComponents: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(riftAlignment)
        hasher.combine(riftTraits)
        hasher.combine(restrictiveElements)
        hasher.combine(minElementCount)
        hasher.combine(time)
        hasher.combine(weather)
        hasher.combine(cave)
    }
}
