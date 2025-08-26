//
//  PokemonDetail.swift
//  Dex
//
//  Created by Ryan Davi Oliveira de Meneses on 26/08/25.
//

import SwiftUI

struct PokemonDetail: View {
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
                
                AsyncImage(url: showShiny ? pokemon.shiny : pokemon.sprite) { pokemon in
                    pokemon
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .shadow(color: .black, radius: 6)
                } placeholder: {
                    ProgressView()
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
                    .font(.largeTitle)
                    .foregroundStyle(.black)
            }
        }
        .navigationTitle(pokemon.name!.capitalized)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Show shiny color", systemImage:"slider.horizontal.3") {
                    showShiny.toggle()
                }
            }
                
            
        }
    }
}

#Preview {
    NavigationStack {
        PokemonDetail()
            .environmentObject(PersistenceController.previewSample)
    }
}
