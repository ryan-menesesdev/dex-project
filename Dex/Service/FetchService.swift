import Foundation

@MainActor
struct FetchService {
    private let urlString = "https://pokeapi.co/api/v2/pokemon"
    
    func fetchPokemon(_ id: Int) async throws -> Pokemon {
        guard let baseUrl = URL(string: urlString) else {
            throw FetchError.badURL
        }
        
        let fetchUrl = baseUrl.appending(path: String(id))
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let (data, response) = try await URLSession.shared.data(from: fetchUrl)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        do {
            let pokemon = try decoder.decode(Pokemon.self, from: data)
            print("Pokemon id: \(pokemon.id), name: \(pokemon.name)")
            return pokemon
        } catch {
            throw FetchError.decodingError
        }
    }
}
