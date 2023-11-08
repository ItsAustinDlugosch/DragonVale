import Foundation

extension Array where Element == DragonElement {
    func countOccurrences() -> [DragonElement: Int] {
        var counts: [DragonElement: Int] = [:]
        for item in self {
            counts[item, default: 0] += 1
        }
        return counts
    }
    
    func maxCountOfElements(with other: Array<DragonElement>) -> Array<DragonElement> {
        let selfCounts = self.countOccurrences()
        let otherCounts = other.countOccurrences()
        
        // Union of all unique elements from both arrays
        let allKeys = Set<DragonElement>(selfCounts.keys).union(otherCounts.keys)
        
        var combined: [DragonElement] = []
        for key in allKeys {
            let maxCount = Swift.max(selfCounts[key] ?? 0, otherCounts[key] ?? 0)
            combined.append(contentsOf: Array(repeating: key, count: maxCount))
        }
        
        return combined
    }
}
