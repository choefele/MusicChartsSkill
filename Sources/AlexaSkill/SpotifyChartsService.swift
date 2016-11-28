import Foundation
import KituraNet

class SpotifyChartsService {
    func retrieve(completion: @escaping () -> ()) {
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
}
