import Foundation

public enum FetchError: Error, Identifiable {
    case badURL
    case badResponse
    case decodingError
    
    public var id: Self { self }
    
    var message: String {
        switch self {
        case .badURL:
            return "There was a problem with the request URL. Please try again later."
        case .badResponse:
            return "Received an invalid response from the server. Please try again later."
        case .decodingError:
            return "Failed to process the data from the server. Please retry again."
        }
    }
}
