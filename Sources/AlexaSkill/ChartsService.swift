import Foundation

enum ChartsServiceResult<T> {
    case success(T)
    case failure(Error)
}

struct MessageError: Error, Equatable {
    var message: String
    
    static func ==(lhs: MessageError, rhs: MessageError) -> Bool {
        return lhs.message == rhs.message
    }
}

struct ChartEntry: Equatable {
    var trackName: String
    var artist: String
    var url: URL
    
    static func ==(lhs: ChartEntry, rhs: ChartEntry) -> Bool {
        return lhs.trackName == rhs.trackName
            && lhs.artist == rhs.artist
            && lhs.url == rhs.url
    }
}

protocol ChartsService {
}
