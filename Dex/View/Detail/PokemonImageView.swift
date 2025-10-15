import SwiftUI

struct PokemonImageView: View {
    @Binding var showShiny: Bool
    
    var pokemon: Pokemon
    
    var body: some View {
        ZStack {
            Image(pokemon.background)
                .resizable()

                .shadow(color: .black, radius: 6)
            
            if pokemon.sprite == nil || pokemon.shiny == nil {
                AsyncImage(url: showShiny ? pokemon.shinyURL : pokemon.spriteURL) { pokemon in
                    pokemon
                        .interpolation(.none)
                        .resizable()

                        .shadow(color: .black, radius: 6)
                } placeholder: {
                    ProgressView()
                }
            } else {
                (showShiny ? pokemon.shinyImage : pokemon.spriteImage)
                    .interpolation(.none)
                    .resizable()

                    .shadow(color: .black, radius: 6)
            }
        }
        .frame(height: 400)
    }
}

#Preview {
    PokemonImageView(showShiny: .constant(false), pokemon: PersistenceController.previewSample)
}
