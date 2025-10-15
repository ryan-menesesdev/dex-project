import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Pokemon.id, animation: .default) private var pokedex: [Pokemon]
    
    @State var textTyped = ""
    @State var filterByFavorites = false
    @State private var viewError: ViewError?
    
    private let fetcher = FetchService()
    
    private var dynamicPredicate: Predicate<Pokemon> {
        #Predicate<Pokemon> { pokemon in
            if filterByFavorites && !textTyped.isEmpty {
                pokemon.favorite && pokemon.name.localizedStandardContains(textTyped)
            } else if !textTyped.isEmpty {
                pokemon.name.localizedStandardContains(textTyped)
            } else if filterByFavorites {
                pokemon.favorite
            } else {
                true
            }
        }
    }
    
    var body: some View {
        Group {
            if pokedex.isEmpty {
                FetchPokemonView(getPoke: getPoke)
            } else {
                NavigationStack {
                    List {
                        Section {
                            ForEach((try? pokedex.filter(dynamicPredicate)) ?? pokedex) { pokemon in
                                PokemonListItem(pokemon: pokemon)
                                .swipeActions(edge: .leading) {
                                    Button(pokemon.favorite ? "Remove from favorites" : "Add to Favorites", systemImage: "star") {
                                        pokemon.favorite.toggle()
                                        do {
                                            try modelContext.save()
                                        } catch {
                                            pokemon.favorite.toggle()
                                            print(error)
                                            viewError = .context(.saveFailed)
                                        }
                                    }
                                }
                            }
                        } footer: {
                            InterruptedFetchPokemonView(getPoke: getPoke, pokedexCount: pokedex.count)
                        }
                    }
                    .navigationDestination(for: Pokemon.self, destination: { pokemon in
                        PokemonDetailView(pokemon: pokemon)
                    })
                    .searchable(text: $textTyped, prompt: "Find a Pokemon")
                    .autocorrectionDisabled()
                    .animation(.default, value: textTyped)
                    .toolbar {
                        ToolbarItem {
                            Button {
                                withAnimation {
                                    filterByFavorites.toggle()
                                }
                            } label: {
                                Image(systemName: filterByFavorites ? "star.fill" : "star")
                                    .foregroundStyle(.yellow)
                            }
                        }
                    }
                    .navigationTitle("Pokedex")
                }
            }
        }
        .alert("Error", isPresented: .constant(viewError != nil), presenting: viewError) { error in
            Button("Ok") { viewError = nil }
        } message: { error in
            Text(error.message)
        }
    }
    
    
    private func getPoke(from id: Int) {
        Task {
            do {
                for id in id..<152 {
                    let fetchedPokemon = try await fetcher.fetchPokemon(id)
                    modelContext.insert(fetchedPokemon)
                }
                
                storePoke()
                
            } catch let fetchError as FetchError {
                print(fetchError)
                viewError = .fetch(fetchError)
            } catch {
                print(error)
                viewError = .context(.insertFailed)
            }
        }
    }
    
    private func storePoke() {
        Task {
            do {
                for pokemon in pokedex {
                    pokemon.sprite = try await URLSession.shared.data(from: pokemon.spriteURL).0
                    
                    pokemon.shiny = try await URLSession.shared.data(from: pokemon.shinyURL).0
                    
                    try modelContext.save()
                    
                    print("Sprites stored: id: \(pokemon.id), name: \(pokemon.name.capitalized)")
                }
            } catch {
                print(error)
                viewError = .context(.spriteSaveFailed)
            }
        }
    }
}

#Preview {
    ContentView().modelContainer(PersistenceController.preview)
}
