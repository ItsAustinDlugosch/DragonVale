import Foundation

struct CSVFile {
    let content : String
    let parameters : [String]
    let lines : [String]

    init?(content: String) {
        self.content = content
        var lines = content.components(separatedBy: .newlines).filter { !$0.isEmpty }
        guard lines.count > 0 else {
        return nil
    }
        self.parameters = lines.remove(at: 0).components(separatedBy: ",")
        self.lines = lines
    }
}
        

class CSVManager: Writable {
    let fileManager = FileManager.default      
    static let shared = CSVManager()

    private init() {}
    
    func readCSV(path: String) -> CSVFile? {
        do {
            let content = try String(contentsOfFile: path, encoding: .utf8)
            return CSVFile(content: content)
        } catch {
            print("Error when reading file `\(path)`: \(error)")
            return nil
        }        
    }

    func decodeCSV(file: CSVFile) -> [[String]]? {         
        var data = [[String]]()    
        for lineIndex in 0 ..< file.lines.count {
            // Real line number in file == lineIndex + 1 (starting at 0) + 1 (parameters line)
            let fields = file.lines[lineIndex].components(separatedBy: ",")
            
            guard fields.count == file.parameters.count else {
            print("Unexpected field count of `\(fields.count)` when processing line \(lineIndex + 2), \(fields)")
            return nil
        }            
            data.append(fields)
        }        
        return data
    }
    
