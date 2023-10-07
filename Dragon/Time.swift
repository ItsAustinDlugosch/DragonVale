// Represents the time it takes for a dragon to be bred and incubated
struct Time: Comparable, CustomStringConvertible, Codable, Hashable {
    let hours : Int
    let minutes : Int
    let seconds : Int

    // Property describing the total amount of seconds in a breed used for comparing and reducing the time of a breed
    var totalSeconds : Int {
        return (hours * 60 * 60) + (minutes * 60) + seconds
    }

    // Initialize based on hours, minutes, and seconds as parameters    
    init(hours: Int, minutes: Int, seconds: Int) {
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }

    // Initialize based on a string input of this format: `HH:MM:SS`
    init?(_ value: String) {
        let timeValues = value.split(separator: ":")
        guard timeValues.count == 3,
              let hours = Int(timeValues[0]),
              let minutes = Int(timeValues[1]),
              let seconds = Int(timeValues[2]) else {
        print("Failed to create time from '\(value)'")
        return nil
    }
        self.init(hours: hours, minutes: minutes, seconds: seconds)
    }

    // Initialize based on totalSeconds as a parameter
    init(totalSeconds: Int) {
        self.hours = totalSeconds / 60 / 60
        self.minutes = totalSeconds / 60 % 60
        self.seconds = totalSeconds % 60
    }

    // Function that reduces the time of a breed with a default value of 0.8
    func reduce(_ multiplier: Double = 0.8) -> Time {
        let reducedTotalSeconds = Double(totalSeconds) * multiplier
        // Function that rounds a double to its nearest integer
        func roundDouble(_ double: Double) -> Int {
            let tenthsPlace = Int(double * 10) % 10
            if tenthsPlace < 5 {
                return Int(double)
            }
            return Int(double) + 1
        }
        return Time(totalSeconds: roundDouble(reducedTotalSeconds))
    }

    var description: String {
        // Function that prepends zeros while the length of the string is less than an inputed count with a default value of 2
        func prependZero(_ string: String, count: Int = 2) -> String {
            var string = string            
            while string.count < count {
                string = "0" + string
            }
            return string
        }
        let hours = prependZero(String(hours))
        let minutes = prependZero(String(minutes))
        let seconds = prependZero(String(seconds))
        return "\(hours):\(minutes):\(seconds)"
    }

    static func < (_ lhs: Time, rhs: Time) -> Bool {
        return lhs.totalSeconds < rhs.totalSeconds 
    }

    static func == (_ lhs: Time, rhs: Time) -> Bool {
        return lhs.totalSeconds == rhs.totalSeconds
    }
}
