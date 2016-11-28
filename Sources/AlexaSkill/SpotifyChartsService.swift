import Foundation
import KituraNet
import CSV

class SpotifyChartsService {
    func retrieveCharts(completion: @escaping () -> ()) {
        let URL = "https://spotifycharts.com/regional/global/daily/latest/download"
        let _ = HTTP.get(URL) { response in
            var data = Data()
            if let _ = try? response?.readAllData(into: &data),
                let dataAsString = String(data: data, encoding: .utf8) {
                let rows = dataAsString
                    .components(separatedBy: .newlines)
                    .dropFirst()
                    .map() { row in
                    return row.components(separatedBy: ",")
                }
                print("")
            }

            completion()
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
