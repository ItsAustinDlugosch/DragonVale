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

    func decodeJSON<T: Codable>(jsonString: String) -> T? {
        let decoder = JSONDecoder()

        guard let jsonData = jsonString.data(using: .utf8) else {
        print("Failed to convert jsonString to Data")
        return nil
    }

        do {
            let data = try decoder.decode(T.self, from: jsonData)
            return data
        } catch let DecodingError.dataCorrupted(context) {
            print("Data corrupted: \(context)")
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found: \(context.debugDescription)")
        } catch let DecodingError.typeMismatch(type, context) {
            print("Type '\(type)' mismatch: \(context.debugDescription)")
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found: \(context.debugDescription)")
        } catch {
            print("Failed to decode: \(error.localizedDescription)")
        }

        return nil
    }


    

    func initializeDragonarium(from filePath: String) -> Dragonarium? {
        if let dragonariumJSON = readJSON(filePath: filePath),
           let dragonarium: Dragonarium = decodeJSON(jsonString: dragonariumJSON) {
            return dragonarium
        }
        return nil
    }
}
