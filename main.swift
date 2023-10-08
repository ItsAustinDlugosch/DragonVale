import Foundation
import FoundationNetworking

func main() {
    func fetchGoogleSheetData(completion: @escaping (Result<String, Error>) -> Void) {
        // The URL you obtained from the 'Publish to the web' option
        let googleSheetURLString = "https://docs.google.com/spreadsheets/d/e/2PACX-1vRNK10mzHPt3Y9SsjMYpXI3PP4u2hkdF159sye3DCx3hjhbSLOI49buK0ZIE9opdb_WQ_o2-10oVD5z/pub?gid=0&single=true&output=csv"
        print("fetching \(googleSheetURLString) . . .")

        guard let googleSheetURL = URL(string: googleSheetURLString) else {
        completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
        return
    }   
        let task = URLSession.shared.dataTask(with: googleSheetURL) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
            }

            guard let data = data else {
                print("No data received from server")
                return
            }

            // Handle your data here, like converting it to a string
            if let csvString = String(data: data, encoding: .utf8) {
                completion(.success(csvString))
                return
            } else {
                print("Could not convert data to string")
            }
        }
        task.resume()    
    }

    // Usage
    let semaphore = DispatchSemaphore(value: 0)
    fetchGoogleSheetData { result in
        switch result {
        case .success(let dataString):
            let csvManager = CSVManager.shared
            let jsonManager = JSONManager.shared
            
            if let dragonariumCSV = CSVFile(content: dataString),
               let csvDragonarium = csvManager.initializeDragonarium(csvFile: dragonariumCSV),
               let dragonsJSON = jsonManager.encodeJSON(from: csvDragonarium),
               let jsonDragonarium: Dragonarium = jsonManager.decodeJSON(jsonString: dragonsJSON) {
                print("dragons equal? \(csvDragonarium.dragons == jsonDragonarium.dragons)")
                print("dragon names equal? \(csvDragonarium.dragons.map{$0.name} == jsonDragonarium.dragons.map{$0.name})")
                print("dragon count equal? \(csvDragonarium.dragons.count == jsonDragonarium.dragons.count)")

                print(jsonDragonarium.dragons.map{$0.breedInformation})
                
                csvManager.write(path: "./csv/dragons.csv", content: dragonariumCSV.content)
                jsonManager.write(path: "./json/dragons.json", content: dragonsJSON)
            } else {
                print("bad")
            }                
        case .failure(let error):
            print("Error fetching data:", error.localizedDescription)
        }
        semaphore.signal()
    }
    semaphore.wait()
}
main()
