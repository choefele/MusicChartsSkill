import Foundation
import KituraNet
import CSV

class SpotifyChartsService: ChartsService {
    func retrieveCharts(completion: @escaping (ChartsServiceResult<[ChartEntry]>) -> ()) {
        let URL = "https://spotifycharts.com/regional/global/daily/latest/download"
        let _ = HTTP.get(URL) { response in
            var data = Data()
            guard let _ = try? response?.readAllData(into: &data) else {
                completion(.failure(MessageError(message: "Invalid data")))
                return
            }
            
            guard let entries = SpotifyChartsService.parse(data: data) else {
                completion(.failure(MessageError(message: "Error parsing data")))
                return
            }
            
            completion(.success(entries))
        }
    }
    
    static func parse(data: Data) -> [ChartEntry]? {
        guard let dataAsString = String(data: data, encoding: .utf8),
            var csv = try? CSV(string: dataAsString, hasHeaderRow: true) else {
                return nil
        }
        
        var entries = [ChartEntry]()
        while let _ = csv.next() {
            guard let trackName = csv["Track Name"],
                let artist = csv["Artist"],
                let urlString = csv["URL"],
                let url = URL(string: urlString) else {
                    return nil
            }
            
            entries.append(ChartEntry(trackName: trackName, artist: artist, url: url))
        }
        
        return entries
    }
}
