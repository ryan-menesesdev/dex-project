import SwiftData
import Foundation

@MainActor
struct PersistenceController {
    static let shared = PersistenceController()

    static var previewSample: Pokemon {
        guard let url = Bundle.main.url(forResource: "samplepokemon", withExtension: "json") else {
            fatalError("Failed to find samplepokemon.json in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load data from samplepokemon.json.")
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let pokemon = try? decoder.decode(Pokemon.self, from: data) else {
            fatalError("Failed to decode samplepokemon.json.")
        }

        return pokemon
    }

    static let preview: ModelContainer = {
        do {
            let container = try ModelContainer(for: Pokemon.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
            container.mainContext.insert(previewSample)
            return container
        } catch {
            fatalError("Failed to create preview container: \(error)")
        }
    }()
}
