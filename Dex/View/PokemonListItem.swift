import SwiftUI

struct PokemonListItem: View {
    var pokemon: Pokemon
    
    var body: some View {
        NavigationLink(value: pokemon) {
            
            if pokemon.sprite == nil {
                AsyncImage(url: pokemon.spriteURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 90)
            } else {
                pokemon.spriteImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 90)
            }
            
            VStack(alignment: .leading){
                HStack {
                    Text(pokemon.name.capitalized)
                        .fontWeight(.bold)
                    
                    if pokemon.favorite {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                    }
                }
                
                HStack {
                    ForEach(pokemon.types, id: \.self) { type in
                        Text(type.capitalized)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(type.capitalized))
                            .clipShape(.capsule)
                    }
                }
            }
        }
    }
}

#Preview {
    PokemonListItem(pokemon: PersistenceController.previewSample)
}
