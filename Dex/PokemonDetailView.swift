import SwiftUI

struct PokemonDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var pokemon: Pokemon
    @State private var showShiny = false
    
    var body: some View {
        ScrollView {
            ZStack {
                Image(pokemon.background)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .black, radius: 6)
                
                if pokemon.sprite == nil || pokemon.shiny == nil {
                    AsyncImage(url: showShiny ? pokemon.shinyURL : pokemon.spriteURL) { pokemon in
                        pokemon
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .shadow(color: .black, radius: 6)
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    (showShiny ? pokemon.shinyImage : pokemon.spriteImage)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .shadow(color: .black, radius: 6)
                }
            }
            
            HStack {
                ForEach(pokemon.types!, id: \.self) { type in
                    Text(type.capitalized)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                        .shadow(color: .white, radius: 1)
                        .padding(.vertical, 7)
                        .padding(.horizontal)
                        .background(Color(type.capitalized))
                        .clipShape(.capsule)
                }
                
                Spacer()
                
                Button {
                    pokemon.favorite.toggle()
                    
                    do {
                        try viewContext.save()
                    } catch {
                        print(error)
                    }
                } label: {
                    Image(systemName: pokemon.favorite ? "star.fill" : "star")
                        .font(.title)
                        .foregroundStyle(.yellow)
                }
            }
            .padding()
            
            VStack {
                Text("Stats")
                    .font(.title)
                    .foregroundStyle(.black)
                
                PokemonStatsView(pokemon: pokemon)
            }
        }
        .navigationTitle(pokemon.name!.capitalized)
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
        PokemonDetailView()
            .environmentObject(PersistenceController.previewSample)
    }
}