    func createDragonsFromCSVData(from data: [[String]], parameters: [String]) -> [Dragon]? {

        func parseElements(_ value: String) -> Set<DragonElement> {
            let characterArray = Array(value)
            guard characterArray.count > 0 else {
                return []
            }
            var elements = Set<DragonElement>()
            var possibleElement : String = String(characterArray[0])
            for characterIndex in 0 ..< characterArray.count {
                if characterArray[characterIndex].isUppercase {
                    if let element = DragonElement(possibleElement) {
                        elements.insert(element)
                    }
                    possibleElement = String(characterArray[characterIndex])
                } else {
                    possibleElement.append(String(characterArray[characterIndex]))
                }
            }

            if let element = DragonElement(possibleElement) {
                elements.insert(element)
            }
            return elements
        }        
        
        var dragons = [Dragon]()
        // There must be 32 parameters to initialize a Dragon
        let dragonParametersCount = 40
        guard parameters.count == dragonParametersCount else {
        print("Cannot create dragons from unexpected parameter count of \(parameters.count)")
                return nil
    }
        
        for lineIndex in 0 ..< data.count {
            // Each line must have all parameters included
            guard data[lineIndex].count == parameters.count else {
            print("Unexpected field count of \(data[lineIndex].count) when processing line \(lineIndex + 2)")
            return nil
        }            
            let name = data[lineIndex][0]
            // Dragon names must be unique
            guard !dragons.contains(where: {$0.name == name}) else {
            print("Cannot insert duplicate named dragon of name: \(name); line: \(lineIndex + 2)")
            return nil
        }
            // Dragons must have a rarity
            guard let rarity = Rarity(data[lineIndex][1]) else {
            print("Cannot create rarity of `\(data[lineIndex][1])` for dragon of name `\(name)`; line: \(lineIndex + 2), \(data[lineIndex])")
            return nil
        }

            let breedAvailability = BreedAvailability(data[lineIndex][2])
            let breedComponentsElements = [DragonElement(data[lineIndex][3]),
                                           DragonElement(data[lineIndex][4]),
                                           DragonElement(data[lineIndex][5]),
                                           DragonElement(data[lineIndex][6]),
                                           DragonElement(data[lineIndex][7])].compactMap {$0}
            let breedComponentsDragons = [DragonInstance(data[lineIndex][8], PrimaryElement(data[lineIndex][9])),
                                          DragonInstance(data[lineIndex][10], PrimaryElement(data[lineIndex][11]))].compactMap {$0}
            let specialComponentsTime = data[lineIndex][15] != "" ? data[lineIndex][15] : nil
            let specialComponentsWeather = data[lineIndex][16] != "" ? data[lineIndex][16] : nil
            let specialComponentsCave = data[lineIndex][17] != "" ? data[lineIndex][17] : nil
            let specialComponentRiftTrait = PrimaryElement(data[lineIndex][13])
            let specialComponentsRiftTraits = specialComponentRiftTrait != nil ? Set<PrimaryElement>([specialComponentRiftTrait!]) : nil
            let breedComponentsSpecialComponents = SpecialBreedComponents(riftAlignment: PrimaryElement(data[lineIndex][12]),
                                                                          riftTraits: specialComponentsRiftTraits,
                                                                          minElementCount: Int(data[lineIndex][14]),
                                                                          time: specialComponentsTime,
                                                                          weather: specialComponentsWeather,
                                                                          cave: specialComponentsCave)
            let breedRequirements = BreedComponents(elements: breedComponentsElements,
                                                  dragons: breedComponentsDragons,
                                                  specialRequirements: breedComponentsSpecialComponents)
            // Dragons must have a breedTime
            guard let totalSeconds = Int(data[lineIndex][18]) else {            
            print("Unexpected time of \(data[lineIndex][18]); line \(lineIndex + 2)")
            return nil
        }
            let breedTime = Time(totalSeconds: totalSeconds)
            let elements = parseElements(data[lineIndex][19])
            let baseBreedPercentage = Float(data[lineIndex][20])
            let ownOneBreedPercentage = Float(data[lineIndex][21])
            let ownTwoBreedPercentage = Float(data[lineIndex][22])
            let normalSingleClonePercentage = Float(data[lineIndex][23])
            let normalDoubleClonePercentage = Float(data[lineIndex][24])
            let socialSingleClonePercentage = Float(data[lineIndex][25])
            let socialDoubleClonePercentage = Float(data[lineIndex][26])
            let riftSingleClonePercentage = Float(data[lineIndex][27])
            let riftDoubleClonePercentage = Float(data[lineIndex][28])
            let breedInformation = BreedInformation(breedAvailability: breedAvailability,
                                                    breedRequirements: breedRequirements,
                                                    breedTime: breedTime,
                                                    elements: elements,
                                                    baseBreedPercentage: baseBreedPercentage,
                                                    ownOneBreedPercentage: ownOneBreedPercentage,
                                                    ownTwoBreedPercentage: ownTwoBreedPercentage,
                                                    normalSingleClonePercentage: normalSingleClonePercentage,
                                                    normalDoubleClonePercentage: normalDoubleClonePercentage,
                                                    socialSingleClonePercentage: socialSingleClonePercentage,
                                                    socialDoubleClonePercentage: socialDoubleClonePercentage,
                                                    riftSingleClonePercentage: riftSingleClonePercentage,
                                                    riftDoubleClonePercentage: riftDoubleClonePercentage)
            let visibleElements = parseElements(data[lineIndex][29])
            let evolutionDragonName = data[lineIndex][30] != "" ? data[lineIndex][30] : nil
            guard let riftable = Bool(data[lineIndex][31]) else {
            print("Unexpected riftable of \(data[lineIndex][31]) on line \(lineIndex + 2)")
            return nil
        }
            guard let elderable = Bool(data[lineIndex][32]) else {
            print("Unexpected elderable of \(data[lineIndex][32]) on line \(lineIndex + 2)")
            return nil
        }
            let earnGold = Float(data[lineIndex][33])
            let earnEtherium = Int(data[lineIndex][34])
            let earnGem = Int(data[lineIndex][35])
            let magicCost = Int(data[lineIndex][36])
            let eventSection = Int(data[lineIndex][37])           
            let requiredTrait = PrimaryElement(data[lineIndex][38])
            let quest = data[lineIndex][39] != "" ? data[lineIndex][39] : nil

            dragons.append(Dragon(name: name, rarity: rarity,
                                  visibleElements: visibleElements, requiredTrait: requiredTrait,
                                  breedInformation: breedInformation,
                                  evolutionDragonName: evolutionDragonName,
                                  riftable: riftable, elderable: elderable,
                                  earnGold: earnGold, earnEtherium: earnEtherium, earnGem: earnGem,
                                  magicCost: magicCost, eventSection: eventSection,
                                  quest: quest))
        }        
        return dragons
    }

    func initializeDragons(path: String) -> [Dragon]? {
        if let dragonsCSV = readCSV(path: path),
           let dragonsCSVData = decodeCSV(file: dragonsCSV) {        
            return createDragonsFromCSVData(from: dragonsCSVData, parameters: dragonsCSV.parameters)
        }
        return nil
    }
    func initializeDragons(csvFile: CSVFile) -> [Dragon]? {
         if let dragonsCSVData = decodeCSV(file: csvFile) {        
            return createDragonsFromCSVData(from: dragonsCSVData, parameters: csvFile.parameters)
        }
        return nil
    }
}

