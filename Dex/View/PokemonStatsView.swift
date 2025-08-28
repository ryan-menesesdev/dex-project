import Charts
import SwiftUI

struct PokemonStatsView: View {
    var pokemon: Pokemon
    
    var body: some View {
        Chart(pokemon.stats) { stat in
            BarMark(x: .value("Value", stat.value), y: .value("Name", stat.name))
                .annotation(position: .trailing) {
                    Text("\(stat.value)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, -5)
                }
                
        }
        .frame(height: 200)
        .padding(.horizontal)
        .foregroundStyle(pokemon.typeColor)
        .chartXScale(domain: 0...pokemon.highestValue.value + 10)
    }
}

#Preview {
    PokemonStatsView(pokemon: PersistenceController.previewSample)
}
