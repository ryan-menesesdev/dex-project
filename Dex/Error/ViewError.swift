import Foundation

enum ViewError: Error, Identifiable {
    case context(ModelContextError)
    case fetch(FetchError)

    var id: String { String(describing: self) }

    var message: String {
        switch self {
        case .context(let error):
            return error.message
        case .fetch(let error):
            return error.message
        }
    }
}
