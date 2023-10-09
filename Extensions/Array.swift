import Foundation

extension Array where Element == DragonElement {
    func countOccurrences() -> [DragonElement: Int] {
        var counts: [DragonElement: Int] = [:]
        for item in self {
            counts[item, default: 0] += 1
        }
        return counts
    }
    
    static func + (lhs: Array<DragonElement>, rhs: Array<DragonElement>) -> Array<DragonElement> {
        let lhsCounts = lhs.countOccurrences()
        let rhsCounts = rhs.countOccurrences()
        
        // Union of all unique elements from both arrays
        let allKeys = Set<DragonElement>(lhsCounts.keys).union(rhsCounts.keys)
        
        var combined: [DragonElement] = []
        for key in allKeys {
            let maxCount = Swift.max(lhsCounts[key] ?? 0, rhsCounts[key] ?? 0)
            combined.append(contentsOf: Array(repeating: key, count: maxCount))
        }
        
        return combined
    }
}
