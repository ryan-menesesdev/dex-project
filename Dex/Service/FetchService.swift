import Foundation

@MainActor
struct FetchService {
    
    enum FetchError: Error {
        case badResponse
    }
    
    private let baseUrl = URL(string:"https://pokeapi.co/api/v2/pokemon")!
    
    func fetchPokemon(_ id: Int) async throws -> Pokemon {
        let fetchUrl = baseUrl.appending(path: String(id))
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let (data, response) = try await URLSession.shared.data(from: fetchUrl)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        let pokemon = try decoder.decode(Pokemon.self, from: data)
        
        print("Pokemon id: \(pokemon.id), name: \(pokemon.name)")
        
        return pokemon
    }
}
