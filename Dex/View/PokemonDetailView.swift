import SwiftUI
import SwiftData

struct PokemonDetailView: View {
    @Environment(\.modelContext) private var modelContext
    var pokemon: Pokemon
    
    @State private var showShiny = false
    
    var body: some View {
        ScrollView {
            PokemonImageView(showShiny: $showShiny, pokemon: pokemon)
            
            PokemonDescriptionView(pokemon: pokemon)

            PokemonStatsView(pokemon: pokemon)
        }
        .navigationTitle(pokemon.name.capitalized)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { 
                    showShiny.toggle()
                } label: {
                    Image(systemName: showShiny ? "wand.and.stars" : "wand.and.stars.inverse")
                        .tint(showShiny ? .yellow : .primary)
                        .font(.title2)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PokemonDetailView(pokemon: PersistenceController.previewSample)
    }
}
