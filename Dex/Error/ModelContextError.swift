import Foundation

public enum ModelContextError: Error, Identifiable {
    case saveFailed
    case insertFailed
    case spriteSaveFailed

    public var id: Self { self }

    var message: String {
        switch self {
        case .saveFailed:
            return "Could not save your favorite status. Please try again."
        case .insertFailed:
            return "Could not insert pokemon in storage. Please try again."
        case .spriteSaveFailed:
            return "Could not save pokemon sprites. Please try again later."
        }
    }
}
