import Foundation
extension Float {
    func truncated(_ place: Int = 3) -> Float {
        let multiplier : Float = Float(pow(10.0, Float(place)))
        return (self * multiplier).rounded() / multiplier
    }
}
