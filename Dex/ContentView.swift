import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest<Pokemon>(sortDescriptors: [])
    private var allPokemon
    
    @FetchRequest<Pokemon>(sortDescriptors: [SortDescriptor(\.id)], animation: .default)
    private var pokedex
    
    private let fetcher = FetchService()
    @State var textTyped = ""
    @State var filterByFavorites = false
    
    private var dynamicPredicate: NSPredicate {
        var predicates: [NSPredicate] = []
        
        if !textTyped.isEmpty {
            predicates.append(NSPredicate(format: "name contains[c] %@", textTyped))
        }
        
        if filterByFavorites {
            predicates.append(NSPredicate(format: "favorite == %d", true))
        }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    var body: some View {
        if allPokemon.isEmpty {
            ContentUnavailableView {
                Label("No Pokemon", image:.nopokemon)
            } description: {
                Text("There aren't any Pokemon yet.\nFetch some Pokemon to get started!")
            } actions: {
                Button("Fetch Pokemon", systemImage: "antenna.radiowaves.left.and.right") {
                    getPoke(from: 1)
                }
                .buttonStyle(.borderedProminent)
            }
        } else {
            NavigationStack {
                List {
                    Section {
                        ForEach(pokedex) { pokemon in
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
                                        Text(pokemon.name!.capitalized)
                                            .fontWeight(.bold)
                                        
                                        if pokemon.favorite {
                                            Image(systemName: "star.fill")
                                                .foregroundStyle(.yellow)
                                        }
                                    }
                                    
                                    HStack {
                                        ForEach(pokemon.types!, id: \.self) { type in
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
                            .swipeActions(edge: .leading) {
                                Button(pokemon.favorite ? "Remove from favorites" : "Add to Favorites", systemImage: "star") {
                                    pokemon.favorite.toggle()
                                    do {
                                        try viewContext.save()
                                    } catch {
                                        print(error)
                                    }
                                }
                            }
                        }
                    } footer: {
                        if allPokemon.count < 151 {
                            ContentUnavailableView {
                                Label("Missing Pokemon", image: .nopokemon)
                            } description: {
                                Text("The fetch was interrupted!\nFetch the rest of the Pokemon")
                            } actions: {
                                Button("Fetch Pokemon", systemImage: "antenna.radiowaves.left.and.right") {
                                    getPoke(from: pokedex.count + 1)
                                }
                                .buttonStyle(.borderedProminent)
                            }

                        }
                    }
                }
                .navigationDestination(for: Pokemon.self, destination: { pokemon in
                    PokemonDetailView()
                        .environmentObject(pokemon)
                })
                .searchable(text: $textTyped, prompt: "Find a Pokemon")
                .autocorrectionDisabled()
                .onChange(of: textTyped) {
                    pokedex.nsPredicate = dynamicPredicate
                }
                .onChange(of: filterByFavorites) {
                    pokedex.nsPredicate = dynamicPredicate
                }
                .toolbar {
                    ToolbarItem {
                        Button {
                            filterByFavorites.toggle()
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
    
    private func getPoke(from id: Int) {
        Task {
            do {
                for id in id..<152 {
                    let fetchedPokemon = try await fetcher.fetchPokemon(id)
                    let pokemon = Pokemon(context: viewContext)
                    
                    pokemon.id = fetchedPokemon.id
                    pokemon.name = fetchedPokemon.name
                    pokemon.types = fetchedPokemon.types
                    pokemon.hp = fetchedPokemon.hp
                    pokemon.attack = fetchedPokemon.attack
                    pokemon.defense = fetchedPokemon.defense
                    pokemon.specialAttack = fetchedPokemon.specialAttack
                    pokemon.specialDefense = fetchedPokemon.specialDefense
                    pokemon.speed = fetchedPokemon.speed
                    pokemon.spriteURL = fetchedPokemon.spriteURL
                    pokemon.shinyURL = fetchedPokemon.shinyURL
                    
                    try viewContext.save()
                }
            } catch {
                    print(error)
            }
            storePoke()
        }
    }
    
    private func storePoke() {
        Task {
            do {
                for pokemon in allPokemon {
                    pokemon.sprite = try await URLSession.shared.data(from: pokemon.spriteURL!).0
                    
                    pokemon.shiny = try await URLSession.shared.data(from: pokemon.shinyURL!).0
                    
                    try viewContext.save()
                    
                    print("Sprites stored: id: \(pokemon.id), name: \(pokemon.name!.capitalized)")
                }
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
