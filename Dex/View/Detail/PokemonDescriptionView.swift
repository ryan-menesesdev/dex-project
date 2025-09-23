import SwiftUI

struct PokemonDescriptionView: View {
    @Environment(\.modelContext) private var modelContext
    @State var viewError: ViewError?
    
    var pokemon: Pokemon
    
    var body: some View {
        HStack {
            ForEach(pokemon.types, id: \.self) { type in
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
                    try modelContext.save()
                } catch {
                    pokemon.favorite.toggle()
                    print(error)
                    viewError = .context(.saveFailed)
                }
            } label: {
                Image(systemName: pokemon.favorite ? "star.fill" : "star")
                    .font(.title)
                    .foregroundStyle(.yellow)
            }
        }
        .padding()
        .alert("Error", isPresented: .constant(viewError != nil), presenting: viewError) { error in
            Button("Ok") { viewError = nil }
        } message: { error in
            Text(error.message)
        }
    }
}

#Preview {
    PokemonDescriptionView(pokemon: PersistenceController.previewSample)
}
