enum BreedPercentage : Hashable {
    case fixed(_ percent: Float)
    case hybrid
    case unknown
    case unbreedable

    init?(_ value: String) {
        func percentageString(_ string: String) -> String {
           var percentageString : String = ""
           for c in string {
               if c == "%" {
                   break
               }
               percentageString += String(c)
           }            
           return percentageString
        }
        let percentageString = percentageString(value)
        if let breedPercentage = Float(percentageString) {
            self = .fixed(breedPercentage)
        } else {
            switch percentageString {
            case "*" : self = .hybrid
            case "?" : self = .unknown
            case "$" : self = .unbreedable
            default: print("Failed to create breed percentage from '\(value)'")
                return nil
            }            
        }
    }
}
extension BreedPercentage : CustomStringConvertible {
    var description: String {
        switch self {
        case .fixed(let percent) : return "\(percent)%"
        case .hybrid : return "*%"
        case .unknown : return "?%"
        case .unbreedable : return "$%"
        }
    }
}
extension BreedPercentage : Equatable {
    static func ==(lhs: BreedPercentage, rhs: BreedPercentage) -> Bool {
        switch (lhs, rhs) {
        case (.fixed(let leftPercent), .fixed(let rightPercent)):
            return leftPercent == rightPercent
        case (.hybrid, .hybrid), (.unknown, .unknown), (.unbreedable, .unbreedable):
            return true
        default:
            return false
        }
    }
}
