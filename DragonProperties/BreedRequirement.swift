enum BreedRequirement : Hashable {
    case dragon(_ dragon: String)
    case dragonElement(_ element: DragonElement)
    case elementCount(_ count: Int)
    case specialRequirement(_ requirement: String)
    case unbreedable

    init?(_ value: String) {
        if value == "" {
            self = .unbreedable            
        } else {
            let firstCharacter = value.firstCharacter()
            if firstCharacter!.isUppercase {
                self = .dragon(value)
            } else if firstCharacter! == "[" {
                let specialRequirementString = value.segment(from: 1, to: value.count - 2) ?? ""
                if let specialRequirementFirstCharacter = specialRequirementString.firstCharacter(), let elementCount = Int(String(specialRequirementFirstCharacter)) {
                    self = .elementCount(elementCount)
                } else {
                    self = .specialRequirement(specialRequirementString)
                }
            } else if let dragonElement = DragonElement(value) {
                self = .dragonElement(dragonElement)                
            } else {
                print("Failed to create breeding requirement from '\(value)'")
                return nil
            }
        }
    }
}

extension BreedRequirement: CustomStringConvertible {
    var description: String {
        switch self {
        case .dragon(let name): return name
        case .dragonElement(let element): return "\(element)"
        case .elementCount(let elementCount): return "[\(elementCount) elements]"
        case .specialRequirement(let requirement): return "[\(requirement)]"
        case .unbreedable: return ""
        }
    }
}

extension BreedRequirement : Equatable {
    static func ==(lhs: BreedRequirement, rhs: BreedRequirement) -> Bool {
        switch (lhs, rhs) {
        case (.dragon(let leftName), .dragon(let rightName)):
            return leftName == rightName
        case (.dragonElement(let leftElement), .dragonElement(let rightElement)):
            return leftElement == rightElement
        case (.elementCount(let leftCount), .elementCount(let rightCount)):
            return leftCount == rightCount
        case (.specialRequirement(let leftRequirement), .specialRequirement(let rightRequirement)):
            return leftRequirement == rightRequirement
        case (.unbreedable, .unbreedable):
            return true
        default:
            return false
        }
    }
}

protocol Matchable {
  static func ~= (lhs: Self, rhs: Self) -> Bool
}

extension BreedRequirement : Matchable {
    static func ~=(lhs: BreedRequirement, rhs: BreedRequirement) -> Bool {
        switch (lhs, rhs) {
        case (.dragon, .dragon),
             (.dragonElement, .dragonElement),
             (.elementCount, .elementCount),
             (.specialRequirement, .specialRequirement),
             (.unbreedable, .unbreedable):
            return true
        default:
            return false
        }
    }
}