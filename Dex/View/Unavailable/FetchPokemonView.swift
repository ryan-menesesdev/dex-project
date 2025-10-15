import SwiftUI

struct FetchPokemonView: View {
    let getPoke: (_ id: Int) -> Void
    
    var body: some View {
        ContentUnavailableView {
            Label("No Pokemon", image:.nopokemon)
        } description: {
            Text("There aren't any Pokemon yet.\nFetch some Pokemon to get started!")
        } actions: {
            Button("Fetch Pokemon", systemImage: "antenna.radiowaves.left.and.right") {
                getPoke(1)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    FetchPokemonView(getPoke: { from in print("Fetching from \(from)") })
}
