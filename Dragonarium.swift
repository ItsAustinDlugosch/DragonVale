class Dragonarium {
    let dragons: [Dragon]

    init(dragons: [Dragon]) {
        self.dragons = dragons
    }

    convenience init(lines: [String]) {
        var verifiedDragons = [Dragon]()
        for i in 0 ..< lines.count {
            if let dragon = Dragon(line: lines[i]) {
                verifiedDragons.append(dragon)
            } else {
                print("Failed to initialize Dragon from \(lines[i]) on line \(i + 1)")
            }
        }
        self.init(dragons: verifiedDragons)
    }

    convenience init(filePath: String) {
        let contents : String
        do {        
            contents = try String(contentsOfFile: filePath)            
        } catch {
            print("File read error: \(error)")
            fatalError()
        }
        let lines = contents.components(separatedBy: .newlines).filter { !$0.isEmpty }        
        self.init(lines: lines)
    }
}
