import Foundation
import KituraNet
//import SwiftyJSON

class SpotifyChartsService {
    func retrieve(completion: @escaping () -> ()) {
        let URL = "http://google.com"
        let _ = HTTP.get(URL) { response in
            var data = Data()
            try! response!.readAllData(into: &data)
            //            let dict = JSON(data: data)
            
            completion()
        }
    }
}
