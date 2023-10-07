import Foundation

class JSONManager: Writable {
    let fileManager = FileManager.default
    static let shared = JSONManager()

    private init() {}

    func readJSON(filePath: String) -> String? {
        do {
            let jsonString = try String(contentsOf: URL(fileURLWithPath: filePath))
            return jsonString
        } catch {
            print("Error when reading file \(filePath): \(error)")
            return nil
        }
    }    

    func encodeJSON(from data: Encodable) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        encoder.keyEncodingStrategy = .convertToSnakeCase
        do {
            let jsonData = try encoder.encode(data)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Failed to encode dragons: \(error.localizedDescription)")
        }
        return nil
    }

    func decodeJSONIntoDragons(jsonString: String) -> [Dragon]? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        if let jsonData = jsonString.data(using: .utf8) {
            do {
                let dragons = try decoder.decode([Dragon].self, from: jsonData)
                return dragons
            } catch let DecodingError.dataCorrupted(context) {
                print("Data corrupted: \(context)")
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found: \(context.debugDescription)")
            } catch let DecodingError.typeMismatch(type, context) {
                print("Type '\(type)' mismatch: \(context.debugDescription)")
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found: \(context.debugDescription)")
            } catch {
                print("Failed to decode dragons: \(error.localizedDescription)")
            }
        }
        return nil
    }

    func decodeJSONIntoDragonairumCollections(jsonString: String) -> [DragonariumCollection]? {
        let decoder = JSONDecoder()

        if let jsonData = jsonString.data(using: .utf8) {
            do {
                let dragariumCollections = try decoder.decode([DragonariumCollection].self, from: jsonData)
                return dragariumCollections
            } catch let DecodingError.dataCorrupted(context) {
                print("Data corrupted: \(context)")
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found: \(context.debugDescription)")
            } catch let DecodingError.typeMismatch(type, context) {
                print("Type '\(type)' mismatch: \(context.debugDescription)")
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found: \(context.debugDescription)")
            } catch {
                print("Failed to decode dragons: \(error.localizedDescription)")
            }
        }
        return nil
    }

    func initializeDragons(from filePath: String) -> [Dragon]? {
        if let dragonsJSON = readJSON(filePath: filePath) {
            return decodeJSONIntoDragons(jsonString: dragonsJSON)
        }
        return nil
    }

    func initializeDragonariumCollections(from filePath: String) -> [DragonariumCollection]? {
        if let collectionsJSON = readJSON(filePath: filePath) {
            return decodeJSONIntoDragonairumCollections(jsonString: collectionsJSON)
        }
        return nil
    }
}
