import Foundation
import KituraNet
import CSV

public class SpotifyChartsService: ChartsService {
    public init() {
    }
    
    public func retrieveCharts(completion: @escaping (ChartsServiceResult<[ChartEntry]>) -> ()) {
        // Need to disable SSL verification because this caused
        // a CURLE_SSL_CACERT_BADFILE error on amazonlinux
        let options: [ClientRequest.Options] = [
            .schema("https://"),
            .hostname("spotifycharts.com"),
            .path("/regional/global/daily/latest/download"),
            .disableSSLVerification
        ]
        let clientRequest = HTTP.request(options) { response in
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
        clientRequest.end()
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
