import SwiftUI

struct InterruptedFetchPokemonView: View {
    let getPoke: (_ id: Int) -> Void
    var pokedexCount: Int
    
    var body: some View {
        if pokedexCount < 151 {
            ContentUnavailableView {
                Label("Missing Pokemon", image: .nopokemon)
            } description: {
                Text("The fetch was interrupted!\nFetch the rest of the Pokemon")
            } actions: {
                Button("Fetch Pokemon", systemImage: "antenna.radiowaves.left.and.right") {
                    getPoke(pokedexCount + 1)
                }
                .buttonStyle(.borderedProminent)
            }

        }
    }
}

#Preview {
    InterruptedFetchPokemonView(
        getPoke: { from in print("Fetching from \(from)") },
        pokedexCount: 100
    )
}
