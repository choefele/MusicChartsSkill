import Foundation

public enum ChartsServiceResult<T> {
    case success(T)
    case failure(Error)
}

public struct MessageError: Error, Equatable {
    public var message: String
    
    public init(message: String) {
        self.message = message
    }
    
    public static func ==(lhs: MessageError, rhs: MessageError) -> Bool {
        return lhs.message == rhs.message
    }
}

public struct ChartEntry: Equatable {
    public var trackName: String
    public var artist: String
    public var url: URL
    
    public init(trackName: String, artist: String, url: URL) {
        self.trackName = trackName
        self.artist = artist
        self.url = url
    }
    
    public static func ==(lhs: ChartEntry, rhs: ChartEntry) -> Bool {
        return lhs.trackName == rhs.trackName
            && lhs.artist == rhs.artist
            && lhs.url == rhs.url
    }
}

public protocol ChartsService {
    func retrieveCharts(completion: @escaping (ChartsServiceResult<[ChartEntry]>) -> ())
}
