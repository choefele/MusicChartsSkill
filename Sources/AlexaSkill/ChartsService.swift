import Foundation

enum ChartsServiceResult<T> {
    case success(T)
    case failure(Error)
}

protocol ChartsService {
}
